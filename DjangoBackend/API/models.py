import datetime
import json
import uuid

from django.contrib.auth.models import User
from django.db import models

# Create your models here.

class LoginSessions(models.Model):
    account = models.ForeignKey(User, on_delete=models.CASCADE)
    active_sessions = models.TextField(default=json.dumps({}))
    auth_key = models.UUIDField(default=uuid.uuid4, editable=False)
    
    def __str__(self):
        return str(self.account.username)

class ItemShowcase(models.Model):
    item_name = models.CharField(max_length=128)
    item_value = models.FloatField(null=True)
    description = models.CharField(max_length=256, default='')
    total_shares = models.FloatField(default=100.0)
    available_shares = models.FloatField(default=100.0)
    start_time = models.DateTimeField(auto_now_add=True)
    end_time = models.DateTimeField(default=datetime.datetime.now()+datetime.timedelta(days=28))
    current_value = models.FloatField()

    def __str__(self):
        return str(self.item_name)

class ItemShare(models.Model):
    item = models.ForeignKey(ItemShowcase, on_delete=models.CASCADE)
    share_id = models.UUIDField(default=uuid.uuid1, unique=True, editable=False)
    purchase_value = models.FloatField(editable=False)
    purchase_datetime = models.DateTimeField(auto_now_add=True)
    share_count = models.FloatField()

    def __str__(self):
        return str(self.share_id)

class UserTransactions(models.Model):
    account = models.ForeignKey(User, on_delete=models.CASCADE)
    active_shares = models.ManyToManyField(ItemShare, blank=True, related_name="active_shares")
    previous_shares = models.ManyToManyField(ItemShare, blank=True, related_name="previous_shares")
    account_balance = models.FloatField()

    def __str__(self):
        return str(self.account.username)

class UserTrades(models.Model):
    account = models.ForeignKey(User, on_delete=models.CASCADE)
    item = models.ForeignKey(ItemShowcase, on_delete=models.CASCADE)
    share_cost = models.FloatField()
    available_shares = models.FloatField()
    buy = models.BooleanField() 
    start_time = models.DateTimeField(auto_now_add=True)
    end_time = models.DateTimeField(default=datetime.datetime.now()+datetime.timedelta(days=28))

    def __str__(self):
        return str(self.item.item_name)

