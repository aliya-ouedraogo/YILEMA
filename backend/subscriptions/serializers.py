from rest_framework import serializers
from .models import SubscriptionPlan, UserSubscription, Payment


class SubscriptionPlanSerializer(serializers.ModelSerializer):
    class Meta:
        model = SubscriptionPlan
        fields = ['id', 'name', 'plan_type', 'price_fcfa', 'duration_days', 'is_active']


class UserSubscriptionSerializer(serializers.ModelSerializer):
    plan = SubscriptionPlanSerializer(read_only=True)
    plan_id = serializers.PrimaryKeyRelatedField(
        queryset=SubscriptionPlan.objects.all(), source='plan', write_only=True
    )

    class Meta:
        model = UserSubscription
        fields = ['id', 'plan', 'plan_id', 'status', 'start_date', 'end_date']
        read_only_fields = ['status', 'start_date', 'end_date']


class PaymentSerializer(serializers.ModelSerializer):
    class Meta:
        model = Payment
        fields = [
            'id', 'amount_fcfa', 'provider', 'phone_number',
            'transaction_id', 'status', 'created_at',
        ]
        read_only_fields = ['status', 'transaction_id', 'created_at']