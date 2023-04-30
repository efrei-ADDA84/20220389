<div class="pull-left"> 
<img src="https://ianwhitestone.work/images/docker-gcr-ga/docker-ga-gcr.png" > 
</div> 

---
<center> <b> <FONT size="5pt">DevOps-TP2 : Docker et Github Actions  

20220389 </FONT></b></center> 

---  

## 1) <u>Description du projet </u>  

Le TP2 a pour but de automatiser les processus de créer une image et la déployer sur Docker Hub.
<img src="https://repository-images.githubusercontent.com/225716226/6762dd00-6aa2-11ea-912d-7cfb0e2457f6" > 
</div>   

## 2) <u>Codage du WeatherApiWrapper.py </u>

### 2.1) Choix du langage de programmation  

Le langage de programmation utilisé pour coder le wrapper est Python. Le choix du lagage est dû à la facilité de codage. De plus, Python possède des librairies intéressantes pour travailler avec des API, notamment <b>Flask</b> et <b>Fast API</b>. Nous allons utiliser <b>Flask</b>.

### 2.2) Les librairies
- <b> Flask</b> : un microframework qui permet de developper des applications web avec Python.

- <b> requests</b> : une libraire HTTP pour Python qui permet de rendre les requêtes HTTP plus simple à manipuler.

- <b> sys </b> : Nous avons utilisé la fonction <I>argv</I> de la librairie <b>sys</b> pour récupérer les arguments passés en paramètre lors de l'appel de la fonction.   
exemple :  
 - `lat = argv[1]` permet de récupérer le premier élément passé en paramètre.  

### 2.3) Explication du code
- On instance notre objet Flask. Ensuite, on utilise le decorateurs `route` pour associer un URL à une fonction. Ici on associe `/` et on veut faire une requête `GET`  
`app = Flask(__name__) `   
`@app.route("/", methods= ["GET"])`  
- On définit ensuite la fonction `result`. On récupère  la latitude `lat`et la longitude `lon` depuis l'URL grâce à la fonction `request.args.get('---')` et `API_KEY` est donnée lors de l'appel de la fonction.  
- `lat` indique la latitude
- `long` indique la longitude
- `API_KEY` indique la clé secrète pour pouvoir récupérer les données grâce à l'API. On la passe pendant l'appel.


url = "https://api.openweathermap.org/data/2.5/weather?lat={lat}&lon={lon}&appid={argv[1]}"

 `response = requests.get(url).json()` : on récupère les données grâce à la fonction `get` de <b>requests</b> et on l'affiche sous format json.

- la fonction `run` permet d'executer notre application dans le port 8081.
 `if __name__ == '__main__' :`  
    `app.run(debug=True, port=8081, host="0.0.0.0")`  

<span style="color: #FF0000"> Problème rencontré</span> :  
Au début, nous n'avons pas écrit le host. Nous n'avons pas réussi à avoir le résultat une fois que l'image docker est crée.
`if __name__ == '__main__' :`  
    `app.run(debug=True, port=8081)`  

<span style="color: #26B260"> Solution</span> :  On devait spécifier le port `host="0.0.0.0"` pour avoir le résultat.


## 3) <u>Création de l'image Docker</u>

### 3.1) Dockerfile  
Le Dockerfile permet de créer rapidement une image pour la rendre partageable plus facilement.

Nous allons utiliser les paramètres suivants pour indiquer les informations :

- <b>FROM</b> : il permet de partir d'une image avec le minimum de fonctionnalités. On a pris `python3.9`.
- <b>WORKDIR</b>  : permet d'indiquer le repertoire où se trouvera notre image Docker.
- <b>ARG</b> : on indique les variables d'environnements
- <b>ENV</b> : affectation aux variables d'environnements les valeurs passées pendant l'appel.
- <b>COPY</b> : on copie le fichier indiqué, dans notre cas, WeatherApiWrapper.py dans `/app`.
- <b>RUN</b> : permet d'exécuter les commande. Ici, on va éxcuter un `pip3 install` pour la librairie `requests` et `flask`. on ajoute `--no-cache-dir` permet de garder l'image Docker moins lourd sans les dossiers de caches.
- <b>CMD</b> : indique la commande à executer au démarage du containeur. `sh` et `-c` permet d'informer que c'est au format shell.

## 4) <u>Configuration de gitHub Actions</u>

Nous allons configurer le fichier `main.yml` dans `.github/workflows` pour configurer le pipeline de gitHub Actions.  

- Ici, on indique qu'on commence le Github Actions dès qu'il y a `push` ou un `pull` dans la branche `main`.      
`on:`  
  	`push:`  
    `branches: [ "main" ]`  
  `pull_request:`  
    `branches: [ "main" ]`  


- Dans `Jobs`, on indique la tâche à faire, plus précisement en sous tâches grâce aux `steps`.

    `steps:`  
- 1ère tâche : Récupérer le code source du référentiel et le rendre disponible pour les autres étapes du workflow   
    `- name : Checkout`  
      `uses: actions/checkout@v3`

- 2eme tâche : Se connecter à Docker Hub. On a stocké dans secret le ID et le TOKEN généré par Docker Hub.  
    `- name : Login to Docker Hub`
      `uses : docker/login-action@v1`
      `with :`
        `username : ${{secrets.ID_DOCKER_HUB}}`
        `password : ${{secrets.PASSWD_DOCKER_HUB}}`

- 3eme tâche : Buildx est une fonctionnalité de Docker qui permet de créer des images Docker pour différentes architectures et plateformes.   
    `- name: Set up Docker Buildx`
      `uses: docker/setup-buildx-action@v2`

- 4eme tâche : On crée et on pousse l'objet dans Docker Hub.  Dans un context, on indique où on doit chercher le Dockerfile. Le tag indique le registry/repertoire/numero de l'execution  
    `- name: Build and push to Docker Hub`
      `uses :  docker/build-push-action@v2`  
      `with:`  
        `context : ./tp2`  
        `push: true`  
        `tags:suveta/tp1devops:${{github.run_number}}`

Il suffit donc de push sur Git et une image Docker sera crée et poussée dans Docker Hub. 


## 5) <u>Vérification</u>
- Pour la vérification, nous allon télécharger notre image depuis notre registry avec la commande `docker pull suveta/tp1devops:20`

- Une fois l'image téléchargé, on exécute la commande suivante : `docker run -p 8081:8081 -it --env API_KEY=*** suveta/tp1devops:20` en remplaçant par votre clé. Vous aurez le résultat attendu.

- Il suffit d'éxecuter cette commande pour avoir le résultat:  
`curl "http://localhost:8081/?lat=5.902785&lon=102.754175"`

<span style="color: #26B260">resultat</span> :
`{
  "base": "stations",
  "clouds": {
    "all": 80
  },
  "cod": 200,
  "coord": {
    "lat": 5.9028,
    "lon": 102.7542
  },
  "dt": 1682787712,
  "id": 1736405,
  "main": {
    "feels_like": 302.71,
    "grnd_level": 981,
    "humidity": 75,
    "pressure": 1008,
    "sea_level": 1008,
    "temp": 300.29,
    "temp_max": 300.29,
    "temp_min": 300.29
  },
  "name": "Jertih",
  "sys": {
    "country": "MY",
    "sunrise": 1682808993,
    "sunset": 1682853348
  },
  "timezone": 28800,
  "visibility": 10000,
  "weather": [
    {
      "description": "broken clouds",
      "icon": "04n",
      "id": 803,
      "main": "Clouds"
    }
  ],
  "wind": {
    "deg": 116,
    "gust": 3.02,
    "speed": 2.66
  }
}`.

<span style="color: #FF0000"> Problème rencontré</span> :  
La commande initiale était `docker run --network host --env API_KEY=**** maregistry/efrei-devops-tp2:1.0.0` mais `--network host` n'était pas reconnu.

<span style="color: #26B260"> Solution</span> :  Il faut choisir le network suivant  
`-p 8081:8081`.

## 6) <u>Partie Bonus</u>

- le code python ne contient aucune information secrète en claire. L'utilisateur indique la clé de l'API lors de l'appel de la fonction.

- La commande pour vérifier si notre Dockerfile est bien rédigé. on a utilisé la commande `docker run --rm -i hadolint/hadolint < Dockerfile`. On a eu 0 erreurs.

