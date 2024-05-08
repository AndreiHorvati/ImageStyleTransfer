from django.urls import path
from django.conf import settings
from django.conf.urls.static import static

from . import views

urlpatterns = [
    path('', views.painting_model_list_create_view),
    path('images/<path:filepath>', views.get_image)
] + static(settings.MEDIA_URL, document_root=settings.MEDIA_ROOT)