from rest_framework import generics
from django.http import FileResponse
from rest_framework.response import Response

from .models import PaintingModel
from .serializers import PaintingModelSerializer

from api.neural_style_transfer.utils import StyleTransferSettings, StyleTransferUtils
from api.neural_style_transfer.style_transfer import StyleTransfer
from api.neural_style_transfer.image_loader import ImageLoader

import io
from PIL import Image

class PaintingModelListCreateAPIView(generics.ListCreateAPIView):
    queryset = PaintingModel.objects.all()
    serializer_class = PaintingModelSerializer

    def create(self, request, *args, **kwargs):
        serializer = self.get_serializer(data=request.data)
        if not serializer.is_valid(raise_exception=False):
            return Response("Error!")
        
        return self.perform_create(serializer)

    def perform_create(self, serializer):
        serializer.save()

        painting_type = serializer.validated_data['painting_type']
        number_of_iterations = serializer.validated_data['number_of_iterations']
        model = serializer.validated_data['model']

        content_image_tensor = ImageLoader.load_image("/Users/andrei/Documents/Facultate/Licenta/StyleTransferAPI/api/paintings/images/{}".format(serializer.validated_data['image']))
        style_image_tensor = ImageLoader.load_image(StyleTransferUtils.get_style_image_based_on_painting_type(painting_type))
        style_transfer_settings = StyleTransferSettings(model, number_of_iterations)
        style_transfer = StyleTransfer(style_transfer_settings)

        print(number_of_iterations)
        print(model)

        output_image = style_transfer.style_transfer(content_image_tensor, style_image_tensor)

        image = ImageLoader.unload_image(output_image)
        image_path = f"/Users/andrei/Documents/Facultate/Licenta/StyleTransferAPI/api/paintings/new_images/{serializer.validated_data['image']}"
        image.save(image_path)
        
        return FileResponse(open(image_path, 'rb'), content_type='image/jpeg')


painting_model_list_create_view = PaintingModelListCreateAPIView.as_view()