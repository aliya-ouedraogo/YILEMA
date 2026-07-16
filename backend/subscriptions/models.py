from django.db import models
from django.conf import settings


class SubscriptionPlan(models.Model):
    """Les offres disponibles : mensuel, à l'unité, freemium."""

    class PlanType(models.TextChoices):
        MONTHLY = 'monthly', 'Abonnement mensuel'
        PER_FILM = 'per_film', 'Paiement à l\'unité'
        FREEMIUM = 'freemium', 'Freemium'

    name = models.CharField(max_length=100)
    plan_type = models.CharField(max_length=20, choices=PlanType.choices)
    price_fcfa = models.PositiveIntegerField(help_text="Prix en FCFA")
    duration_days = models.PositiveIntegerField(
        default=30, help_text="Durée en jours (30 pour mensuel, 0 pour à l'unité)"
    )
    is_active = models.BooleanField(default=True)

    def __str__(self):
        return f"{self.name} ({self.get_plan_type_display()})"


class UserSubscription(models.Model):
    """L'abonnement souscrit par un utilisateur."""

    class Status(models.TextChoices):
        ACTIVE = 'active', 'Actif'
        EXPIRED = 'expired', 'Expiré'
        CANCELLED = 'cancelled', 'Annulé'
        TRIAL = 'trial', 'Période d\'essai'

    user = models.ForeignKey(
        settings.AUTH_USER_MODEL, on_delete=models.CASCADE, related_name='subscriptions'
    )
    plan = models.ForeignKey(SubscriptionPlan, on_delete=models.PROTECT)
    status = models.CharField(max_length=20, choices=Status.choices, default=Status.TRIAL)
    start_date = models.DateTimeField(auto_now_add=True)
    end_date = models.DateTimeField()

    def __str__(self):
        return f"{self.user} - {self.plan.name} ({self.status})"


class Payment(models.Model):
    """Historique des paiements Mobile Money."""

    class Provider(models.TextChoices):
        ORANGE_MONEY = 'orange_money', 'Orange Money'
        MOOV_MONEY = 'moov_money', 'Moov Money'

    class Status(models.TextChoices):
        PENDING = 'pending', 'En attente'
        SUCCESS = 'success', 'Réussi'
        FAILED = 'failed', 'Échoué'

    user = models.ForeignKey(
        settings.AUTH_USER_MODEL, on_delete=models.CASCADE, related_name='payments'
    )
    subscription = models.ForeignKey(
        UserSubscription, on_delete=models.SET_NULL, null=True, blank=True
    )
    amount_fcfa = models.PositiveIntegerField()
    provider = models.CharField(max_length=20, choices=Provider.choices)
    phone_number = models.CharField(max_length=20)
    transaction_id = models.CharField(max_length=100, unique=True, blank=True, null=True)
    status = models.CharField(max_length=20, choices=Status.choices, default=Status.PENDING)
    created_at = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return f"{self.user} - {self.amount_fcfa} FCFA ({self.status})"