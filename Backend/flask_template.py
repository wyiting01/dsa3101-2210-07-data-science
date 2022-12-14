from flask import Flask, request, jsonify, render_template
import pickle
import numpy as np
import pandas as pd
import nltk
from nltk.corpus import stopwords
from nltk.stem import PorterStemmer
from sklearn.metrics.pairwise import cosine_similarity
import re
import math
import ast

# Load Model and Data
df_combined = pd.read_csv('processed_data.csv')
with open('tfidf_vectorizer.pkl', 'rb') as f:
    vectorizer = pickle.load(f)
with open('tfidf_job.pkl','rb') as g:
    matrix = pickle.load(g)
df_articles = pd.read_csv('articlesfrommedium.csv')
key_terms = pd.read_csv('key_terms.csv')

#declare variables
rating_dict = {
    "five_stars": 0,
    "four_stars": 0,
    "three_stars": 0,
    "two_stars": 0,
    "one_star": 0,
    "count": 0,
    "total": 0,
    "rating": 0
}
clicks_dict ={}
nltk.download('stopwords')
stop_words = set(stopwords.words('english'))
ps = PorterStemmer()
app = Flask(__name__)


#Generate Recommendations
'''
user_input = {
'expected_salary': 4000,
'expected_hours': 'full time',
'job_title':['Data Analyst','Data Scientist'],
'location': ['Tampines', 'Simei'],
'industry': ['Social media','Healthcare'],
'skills': ['SQL','R','Python','Git','Flask']
}

x = requests.post('http://127.0.0.1:5000/recommendation',json=user_input)
output = x.json()
'''
@app.route("/recommendation", methods=["POST","GET"])
def generate_recommendation():
    user_input = request.get_json()
    #Set expected salary variable for filtering
    min_salary = user_input['expected_salary']

    #For sieving out relevant skills later
    skills = " ".join(user_input['skills'])

    #Build corpus for recommender system
    corpus = []
    for i in user_input:
        if i=='expected_salary':
            continue
        elif isinstance(user_input[i],list):
            corpus.extend(user_input[i])
        else:
            corpus.append(user_input[i])

    #Preprocess the Corpus
    corpus_str = " ".join(corpus)
    corpus_str_processed = preprocess_input(corpus_str)

    #Vectorize
    recommendation_tf_idf = vectorizer.transform([str(corpus_str_processed)])

    #Compute Similarity Scores
    scores = cosine_similarity(recommendation_tf_idf,matrix)[0]

    #Set scores of those which underpay to 0 to remove them from consideration
    underpay_ind = df_combined[df_combined['max_pay']< min_salary].index
    scores[underpay_ind] = 0

    #Index of top 10 recommended jobs
    top_10_indexes = list(np.argpartition(scores,-10)[-10:][::-1])

    #Sort the indexes by recommendation score
    ind = sorted(top_10_indexes,key = lambda x: scores[x], reverse=True)

    #Return information requested by front-end team
    result_dict = {}
    result_dict['index'] = [int(i) for i in ind]
    result_dict['title'] = list(df_combined['job_title'][ind])
    result_dict['company_name'] = list(df_combined['company'][ind])
    result_dict['location'] = list(df_combined['location'][ind])
    result_dict['hours'] = list(df_combined['job_type'][ind])
    result_dict['min_salary'] = list(df_combined['min_pay'][ind])
    result_dict['max_salary'] = list(df_combined['max_pay'][ind])
    result_dict['url'] = list(df_combined['url'][ind])
    #Relevant skills are derived by looking for terms that appear both in the user's skills and the description of the job
    result_dict['relevant_skills'] = list(df_combined['description_clean'][ind].map(lambda x: [i for i in skills.split() if i.lower() in x.split()]))
    result_dict['similarity_scores'] = [float(i) for i in scores[ind]]
    result_dict['linear_score'] = [(1-(math.acos(i)/(math.pi/2)))*100 for i in scores[ind]]
    result_dict['clicks'] = [clicks_dict[i] for i in ind]
    return jsonify(result_dict)


#Instantiate the dictionary to track number of clicks:
for i in range(len(df_combined)):
    clicks_dict[i] = 0

#Increment click Count
'''
user_input = {'url':'https://www.mycareersfuture.gov.sg/job/customer-service/production-control-manager-snl-logistics-0c5bc4f0f94d1bec1b79d160dce04603?source=MCF&event=Search'}
x = requests.post('http://127.0.0.1:5000/add_click', json = user_input)
output = x.text
'''
@app.route('/add_click',methods = ["POST"])
def add_click():
    #finds the index of the url being clicked and increments its clickcount
    url = request.get_json()['url']
    index = df_combined[df_combined['url']==url].index.values[0]
    clicks_dict[index] += 1
    return str(clicks_dict[index])

#Generate Articles
'''
x = requests.get('http://127.0.0.1:5000/get_articles')
output = x.json()
'''
@app.route('/get_articles', methods = ["GET"])
def generate_articles():
    length = len(df_articles)
    #Pick 10 random articles from df_articles and return their info
    index = np.random.randint(0, length-1, 10)
    article_dict = {}
    article_dict['index'] = [int(i) for i in index]
    article_dict['title'] = list(df_articles['title'][index])
    article_dict['url'] = list(df_articles['url'][index])
    article_dict['tag'] = list(df_articles['tag'][index])
    return jsonify(article_dict)

#User input for recommendation rating 
'''
user_rating_input = {
'rating': 3
}

x = requests.post('http://127.0.0.1:5000/update_rating', json = user_rating_input)
output = x.json()
'''
@app.route('/update_rating', methods=["POST","GET"])
def add_rating():
    user_input = request.get_json()
    user_input_rating = int(user_input['rating'])
    #Update the count for each rating based on user input
    if user_input_rating == 5:
        rating_dict['five_stars'] += 1
    elif user_input_rating == 4:
        rating_dict['four_stars'] += 1
    elif user_input_rating == 3:
        rating_dict['three_stars'] += 1
    elif user_input_rating == 2:
        rating_dict['two_stars'] += 1
    elif user_input_rating == 1:
        rating_dict['one_star'] += 1
    #Keeping track of the sum and total number of ratings to compute average rating
    rating_dict['count'] += 1
    rating_dict['total'] += user_input_rating
    rating_dict['rating'] = rating_dict['total']/rating_dict['count']
    return jsonify(rating_dict)

#Get average rating (for monitoring purposes)
'''
x = requests.get('http://127.0.0.1:5000/get_rating')
output = x.text
'''
@app.route('/get_rating', methods=["GET"])
def get_average_rating():
    #returns average rating to 2 decimal places
    curr_avg_rating = rating_dict['rating']
    return f'{round(curr_avg_rating, 2)}'

#Obtain key terms for each job title
'''
x = requests.get('http://127.0.0.1:5000/key_terms', params={'title':'data analyst'})
output = x.json()

possible inputs for 'title'= ["banking", "it","project manager",
"software developer","product manager","data science","sales","cybersecurity",
"electrical engineer","ai and nlp"]
'''
@app.route('/key_terms',methods=["GET"])
def get_key_terms():
    result = {}
    title = request.args.get('title')
    #searches key_terms for the key terms given the job title
    try:
        index = key_terms[key_terms['title']==title].index.values[0]
        result['key_terms']=ast.literal_eval(key_terms['key_terms'][index])
        return jsonify(result)
    except:
        return jsonify(result)

#Helper Functions

#Removes stopwords from user input
def rm_stopwords(tokens):
    return [i for i in tokens if i not in stop_words and i]

#Stems the words in the user input
def stem_words(tokens):
    return [ps.stem(i) for i in tokens]

#data preprocessing pipeline for user input
def preprocess_input(input_str):
    input_str = re.sub('[^A-Za-z0-9]+', ' ', input_str)
    input_str = input_str.lower()
    input_str = input_str.split()
    input_str = rm_stopwords(input_str)
    input_str = stem_words(input_str)
    return list(input_str)
