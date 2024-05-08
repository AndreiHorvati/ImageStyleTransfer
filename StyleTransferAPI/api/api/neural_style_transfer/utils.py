import ssl
import torch
import torchvision.models as models
import torch.optim as optim

ssl._create_default_https_context = ssl._create_unverified_context


class StyleTransferSettings:
    def __init__(self, model_choice, number_of_steps):
        self.model_choice = model_choice
        self.number_of_steps = number_of_steps


class StyleTransferUtils:
    device = torch.device("cuda" if torch.cuda.is_available() else "cpu")

    normalization_mean = torch.tensor([0.485, 0.456, 0.406]).to(device)
    normalization_std = torch.tensor([0.229, 0.224, 0.225]).to(device)

    models = {'1': models.vgg19(weights=models.VGG19_Weights.DEFAULT).features.to(device).eval(),
              '2': models.resnet50(weights=models.ResNet50_Weights.DEFAULT).to(device).eval(),
              '3': models.inception_v3(weights=models.Inception_V3_Weights.DEFAULT).to(device).eval()}

    content_layers = {'1': ['Conv2d_4'], '2': ['Conv2d_1'], '3': ['BasicConv2d_2']}
    style_layers = {'1': ['Conv2d_3', 'Conv2d_5', 'Conv2d_9'],
                    '2': ['Sequential_1', 'Sequential_2', 'Sequential_3'],
                    '3': ['MaxPool2d_1', 'MaxPool2d_2', 'BasicConv2d_3' 'BasicConv2d_4', 'BasicConv2d_5']}

    @staticmethod
    def get_input_image_gradient_descent(input_image):
        return optim.Adam([input_image], lr=0.01)
    
    @staticmethod
    def get_style_image_based_on_painting_type(painting_type):
        style_images_folder_path = '/Users/andrei/Documents/Facultate/Licenta/StyleTransferAPI/api/api/neural_style_transfer/images/'

        if painting_type == 'woodblock':
            return style_images_folder_path + 'woodblock.jpg'
        elif painting_type == 'edvard_munch':
            return style_images_folder_path + 'edvard_munch.jpg'
        elif painting_type == 'picasso':
            return style_images_folder_path + 'picasso.jpg'
        elif painting_type == 'expressionism':
            return style_images_folder_path + 'expressionism.jpg'
        elif painting_type == 'nicolae_grigorescu':
            return style_images_folder_path + 'nicolae_grigorescu.jpeg'
        elif painting_type == 'stefan_luchian':
            return style_images_folder_path + 'stefan_luchian.jpg'
        else:
            return style_images_folder_path + 'vangogh.jpg'