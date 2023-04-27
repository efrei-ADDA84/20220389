"""
Created on Thur Apr 27 10:05:09 2023

Ce module permet de récupérer les informations météorologiques d'une ville
qu'on trouve en indiquant la latitude et la longitude. 
Ceci est un wrapper.
@author: Suvéta
"""

#Import des modules
import requests
from sys import argv


lat = argv[1] #récupération du premier argument
lon = argv[2] #récupération du deuxième argument
API_KEY = argv[3] #récupération du troisième argument

url = f"https://api.openweathermap.org/data/2.5/weather?lat={lat}&lon={lon}&appid={API_KEY}"

#Récupération de la réponse avec l'url
response = requests.get(url).json()


print(response)