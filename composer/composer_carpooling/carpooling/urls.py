from django.urls import path
from carpooling import views
from rest_framework.urlpatterns import format_suffix_patterns

urlpatterns = [
    path("", views.home, name="home"),
    path("getTrips/", views.getTrips.as_view(), name="getTrips")
]