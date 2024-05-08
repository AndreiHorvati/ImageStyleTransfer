from django.test import RequestFactory
from rest_framework.test import APIRequestFactory, APITestCase
from rest_framework import status
from users.serializers import UserSerializer
from users.views import UserCreateAPIView, user_create_view
from django.contrib.auth.models import User
from rest_framework.authtoken.models import Token

class UserCreateAPIViewTest(APITestCase):
    def setUp(self):
        self.factory = RequestFactory()
        self.factory_api = APIRequestFactory()

    def test_create_user_succes(self):
        request_data = {
            'username': 'username',
            'email': 'email@gmail.com',
            'password': 'password'
        }

        response = self.client.post('/users/', data=request_data, format='json')

        self.assertEqual(response.status_code, status.HTTP_201_CREATED)
        self.assertEqual(User.objects.count(), 1)
        self.assertEqual(User.objects.first().username, 'username')
        self.assertEqual(User.objects.first().email, 'email@gmail.com')
        self.assertTrue(Token.objects.filter(user=User.objects.first()).exists())

    def test_create_user_error(self):
        request_data = {
            'username': 'username',
            'email': 'email',
            'password': 'password'
        }

        response = self.client.post('/users/', data=request_data, format='json')

        self.assertEqual(response.status_code, status.HTTP_400_BAD_REQUEST)
        self.assertIn('email', response.data)
        self.assertEqual(response.data['email'], 'Enter A Valid Email Address.')

    
    def test_create_user_error_2(self):
        request_data = {
            'username': 'username',
            'email': 'email',
            'password': '123'
        }

        response = self.client.post('/users/', data=request_data, format='json')

        self.assertEqual(response.status_code, status.HTTP_400_BAD_REQUEST)
        self.assertIn('email', response.data)
        self.assertEqual(response.data['password'], 'Ensure This Field Has At Least 8 Characters.')

    def test_create_errors_from_serializer(self):
        serializer = UserSerializer(data={})
        serializer.is_valid()

        errors = UserCreateAPIView().create_errors_from_serializer(serializer)

        self.assertEqual(len(errors), 3)

    def test_user_create_view(self):
        request_data = {
            'username': 'username',
            'email': 'email@gmail.com',
            'password': 'password'
        }

        request = self.factory.post('/users/', data=request_data, format='json')
        response = user_create_view(request)

        self.assertEqual(response.status_code, status.HTTP_201_CREATED)
        self.assertEqual(User.objects.count(), 1)
        self.assertEqual(User.objects.first().username, 'username')
        self.assertEqual(User.objects.first().email, 'email@gmail.com')