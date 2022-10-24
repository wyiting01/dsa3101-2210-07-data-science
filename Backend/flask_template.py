from flask import Flask, request, jsonify, render_template
import pickle
import numpy as np
import pandas as pd
import nltk
from nltk.corpus import stopwords
from nltk.stem import PorterStemmer
from sklearn.metrics.pairwise import cosine_similarity
import re


# Load Model and Data
df_combined = pd.read_csv('processed_data.csv')
with open('tfidf_vectorizer.pkl', 'rb') as f:
    vectorizer = pickle.load(f)
with open('tfidf_job.pkl','rb') as g:
    matrix = pickle.load(g)
df_articles = pd.read_csv('articlesfrommedium.csv')

#declare variables
rating_dict = {
    "five_stars": "0",
    "four_stars": "0",
    "three_stars": "0",
    "two_stars": "0",
    "one_star": "0",
    "count": "0",
    "total": "0",
    "rating": "0"
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

    #Compute Scores
    scores = cosine_similarity(recommendation_tf_idf,matrix)[0]

    #Set scores of those which underpay to 0
    underpay_ind = df_combined[df_combined['max_pay']< min_salary].index
    scores[underpay_ind] = 0

    #Index of top 10 recommended jobs
    ind = np.argpartition(scores,-10)[-10:][::-1]

    #Return for display
    result_dict = {}
    result_dict['index'] = [int(i) for i in ind]
    result_dict['title'] = list(df_combined['job_title'][ind])
    result_dict['company_name'] = list(df_combined['company'][ind])
    result_dict['location'] = list(df_combined['location'][ind])
    result_dict['hours'] = list(df_combined['job_type'][ind])
    result_dict['min_salary'] = list(df_combined['min_pay'][ind])
    result_dict['max_salary'] = list(df_combined['max_pay'][ind])
    result_dict['url'] = list(df_combined['url'][ind])
    result_dict['relevant_skills'] = list(df_combined['description_clean'][ind].map(lambda x: [i for i in skills.split() if i.lower() in x.split()]))
    result_dict['similarity_scores'] = [float(i) for i in scores[ind]]
    result_dict['clicks'] = [clicks_dict[i] for i in ind]
    return jsonify(result_dict)


#Instantiate the dictionary:
for i in range(len(df_combined)):
    clicks_dict[i] = 0

#Increment click Count, unsure whether this shud be post or put (might be patch)
@app.route('/add_click',methods = ["PUT"])
def add_click():
    return


#Generate Articles
@app.route('/get_articles')
def generate_articles():
    length = len(df_articles)
    index = np.random.randint(0, length-1, 10)
    article_dict = {}
    article_dict['index'] = [int(i) for i in index]
    article_dict['title'] = list(df_articles['title'][index])
    article_dict['url'] = list(df_articles['url'][index])
    article_dict['tag'] = list(df_articles['tag'][index])
    return jsonify(article_dict)

#User input for recommendation rating
@app.route('/update_rating',methods = ["POST"])
def add_rating():
    if 'rating' in request.form:
        content = int(request.form['rating'])
        if content:
            if content == 5:
                rating_dict['five_stars'] += 1
            elif content == 4:
                rating_dict['four_stars'] += 1
            elif content == 3:
                rating_dict['three_stars'] += 1
            elif content == 2:
                rating_dict['two_stars'] += 1
            elif content == 1:
                rating_dict['one_star'] += 1
            rating_dict['count'] += 1
            rating_dict['total'] += content
            rating_dict['rating'] = rating_dict['total']/rating_dict['count']
    return render_template('rating.html', five_stars=rating_dict['five_stars'], four_stars=rating_dict['four_stars'], three_stars=rating_dict['three_stars'], two_stars=rating_dict['two_stars'], one_star=rating_dict['one_star'], count=rating_dict['count'], rating=rating_dict['rating'])


#Get average rating
@app.route('/get_rating')
def get_average_rating():
    curr_avg_rating = rating_dict['rating']
    return f'Average Rating: {curr_avg_rating}'


#Helper Functions
def rm_stopwords(tokens):
    return [i for i in tokens if i not in stop_words and i]

def stem_words(tokens):
    return [ps.stem(i) for i in tokens]

def preprocess_input(input_str):
    input_str = re.sub('[^A-Za-z0-9]+', ' ', input_str)
    input_str = input_str.lower()
    input_str = input_str.split()
    input_str = rm_stopwords(input_str)
    input_str = stem_words(input_str)
    return list(input_str)
