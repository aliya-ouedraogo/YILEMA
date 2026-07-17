from rest_framework import serializers
from .models import Categorie, Contenu


class CategorieSerializer(serializers.ModelSerializer):
    class Meta:
        model = Categorie
        fields = '__all__'


class ContenuSerializer(serializers.ModelSerializer):
    categorie_nom = serializers.CharField(
        source='categorie.nom',
        read_only=True
    )

    class Meta:
        model = Contenu
        fields = [
            'id',
            'titre',
            'synopsis',
            'type',
            'annee_sortie',
            'duree',
            'categorie',
            'categorie_nom',
            'affiche',
            'url_video',
            'est_gratuit',
            'date_ajout',
        ]