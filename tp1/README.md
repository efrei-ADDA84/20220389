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

- <b> sys </b> : Nous avons utilisé la fonction <I>argv</I> de la librairie <b>sys</b> pour récupérer les arguments passés en paramètre lors de l'appel de la fonction.   
exemple :  
 - `lat = argv[1]` permet de récupérer le premier élément passé en paramètre.  

### 2.3) URL utilisé  
Après avoir récupéré les paramètres dans les variables `lat`, `lon` et `API_KEY`, nous allons utiliser cet url pour avoir les données.  

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

<p style="float:right"><img src="https://cdn.sstatic.net/Sites/stackoverflow/Img/apple-touch-icon@2.png?v=73d79a89bded" width=100/></p>
<p><span style="color: #26B260">Solution</span> :Sur Stack overflow, j'ai vu qu'il fallait d'abord récupérer l'image python 3.9 avec un  `docker pull python 3.9`. Après avoir eu cette image, j'ai pu exéxuter la commande.</p>
<div style="clear:both"></div>

## 3) <u>Pousser l'image dans Docker HUB</u>
<p style="float:left"><img src="data:image/png;base64,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" width=100/></p>
<p>Mon nom de la registry est <b>suveta</b>. On va donc créer un repertoire dans cette registry pour stocker nos images. Le repertoire se nomme <b>tp1devops</b>.</p>
<div style="clear:both"></div>

- La première étape est de tagger notre image :
`docker tag tp1:1.0.0 suveta/tp1devops:1.0.0`
- La deuxième étape consiste à se connecter à notre registry pour push l'image : `docker login -u suveta`
- A la troisième étape, nous allons push l'image dans notre registry : `docker push suveta/tp1devops:1.0.0`

## 4) <u>Vérification</u>
- Pour la vérification, nous allon télécharger notre image depuis notre registry avec la commande `docker pull suveta/tp1devops:1.0.0`

- Une fois l'image téléchargé, on exécute la commande suivante : `docker run --env LAT="31.2504" --env LONG="-99.2506" --env API_KEY=*** suveta/tp1devops:1.0.0` en remplaçant par votre clé. Vous aurez le résultat attendu.

<span style="color: #26B260">resultat</span> :
`{'coord': {'lon': -99.2506, 'lat': 31.2504}, 'weather': [{'id': 800, 'main': 'Clear', 'description': 'clear sky', 'icon': '01n'}], 'base': 'stations', 'main': {'temp': 282.04, 'feels_like': 279.1, 'temp_min': 281.84, 'temp_max': 282.12, 'pressure': 1017, 'humidity': 66}, 'visibility': 10000, 'wind': {'speed': 5.66, 'deg': 320, 'gust': 9.26}, 'clouds': {'all': 0}, 'dt': 1682763137, 'sys': {'type': 1, 'id': 3395, 'country': 'US', 'sunrise': 1682769251, 'sunset': 1682817259}, 'timezone': -18000, 'id': 4736286, 'name': 'Texas', 'cod': 200}`.

## 5) <u>Partie Bonus</u>

- le code python ne contient aucune information secrète en claire. L'utilisateur indique la clé de l'API lors de l'appel de la fonction.

- La commande pour vérifier si notre Dockerfile est bien rédigé. on a utilisé la commande `docker run --rm -i hadolint/hadolint < Dockerfile`. On a eu 0 erreurs.

