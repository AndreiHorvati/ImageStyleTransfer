import requests
import io
from PIL import Image

class URLService:
    URL = 'http://127.0.0.1:8030/paintings/'
    images_folder_path = "/Users/andrei/Documents/Facultate/Licenta/StyleTransferBackend/backend/paintings/images/"
    new_images_folder_path = "/Users/andrei/Documents/Facultate/Licenta/StyleTransferBackend/backend/paintings/new_images/"

    @staticmethod
    def get_image_path(image_name):
        return "{}{}".format(URLService.images_folder_path, image_name)
    
    @staticmethod
    def get_new_image_path(image_name):
        return "{}{}".format(URLService.new_images_folder_path, image_name)
    
    @staticmethod
    def send_painting_request(serializer):
        image = URLService.get_image_path(serializer.validated_data['image'])
        files = {'image': open(image, 'rb')}
        data = {'painting_type': serializer.validated_data['painting_type'],
                'number_of_iterations': serializer.validated_data['number_of_iterations'],
                'model': serializer.validated_data['model']}

        print(data)

        return requests.post(URLService.URL, files=files, data=data)

       