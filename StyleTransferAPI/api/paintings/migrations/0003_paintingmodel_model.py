# Generated by Django 4.0.10 on 2023-05-04 12:30

from django.db import migrations, models
import paintings.validators


class Migration(migrations.Migration):

    dependencies = [
        ('paintings', '0002_paintingmodel_number_of_iterations'),
    ]

    operations = [
        migrations.AddField(
            model_name='paintingmodel',
            name='model',
            field=models.CharField(blank=True, default='1', max_length=1, null=True, validators=[paintings.validators.validate_neural_nework_model]),
        ),
    ]