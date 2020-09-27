from django.contrib import admin
from . import models

# Register your models here.
admin.site.register(models.LoginSessions)
admin.site.register(models.UserTransactions)
admin.site.register(models.ItemShowcase)
admin.site.register(models.ItemShare)
admin.site.register(models.UserTrades)
