from django.core.exceptions import ValidationError

def validate_neural_nework_model(value):
    if value not in ('1', '2', '3'):
        raise ValidationError(('%(value)s is not a valid choice. Valid choices are: 1, 2, 3'),
            params={'value': value}) 