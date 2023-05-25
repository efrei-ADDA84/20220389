<div class="pull-left"> 
<img src="https://res.cloudinary.com/practicaldev/image/fetch/s--lBhxYAou--/c_imagga_scale,f_auto,fl_progressive,h_900,q_auto,w_1600/https://raw.githubusercontent.com/Pwd9000-ML/blog-devto/main/posts/2022/GitHub-Docker-Runner-Azure-Part4/assets/main.png" > 
</div> 

---
<center> <b> <FONT size="5pt">DevOps-TP3 : Deployer une image Docker Image sur Azure

20220389 </FONT></b></center> 

---  

## 1) <u>Description du projet </u>  

Le TP3 a pour but de automatiser les processus de créer une image et la déployer sur un Container Azure.
<img src="https://repository-images.githubusercontent.com/225716226/6762dd00-6aa2-11ea-912d-7cfb0e2457f6" > 
</div>   

## 2) <u>Codage du WeatherApiWrapper.py </u>

On a repris le même code que le tp2

## 3) <u>Création de l'image Docker</u>

### 3.1) Dockerfile  
On a repris le même dockerfile que le tp2

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
