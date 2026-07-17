from rest_framework import viewsets, status
from rest_framework.decorators import action
from rest_framework.response import Response
import cloudinary.uploader
from .models import Categorie, Contenu
from .serializers import CategorieSerializer, ContenuSerializer


class CategorieViewSet(viewsets.ModelViewSet):
    queryset = Categorie.objects.all()
    serializer_class = CategorieSerializer


class ContenuViewSet(viewsets.ModelViewSet):
    queryset = Contenu.objects.all()
    serializer_class = ContenuSerializer

    def get_queryset(self):
        queryset = Contenu.objects.all()
        # Filtrer par type si précisé dans l'URL
        # ex: /api/contenus/?type=film
        type_filter = self.request.query_params.get('type')
        if type_filter:
            queryset = queryset.filter(type=type_filter)
        # Filtrer par catégorie
        categorie = self.request.query_params.get('categorie')
        if categorie:
            queryset = queryset.filter(categorie__id=categorie)
        return queryset

    @action(detail=False, methods=['post'], url_path='upload-video')
    def upload_video(self, request):
        """
        Upload une vidéo sur Cloudinary.
        Reçoit un fichier 'video' en multipart/form-data.
        Retourne l'URL et le public_id Cloudinary.
        """
        fichier = request.FILES.get('video')
        if not fichier:
            return Response(
                {'erreur': 'Aucun fichier vidéo fourni.'},
                status=status.HTTP_400_BAD_REQUEST
            )
        try:
            resultat = cloudinary.uploader.upload(
                fichier,
                resource_type='video',
                folder='yilema/videos',
            )
            return Response({
                'url_video': resultat['secure_url'],
                'public_id': resultat['public_id'],
            }, status=status.HTTP_200_OK)
        except Exception as e:
            return Response(
                {'erreur': str(e)},
                status=status.HTTP_500_INTERNAL_SERVER_ERROR
            )

    @action(detail=False, methods=['post'], url_path='upload-affiche')
    def upload_affiche(self, request):
        """
        Upload une affiche (image) sur Cloudinary.
        Reçoit un fichier 'affiche' en multipart/form-data.
        """
        fichier = request.FILES.get('affiche')
        if not fichier:
            return Response(
                {'erreur': 'Aucun fichier image fourni.'},
                status=status.HTTP_400_BAD_REQUEST
            )
        try:
            resultat = cloudinary.uploader.upload(
                fichier,
                folder='yilema/affiches',
            )
            return Response({
                'affiche': resultat['secure_url'],
                'public_id': resultat['public_id'],
            }, status=status.HTTP_200_OK)
        except Exception as e:
            return Response(
                {'erreur': str(e)},
                status=status.HTTP_500_INTERNAL_SERVER_ERROR
            )