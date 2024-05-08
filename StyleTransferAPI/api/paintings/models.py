from django.db import models
from django.core.validators import MinValueValidator

from paintings.validators import validate_neural_nework_model

class PaintingModel(models.Model):
    image = models.ImageField(upload_to="paintings/images/", null=True, blank=True)
    painting_type = models.TextField(blank=True, null=True)
    number_of_iterations = models.IntegerField(default=10, null=True, blank=True, validators=[MinValueValidator(1)])
    model = models.CharField(default='1', null=True, blank=True, max_length=1, validators=[validate_neural_nework_model])