# Generated by Django 4.1.7 on 2023-04-09 16:41

from django.db import migrations, models


class Migration(migrations.Migration):

    initial = True

    dependencies = [
    ]

    operations = [
        migrations.CreateModel(
            name='PaintingModel',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('image', models.ImageField(blank=True, null=True, upload_to='paintings/images/')),
                ('painting_type', models.TextField(blank=True, null=True)),
            ],
        ),
    ]
