from flask import Flask, request, jsonify, send_file, render_template
from werkzeug.utils import secure_filename
import joblib
import numpy as np
import pandas as pd

# Load Model and Data
df_combined =
df_articles =
recommender =

#declare variables
ratings_list = []
clicks_dict ={}

app = Flask(__name__)


#Generate Recommendations
@app.route("/recommendation", methods=["POST","GET"])
def generate_recommendation():
    return

#Increment click Count, unsure whether this shud be post or put
@app.route('/add_click',methods = ["PUT"])
def add_click():
    return

#Return click count
@app.route('/get_click',methods = ["GET"])
def get_click():
    return

#Generate Articles
@app.route('/get_articles',methods = ["GET"])
def generate_articles():
    return


#User input for recommendation rating
@app.route('/update_rating',methods = ["POST"])
def add_rating():
    return

#Get average rating
@app.route('/get_rating', methods = ['GET'])
def get_average_rating():
    return
