FROM python:3.9-slim-buster

WORKDIR /app

COPY requirements.txt requirements.txt
COPY flask_template.py flask_template.py
COPY tfidf_job.pkl tfidf_job.pkl 
COPY tfidf_vectorizer.pkl tfidf_vectorizer.pkl
COPY processed_data.csv processed_data.csv
COPY articlesfrommedium.csv articlesfrommedium.csv
COPY key_terms.csv key_terms.csv

RUN pip3 install -r requirements.txt

ENV FLASK_APP flask_template

ENTRYPOINT [ "python", "-u", "-m", "flask", "run", "--host=0.0.0.0"]


##docker build . -t reco 
##docker run --name reco_test -p5000:5000 -d reco
