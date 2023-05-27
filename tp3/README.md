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

Nous allons configurer le fichier `main_tp3.yml` dans `.github/workflows` pour configurer le pipeline de gitHub Actions.  

- Ici, on indique qu'on commence le Github Actions dès qu'il y a `push` ou un `pull` dans la branche `main`.      
```yml
on:  
  	push:  
    branches: [ "main" ]
  pull_request:  
    branches: [ "main" ]
```

- Dans `Jobs`, on indique la tâche à faire. Ici, on souhaite ici la tâche `build-and-deploy` et on veut tourner sur un `ubuntu-latest`:

```yml
jobs:
    build-and-deploy:
        runs-on: ubuntu-latest
```

- `steps:` permet d'indiquer les sous-tâches  :   
  - 1ère tâche : Récupérer le code source du référentiel et le rendre disponible pour les autres étapes du workflow   
    ```yml
      name: 'Checkout GitHub Action'
      uses: actions/checkout@main
    ```

- 2eme tâche : Se connecter à AZURE CLI avec  `azure/login@v1`. On a stocké dans secret les credentials dans la variable `AZURE_CREDENTIALS`.

    ```yml
      name: 'Login via Azure CLI'
      uses: azure/login@v1
      with:
        creds: ${{ secrets.AZURE_CREDENTIALS }}
    ```

- 3eme tâche : On va construire et pousser l'image docker dans AZURE avec le use `azure/docker-login@v1`. Dans la case `with`, on inscrit les éléments qui permettent la connexion. Ces éléments sont stockés dans le secrets de l'organisations. Dans la balise `run`, on indique les commandes qu'on exécute pour build et push l'image. `-t` indique le tag dans lequel nous mettons les indications de la registry. ` ${{ github.sha }}`permet d'avoir une version pour chaque push. Ensuit on push l'image.
    ```yml
          - name: 'Build and push image'
          uses: azure/docker-login@v1
          with:
            login-server: ${{ secrets.REGISTRY_LOGIN_SERVER }}
            username: ${{ secrets.REGISTRY_USERNAME }}
            password: ${{ secrets.REGISTRY_PASSWORD }}
        - run: |
            docker build ./tp3 -t ${{ secrets.REGISTRY_LOGIN_SERVER }}/20220389:${{ github.sha }}

            docker push ${{ secrets.REGISTRY_LOGIN_SERVER }}/20220389:${{ github.sha }}
    ```

- 4eme tâche : On déplois dans Azure Container. dans `use`, on indique l'action qui `azure/aci-deploy@v1`. Cette balise est pour le déploiement sur Azure. Dans la balise `with`, on indique les informations pratoque telles que la ressource group dans laquelle l'image sera déploy". Dans`dns-name-label`, on indique le label DNS associé. `registry-login-server`, `registry-username` et  `registry-password` permettent de se connecter à la registry Docker pour prendre l'image. Avec `name`, on indique le nom de l'image. `location` permet d'indiquer la région où on souhaite stocker l'image. `environment-variables` indique les variables qu'on va utiliser pour le code python. Cette valeur est stockée dans secrets.
    ```yml
       - name: 'Deploy to Azure Container Instances'
          uses: 'azure/aci-deploy@v1'
          with:
            resource-group: ${{ secrets.RESOURCE_GROUP }}
            dns-name-label: devops-20220389
            image: ${{ secrets.REGISTRY_LOGIN_SERVER }}/20220389:${{ github.sha }}
            registry-login-server: ${{ secrets.REGISTRY_LOGIN_SERVER }}
            registry-username: ${{ secrets.REGISTRY_USERNAME }}
            registry-password: ${{ secrets.REGISTRY_PASSWORD }}
            name: 20220389
            location: 'france central'
            ports: 8081
            environment-variables: API_KEY=${{ secrets.API_WEATHER_KEY }}





## 5) <u>Vérification</u>

- Une fois déployer, on exécute la commande suivante : 
```bash
curl "http://devops-20220389.francecentral.azurecontainer.io:8081/?lat=5.902785&lon=102.754175"
```

<span style="color: #26B260">resultat</span> :
```bash
{
  "base": "stations",
  "clouds": {
    "all": 74
  },
  "cod": 200,
  "coord": {
    "lat": 5.9028,
    "lon": 102.7542
  },
  "dt": 1685010313,
  "id": 1736405,
  "main": {
    "feels_like": 305.9,
    "grnd_level": 981,
    "humidity": 70,
    "pressure": 1008,
    "sea_level": 1008,
    "temp": 302.16,
    "temp_max": 302.16,
    "temp_min": 302.16
  },
  "name": "Jertih",
  "sys": {
    "country": "MY",
    "sunrise": 1684968805,
    "sunset": 1685013517
  },
  "timezone": 28800,
  "visibility": 10000,
  "weather": [
    {
      "description": "broken clouds",
      "icon": "04d",
      "id": 803,
      "main": "Clouds"
    }
  ],
  "wind": {
    "deg": 40,
    "gust": 3.61,
    "speed": 4
  }
}
```

<span style="color: #FF0000"> Problème rencontré</span> :  
La commande initiale était `curl "http://devops-20220389.francecentral.azurecontainer.io/?lat=5.902785&lon=102.754175"`

mais sans le port, la commande ne s'effectuait pas.

<span style="color: #26B260"> Solution</span> :  Il faut ajouter le port suivant 
`:8081`.

## 6) <u>Partie Bonus</u>

- Aucune donnée sensible sont dans le code. Ils sont tous dans les secrets de GitHub

- La commande pour vérifier si notre Dockerfile est bien rédigé. on a utilisé la commande `docker run --rm -i hadolint/hadolint < Dockerfile`. On a eu 0 erreurs.

## 6) <u>L'intêret de GitHub Actions </u>
Les avantages de GitHub par avoir à l'interface CLI sont nombreux.

- Automatisation des actions : Une fois que le fichier `yml` est crée, le processus du déploiement est automatisé. Le processus de deploiement est donc en continue. Il suffit de push. Cependant, en ligne de commande CLI, nous devons écrire de nombreuses lignes de codes pour affectuer la même tâche.

- Synchronisation avec Git : Le code sur Git et qui est déployer sur Azure seront toujours synchroniser. On n'aura pas ainsi des problèmes de versions 

- workflow réutilisable : le code pour le déploiement aura toujours la même structure. On peut le réutiliser pour d'autre deploiement en changement uniquement quelques données.

- Vérifications et suivi du déploiement :
Grâce à l'interface de GutHub, on peut suivre les déploiement et voir les problèmes. Ainsi, cela est plus facile à résoudre les problèmes.

-