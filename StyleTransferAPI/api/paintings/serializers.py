from rest_framework import serializers
from .models import PaintingModel

class PaintingModelSerializer(serializers.ModelSerializer):
    image = serializers.ImageField(max_length=None)

    class Meta:
        model = PaintingModel
        fields = [
            'image',
            'painting_type',
            'number_of_iterations',
            'model'
        ]