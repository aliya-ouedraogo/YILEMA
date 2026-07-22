from django.urls import path, include
from rest_framework.routers import DefaultRouter
from .views import CategorieViewSet, ContenuViewSet

router = DefaultRouter()
router.register(r'categories', CategorieViewSet, basename='categorie')
router.register(r'contenus', ContenuViewSet, basename='contenu')

urlpatterns = [
    path('', include(router.urls)),
]