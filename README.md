# dsa3101-2210-07-data-science

## Instructions to Run Backend Model
<p> 1. Enter the Backend directory <p>
<p> 2. Run the following command to build the image 'reco' <p>

```
docker build . -t reco 
```
<p> 3. Run the following command to run the container 'reco_test' on port 5000 </p>

```
docker run --name reco_test -p5000:5000 -d reco
```

<p> 4. To test whether the container is running correctly. The code below (in Python) should return a JSON containing information of Data Science articles from Medium </p>

```python
import requests
x = requests.get('http://127.0.0.1:5000/get_articles')
x.json()
```

<p> 5. Code examples and sample inputs for other functions in the API are provided as comments in flask_template.py </p>
