from django.http import FileResponse
from rest_framework import generics, permissions, authentication
from rest_framework.decorators import api_view, permission_classes, authentication_classes

from paintings.models import PaintingModel
from paintings.serializers import PaintingModelSerializer

from backend.services.URLService import URLService

@api_view(['GET'])
@permission_classes([permissions.IsAuthenticated])
@authentication_classes([authentication.TokenAuthentication])
def get_image(request, filepath):
    return FileResponse(open(f"/Users/andrei/Documents/Facultate/Licenta/StyleTransferBackend/backend/paintings/new_images/{filepath}", 'rb'), content_type='image/jpeg')

class PaintingModelListCreateAPIView(generics.ListCreateAPIView):
    queryset = PaintingModel.objects.all()
    serializer_class = PaintingModelSerializer
    permission_classes = [permissions.IsAuthenticated]
    authentication_classes = [authentication.TokenAuthentication]

    def perform_create(self, serializer):
        serializer.save(user = self.request.user)
        response = URLService.send_painting_request(serializer)

        with open(URLService.get_new_image_path(serializer.validated_data['image']), 'wb') as file:
            new_image = response.content
            file.write(new_image)

    def get_queryset(self):
        return PaintingModel.objects.filter(user=self.request.user)


painting_model_list_create_view = PaintingModelListCreateAPIView.as_view()