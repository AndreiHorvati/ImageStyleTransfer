from django.urls import path
from . import views

urlpatterns = [
    path('', views.painting_model_list_create_view),
]