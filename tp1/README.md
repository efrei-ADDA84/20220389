<div class="pull-left"> 
<img src="https://assets-global.website-files.com/6064b31ff49a2d31e0493af1/63a2fd04f7078f9ab787025f_dockerhub.svg" width=150 > 
</div> 

---
<center> <b> <FONT size="5pt">DevOps-TP1 : Docker  

20220389 </FONT></b></center> 

---  

## 1) <u>Description du projet </u>  

Le TP1 a pour but de se familiariser avec l'envrionnement Docker en créeant notre première docker image et en la déployant sur DockerHub.  
Nous allons donc coder un Wrapper qui retourne la météo d'un lieu donné par sa latitude et longitude grâce à l'API OpenWeather.  

## 2) <u>Codage du WeatherWrapper.py </u>

### 2.1) Choix du langage de programmation  

Le langage de programmation utilisé pour coder le wrapper est Python. Le choix du lagage est dû à la facilité de codage. De plus, Python étant un langage interprété, le code écrit en python est plus facile à être empaqueté en image Docker car ils n'ont pas besoin d'être compilés avant l'exécution.

### 2.2) Les librairies
- <b> requests</b> : une libraire HTTP pour Python qui permet de rendre les requêtes HTTP plus simple à manipuler.

- <b> sys </b> : Nous avons utilé la fonction <I>argv</I> de la librairie <b>sys</b> pour récupérer les arguments passés en paramètre lors de l'appel de la fonction.   
exemple :  
 - `lat = argv[1]` permet de récupérer le premier élément passé en paramètre.  

### 2.3) URL utilisé  
Après avoir récupérer les paramètres dans les variables `lat`, `lon` et `API_KEY`, nous allons utiliser cet url pour avoir les données.  

- `lat` indique la latitude
- `long` indique la longitude
- `API_KEY` indique la clé secrète pour pouvoir récupérer les données grâce à l'API.


 https://api.openweathermap.org/data/2.5/weather?lat={lat}&lon={lon}&appid={API_KEY}

 `response = requests.get(url).json()` : on récupère les données grâce à la fonction `get` de <b>requests</b> et on l'affiche sous format json.

## 3) <u>Création de l'image Docker</u>

### 3.1) Dockerfile  
Le Dockerfile permet de créer rapidement une image pour la rendre partageable plus facilement.

Nous allons utiliser les paramètres suivants pour indiquer les informations :

- <b>FROM</b> : il permet de partir d'une image avec le minimum de fonctionnalités. On a pris `python3.9`.
- <b>WORKDIR</b>  : permet d'indiquer le repertoire où se trouvera notre image Docker.
- <b>ARG</b> : on indique les variables d'environnements
- <b>ENV</b> : affectation aux variables d'environnements les valeurs passées pendant l'appel.
- <b>COPY</b> : on copie le fichier indiqué, dans notre cas, WeatherWrapper.py dans `/app`.
- <b>RUN</b> : permet d'exécuter les commande. Ici, on va éxcuter un `pip3 install` pour la librairie `requests` de versions 2.7.0. on ajoute `--no-cache-dir` permet de garder l'image Docker moins lourd sans les dossiers de caches.
- <b>CMD</b> : indique la commande à executer au démarage du containeur. `sh` et `-c` permet d'informer que c'est au format shell.

### 3.1) Création de l'image

On se met dans le répertoire où on a le Dockerfile et on exécute la commande `docker build -t tp1:1.0.0 -f dockerfile .`. Après `-t`, on indique le tag qu'on souhaite mettre. Ensuite `-f`, nous indique le fichier.

<span style="color: #FF0000"> Problème rencontré</span> : Je n'arrivais pas à build la première fois. L'erreur était `ERROR [internal] load metadata for docker.io/library/python:3.9`

<span style="color: #26B260">Solution</span> :Sur Stack overflow, j'ai vu qu'il fallait d'abord récupérer l'image python 3.9 avec un  `docker pull python 3.9`. Après avoir eu cette image, j'ai pu exéxuter la commande.
<div class="pull-rigth">  
<img src="https://cdn.sstatic.net/Sites/stackoverflow/Img/apple-touch-icon@2.png?v=73d79a89bded" width=150 >
</div>

## 3) <u>Pousser l'image dans Docker HUB</u>
Mon nom de la registry est <b>suveta</b>. On va donc créer un repertoire dans cette registry pour stocker nos images. Le repertoire se nomme <b>tp1devops</b>.

- La première étape est de tagger notre image :
`docker tag tp1:1.0.0 suveta/tp1devops:1.0.0`
- La deuxième étape consiste est de connecter à notre registry pour push l'image : `docker login -u suveta`
- A la troisième étape, nous allons push l'image dans notre registry : `docker push suveta/tp1devops:1.0.0`

## 4) <u>Vérification</u>
- Pour la vérification, nous allon télécharger notre image depuis notre registry avec la commande `docker pull suveta/tp1devops:1.0.0`

- Une fois l'image téléchargé, on exécute la commande suivante : `docker run --env LAT="31.2504" --env LONG="-99.2506" --env API_KEY=*** suveta/tp1devops:1.0.0` en remplaçant par votre clé. Vous aurez le résultat attendu.

<span style="color: #26B260">resultat</span> :
`{'coord': {'lon': -99.2506, 'lat': 31.2504}, 'weather': [{'id': 800, 'main': 'Clear', 'description': 'clear sky', 'icon': '01n'}], 'base': 'stations', 'main': {'temp': 282.04, 'feels_like': 279.1, 'temp_min': 281.84, 'temp_max': 282.12, 'pressure': 1017, 'humidity': 66}, 'visibility': 10000, 'wind': {'speed': 5.66, 'deg': 320, 'gust': 9.26}, 'clouds': {'all': 0}, 'dt': 1682763137, 'sys': {'type': 1, 'id': 3395, 'country': 'US', 'sunrise': 1682769251, 'sunset': 1682817259}, 'timezone': -18000, 'id': 4736286, 'name': 'Texas', 'cod': 200}`.

## 5) <u>Partie Bonus</u>

- le code python ne contient aucune information secrète en claire. L'utilisateur indique la clé de l'API lors de l'appel de la fonction.

- La commande pour vérifier si notre Dockerfile est bien rédigé. on a utilisé la commande `docker run --rm -i hadolint/hadolint < Dockerfile`. On a eu 0 erreurs.