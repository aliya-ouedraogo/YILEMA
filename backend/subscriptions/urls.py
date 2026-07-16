from django.urls import path
from .views import SubscriptionPlanListView, MySubscriptionsView, InitiatePaymentView

urlpatterns = [
    path('plans/', SubscriptionPlanListView.as_view(), name='plan-list'),
    path('mine/', MySubscriptionsView.as_view(), name='my-subscriptions'),
    path('pay/', InitiatePaymentView.as_view(), name='initiate-payment'),
]