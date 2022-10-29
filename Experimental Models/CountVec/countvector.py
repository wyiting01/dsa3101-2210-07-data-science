import pandas as pd
import numpy as np
import nltk
from nltk.corpus import stopwords
import re
import string
from nltk.stem import PorterStemmer
from nltk import word_tokenize
from nltk.corpus import stopwords
import ssl

try:
    #prevent SSL error
    _create_unverified_https_context = ssl._create_unverified_context
except AttributeError:
    pass
else:
    ssl._create_default_https_context = _create_unverified_https_context

##install all packages required from nltk
#nltk.download('punkt')
#nltk.download('stopwords')
#nltk.download('wordnet')
#nltk.download('averaged_perceptron_tagger')
#nltk.download('omw-1.4')

#read the csv
df = pd.read_csv("../../Datasets/processed_data.csv")

#create list of stopwords
stop = stopwords.words('english')
stop_words_ = set(stopwords.words('english'))
#nltk stemmer
ps = PorterStemmer()

#wanted text
def black_txt(token):
    return token not in stop_words_ and token not in list(string.punctuation)  and len(token)>2   

#remove unncessary text 
def clean_txt(text):
  clean_text = []
  clean_text2 = []
  #remove special characters
  text = re.sub("'", "",text)
  text = re.sub("(\\d|\\W)+"," ",text) 
  text = text.replace("nbsp", "")
  #stem cleaned text
  clean_text = [ps.stem(word) for word in word_tokenize(text.lower()) if black_txt(word)]
  clean_text2 = [word for word in clean_text if black_txt(word)]
  return " ".join(clean_text2)

from sklearn.feature_extraction.text import CountVectorizer
count_vectorizer = CountVectorizer()

#fitting and transforming the vector
count_job = count_vectorizer.fit_transform((df['full_info_tokens']))
count_vectorizer.get_feature_names_out()
#count_job

from sklearn.metrics.pairwise import cosine_similarity
def generate_recommendations(user_input):
    #convert to string
    input_text = " ".join(user_input)
    #clean input
    input_text = clean_txt(input_text)
    #transform input using tfidf_vectorizer
    vec_input = count_vectorizer.transform([str(input_text)])
    #compute cosine similarity scores between input and every job entry
    cos_similarity_countv = map(lambda x: cosine_similarity(vec_input, x),count_job)
    #return top 10 jobs with highest cosine similarity scores
    scores = list(cos_similarity_countv)
    top = sorted(range(len(scores)), key=lambda i: scores[i], reverse=True)[:10]
    return df.iloc[top,:]

xgtest = ["python","R","sql","git","flask","docker"]
#test_input=["Computer Science","Information Technology","software development","project management","design document","Software product specifications","architectural styles"]
#generate_recommendations(test_input)
