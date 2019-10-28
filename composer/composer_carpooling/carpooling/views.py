from django.shortcuts import render
from django.http import HttpResponse,JsonResponse
from rest_framework.views import APIView
import json

def home(request):
    return HttpResponse("Hello, there!")

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
        return JsonResponse({'foo':'bar'})
