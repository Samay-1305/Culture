from django.urls import path

from . import views

urlpatterns = [
    path('showcase/', views.showcase, name='API-Showcase'),
    path('showcase/view/', views.showcase_item, name='API-Showcase-Select'),
    path('showcase/purchased/', views.showcase_purchased, name='API-Showcase-purchased'),
    path('account/login/', views.account_login, name='API-Account-Login'),
    path('account/logout/', views.account_logout, name='API-Account-Logout'),
    path('account/sign_up/', views.account_sign_up, name='API-Account-Sign_Up'),
    path('new/transactions/<str:transaction_type>/', views.new_transaction, name='API-New-Transactions'),
]
