from rest_framework import status
from rest_framework.response import Response
from rest_framework.views import APIView
from rest_framework.authtoken.models import Token

from .serializers import UserSerializer

class UserCreateAPIView(APIView):
    def create_errors_from_serializer(self, serializer):
        return {key: serializer.errors[key][0].title() for key in serializer.errors}

    def post(self, request, format='json'):
        serializer = UserSerializer(data=request.data)

        if serializer.is_valid():
            user = serializer.save()
            if user != None:
                token = Token.objects.create(user=user)
                
            return Response(serializer.data, status=status.HTTP_201_CREATED)

        return Response(self.create_errors_from_serializer(serializer), status=status.HTTP_400_BAD_REQUEST)
            

user_create_view = UserCreateAPIView.as_view()