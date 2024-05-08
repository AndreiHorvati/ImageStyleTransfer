from django.urls import path
from .views import random_product

urlpatterns = [
    path('', random_product)
]