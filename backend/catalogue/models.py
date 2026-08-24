from django.db import models

class Categorie(models.Model):
    nom = models.CharField(max_length=100)
    description = models.TextField(blank=True)

    def __str__(self):
        return self.nom

    class Meta:
        ordering = ['nom']


class Contenu(models.Model):
    TYPE_CHOICES = [
        ('film', 'Film'),
        ('serie', 'Série'),
        ('documentaire', 'Documentaire'),
    ]

    titre = models.CharField(max_length=255)
    synopsis = models.TextField()
    type = models.CharField(max_length=20, choices=TYPE_CHOICES)
    annee_sortie = models.IntegerField()
    duree = models.IntegerField(help_text="Durée en minutes")
    categorie = models.ForeignKey(
        Categorie,
        on_delete=models.SET_NULL,
        null=True,
        blank=True,
        related_name='contenus'
    )
    affiche = models.URLField(blank=True, null=True)
    url_video = models.URLField(blank=True, null=True)
    cloudinary_public_id = models.CharField(max_length=255, blank=True)
    date_ajout = models.DateTimeField(auto_now_add=True)
    est_gratuit = models.BooleanField(default=False)

    def __str__(self):
        return f"{self.titre} ({self.type})"

    class Meta:
        ordering = ['-date_ajout']