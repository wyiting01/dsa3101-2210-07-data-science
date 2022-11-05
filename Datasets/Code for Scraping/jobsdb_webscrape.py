from bs4 import BeautifulSoup as bs
import requests as req
import pickle
import pandas as pd
import numpy as np
import os

with (open('/Users/aaron/Desktop/db_url_set.pkl', "rb")) as openfile:
    url_set = pickle.load(openfile)
    url_ls = list(url_set)

def stringclean(string):
    ls = string.split(' ')
    start = ''
    for ele in ls:
        start = start + ele + '+'
    return start[:-1]

df = pd.DataFrame(columns=['url','title','coloc','sub_clean','sub_dirty','desc_dirty','desc_clean'])

def fclone(url):
    global df
    html = req.get(url).text
    soup = bs(html, 'html.parser')
    title = soup.find('h3', class_="job-title heading-xxlarge").get_text()
    co = soup.find('span', class_='company').get_text()
    loc = soup.find('span', class_='location').get_text()
    coloc = co+','+loc
    main = soup.find('main')
    sub_dirty = main.find_all('div', class_='content')
    sub_clean = []
    for i in sub_dirty:
        sub_clean.append(i.get_text())
    desc_dirty = soup.find(id = 'job-description-container')
    desc_clean = desc_dirty.get_text()
    ls = [url,title, coloc, sub_clean, sub_dirty, desc_dirty, desc_clean]
    df = df.append(pd.DataFrame([ls],
                    columns=['url','title','coloc','sub_clean','sub_dirty','desc_dirty','desc_clean']),
                    ignore_index=True)
for i in url_ls:
    try:
        response = req.get(i)
        if 'sg.jobsdb.com' in response.url:
            fclone(i)
        else:
            continue
    except:
        print(i)
        continue

    
os.makedirs('/Users/aaron/Desktop/test', exist_ok=True)  
df.to_csv('/Users/aaron/Desktop/test/out.csv')
