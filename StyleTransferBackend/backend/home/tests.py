from django.contrib.auth.models import User
from rest_framework.test import APITestCase
from rest_framework.test import APIClient
from rest_framework.authtoken.models import Token
from rest_framework import status

class LoginTokenViewTest(APITestCase):
    def setUp(self):
        self.user = User.objects.create_user(username='username', password='password')

    def test_successful_login(self):
        response = self.client.post('/authentication/', {'username': 'username', 'password': 'password'})

        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertIn('token', response.data)
        self.assertIsNotNone(response.data['token'])
        self.assertEqual(Token.objects.count(), 1)
        self.assertEqual(Token.objects.first().user, self.user)

    def test_unsuccessful_login(self):
        response = self.client.post('/authentication/', {'username': 'username', 'password': 'password2'})

        self.assertEqual(response.status_code, status.HTTP_401_UNAUTHORIZED)
        self.assertIn('error', response.data)
        self.assertEqual(Token.objects.count(), 0)