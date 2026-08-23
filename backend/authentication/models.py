from django.contrib.auth.models import AbstractUser
from django.db import models


class User(AbstractUser):
    ABONNEMENT_CHOICES = [
        ('inactif', 'Inactif'),
        ('actif', 'Actif'),
    ]

    email = models.EmailField(unique=True)
    nom = models.CharField(max_length=150, blank=True)
    telephone = models.CharField(max_length=20, blank=True, null=True)
    statut_abonnement = models.CharField(
        max_length=10,
        choices=ABONNEMENT_CHOICES,
        default='inactif'
    )
    date_creation = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return self.email