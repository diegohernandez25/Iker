from django.shortcuts import render
from django.http import HttpResponse,JsonResponse
from rest_framework.views import APIView
import json
import requests


ipgfEndpoint = ""
reviewEndpoint = ""
reservasEndpoint = ""
paymentEndpoint = ""


def home(request):
    return HttpResponse("Hello, there!")


#FIXME Nenhum endpoint está funcional

#Este pedido vai retornar uma lista de objetos trip
#(Cujo o formato está por definir, tendo em conta as necessidades do frontend)
#As ações aqui efetuadas são as seguintes
#1. Obter do Itinerary Planner & Geofencing uma lista de Trip IDs através do metodo getTrips()
#2. Para cada Trip, perguntar ao Reservation Service qtos lugares este tem disponivel e filtrar aqueles que teem 0
#3. Ir buscar ao Itinerary Planner os details das trips com lugares disponiveis
#4. Ir buscar ao Review Service reviews dos drivers acossiados as trips
#5. Devolver lista de trips com info necessaria para a aplicação móvel
class getTrips(APIView):
    def get(self, request):
        #Obter a lista de todas as trips que cuprem os requisitos de partida e chegada na query
        getTripsReq = requests.get(url = ipgfEndpoint+"/getTrips", params = {'init_coords':request.query_params.get('init_coords'), 
            'final_coords':request.query_params.get('final_coords'),
            'init_time':request.query_params.get('init_time') })
        listOfTripIDS = getTripsReq.json()

        #filtrar todos os ids de trips que teem lugares disponiveis
        listOfTripIDS=list(filter(lambda id: requests.get(url = reservasEndpoint+"/getAvailableElements"+"/"+id)['availableSeats']>=request.query_params.get('seats'), listOfTripIDS))
        
        responseJSON='{}'
        #Obter informacao acerca das trips
        for tripID in listOfTripIDS:
            tripInfo=request.get(url=ipgfEndpoint+"/tripDetails"+"/"+tripID).json()
            rating=requests.get(url=reviewEndpoint+"/object"+"/"+tripInfo['driver'])
            #Construir reponseJSON

        return JsonResponse(responseJSON)
