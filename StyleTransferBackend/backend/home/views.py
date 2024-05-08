from rest_framework.authtoken.models import Token
from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework import status
from django.contrib.auth import authenticate

class LoginTokenView(APIView):
    def post(self, request):
        user = authenticate(request=request,
                            username=request.data.get('username'),
                            password=request.data.get('password'))

        if user is not None:
            Token.objects.filter(user=user).delete()
            new_token = Token.objects.create(user=user)

            return Response({'token': new_token.key}, status=status.HTTP_200_OK)
        else:
            return Response({'error': 'Authentication error!'}, status=status.HTTP_401_UNAUTHORIZED)