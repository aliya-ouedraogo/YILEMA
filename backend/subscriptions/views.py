from rest_framework import generics, status
from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework.permissions import IsAuthenticated, AllowAny
from django.utils import timezone
from datetime import timedelta
import uuid

from .models import SubscriptionPlan, UserSubscription, Payment
from .serializers import (
    SubscriptionPlanSerializer,
    UserSubscriptionSerializer,
    PaymentSerializer,
)


class SubscriptionPlanListView(generics.ListAPIView):
    """GET /api/subscriptions/plans/ — liste toutes les offres actives (public, pas besoin d'être connecté)."""
    queryset = SubscriptionPlan.objects.filter(is_active=True)
    serializer_class = SubscriptionPlanSerializer
    permission_classes = [AllowAny]


class MySubscriptionsView(generics.ListAPIView):
    """GET /api/subscriptions/mine/ — liste les abonnements de l'utilisateur connecté."""
    serializer_class = UserSubscriptionSerializer
    permission_classes = [IsAuthenticated]

    def get_queryset(self):
        return UserSubscription.objects.filter(user=self.request.user)


class InitiatePaymentView(APIView):
    """
    POST /api/subscriptions/pay/
    Body attendu : { "plan_id": 1, "provider": "orange_money", "phone_number": "70000000" }
    Simule pour l'instant un paiement Mobile Money (à remplacer plus tard par le vrai appel API).
    """
    permission_classes = [IsAuthenticated]

    def post(self, request):
        plan_id = request.data.get('plan_id')
        provider = request.data.get('provider')
        phone_number = request.data.get('phone_number')

        if not all([plan_id, provider, phone_number]):
            return Response(
                {"error": "plan_id, provider et phone_number sont obligatoires."},
                status=status.HTTP_400_BAD_REQUEST,
            )

        try:
            plan = SubscriptionPlan.objects.get(id=plan_id, is_active=True)
        except SubscriptionPlan.DoesNotExist:
            return Response(
                {"error": "Offre d'abonnement introuvable."},
                status=status.HTTP_404_NOT_FOUND,
            )

        # Création de l'abonnement en attente
        subscription = UserSubscription.objects.create(
            user=request.user,
            plan=plan,
            status=UserSubscription.Status.TRIAL,
            end_date=timezone.now() + timedelta(days=plan.duration_days),
        )

        # --- SIMULATION du paiement Mobile Money ---
        # TODO: remplacer par le vrai appel API Orange Money / Moov Money
        fake_transaction_id = f"SIMU-{uuid.uuid4().hex[:10].upper()}"

        payment = Payment.objects.create(
            user=request.user,
            subscription=subscription,
            amount_fcfa=plan.price_fcfa,
            provider=provider,
            phone_number=phone_number,
            transaction_id=fake_transaction_id,
            status=Payment.Status.SUCCESS,  # simulé comme toujours réussi pour l'instant
        )

        subscription.status = UserSubscription.Status.ACTIVE
        subscription.save()

        return Response(
            {
                "message": "Paiement simulé avec succès.",
                "subscription": UserSubscriptionSerializer(subscription).data,
                "payment": PaymentSerializer(payment).data,
            },
            status=status.HTTP_201_CREATED,
        )