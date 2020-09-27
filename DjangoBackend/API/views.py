import datetime
import json
import random
import threading
import time
import uuid

from django.contrib import auth
from django.contrib.auth.models import User
from django.http import JsonResponse
from django.shortcuts import render
from django.views.decorators.csrf import csrf_exempt

from . import models


# Handle Live Reload of stocks graph
class GraphData:
    def __init__(self):
        self.graph_data = {'day': [125]}
        for _ in range(96):
            self.graph_data['day'].insert(0, self.__new_random()*self.graph_data['day'][0])
        self.graph_data['month'] = self.graph_data['day'][:30]
        self.running = False
        self.main = threading.Thread(target=self.__update)

    def toggle(self):
        self.running = not self.running
        if not self.running:
            self.main.join()
        else:
            self.main.start()

    def __update(self):
        try:
            while self.running:
                change = self.__new_random() 
                for item in models.ItemShowcase.objects.all():
                    item.current_value = item.current_value*change
                    item.save()
                self.graph_data['day'].append(change*self.graph_data['day'][-1])
                del self.graph_data['day'][0]
                if self.graph_data['day'][-1] >= 240:
                    for i in range(len(self.graph_data['day'])):
                        self.graph_data[i] = 0.75*self.graph_data[i]
                time.sleep(5)
        except Exception as ThreadError:
            print(ThreadError)

    def __new_random(self):
        return 1 + round(random.choice([-1, 1])*((1.5 + random.random()*3.5)/100), 2)

    def get(self, data_value='day'):
        return [(x * 10, 250 - y) for x, y in enumerate(self.graph_data[data_value][-31:])]


graph_data = GraphData()

# Handle POST request incase data is in request body
def get_post(request):
    post_data = request.POST
    if not post_data:
        post_data = json.loads(request.body)
    return post_data


# Ensure POST data has required data
def verify_fields(post_data, fields=[]):
    for field_name in fields:
        if post_data.get(field_name) is None:
            return False
    return True


# Ensure login auth_key is valid
def verify_login(post_data):
    if post_data['auth_key'] is not None:
        possible_sessions = models.LoginSessions.objects.filter(auth_key=post_data['auth_key'])
        if possible_sessions.count() > 0:
            return (True, User.objects.get(username=possible_sessions.first().account.username))
    return (False, None)


# Create your views here.

# Login API
@csrf_exempt
def account_login(request):
    response_data = {'success': False, 'error': 'Invalid Request'}
    if request.method == 'POST':
        post_data = get_post(request)
        if verify_fields(post_data, ['username', 'password']):
            account = User.objects.filter(username=post_data.get('username'))
            account = account.first() if account.count() else None
            if account is not None and account.check_password(post_data.get('password')):
                session = models.LoginSessions.objects.get(account=account)
                active_sessions = json.loads(session.active_sessions)
                current_session = {}
                current_session_id = str(uuid.uuid1().hex)
                active_sessions[current_session_id] = current_session
                session.active_sessions = json.dumps(active_sessions)
                session.save()
                response_data['auth_key'] = session.auth_key
                response_data['session_id'] = current_session_id
                response_data['success'] = True
                response_data.pop('error')
            else:
                response_data['error'] = 'Invalid Credentials'
        return JsonResponse(response_data)

# Logout API
@csrf_exempt
def account_logout(request):
    response_data = {'success': False, 'error': 'Invalid Request'}
    if request.method == 'POST':
        post_data = get_post(request)
        logged_in, account = verify_login(post_data)
        if logged_in and verify_fields(post_data, 'session_id'):
            session = models.LoginSessions.objects.get(account=account)
            active_sessions = json.loads(session.active_sessions)
            session_details = active_sessions.pop(post_data.get('session_id'))
            session.active_sessions = json.dumps(active_session)
            session.save()
            response_data['success'] = True
            response_data['session'] = session_details
            response_data.pop('error')
        return JsonResponse(response_data)


# Sign Up API
@csrf_exempt
def account_sign_up(request):
    response_data = {'success': False, 'error': 'Invalid Request'}
    if request.method == 'POST':
        post_data = get_post(request)
        if verify_fields(post_data, ['email_id', 'username', 'password']):
            account = User.objects.create_user(post_data.get('username'), post_data.get('email_id'),
                                               post_data.get('password'))
            account.first_name = post_data.get('first_name', '')
            account.last_name = post_data.get('last_name', '')
            account.save()
            current_session = {}
            current_session_id = str(uuid.uuid1.hex)
            session = models.LoginSessions(account=account,
                                           active_session=json.dumps({current_session_id: current_session}))
            session.save()
            models.UserTransactions(account=account).save()
            response_data['success'] = True
            response_data['auth_key'] = session.auth_key
            response_data.pop('error')
        return JsonResponse(response_data)


# Get all values and Search for items
@csrf_exempt
def showcase(request):
    response_data = {'success': False, 'error': 'Invalid Request'}
    if request.method == 'POST':
        post_data = get_post(request)
        logged_in, account = verify_login(post_data)
        if logged_in:
            query = post_data.get('query', '').lower()
            item_list = []
            transactions = models.UserTransactions.objects.get(account=account)
            for item in models.ItemShowcase.objects.all():
                p1, p2 = str(item.item_value).split('.')
                all_shares = [share for share in transactions.active_shares.all() if share.item == item]
                item_value = p1 + '.' + (p2[::-1]).zfill(2)[::-1]
                purchased = 0
                owned = 0
                for share in transactions.active_shares.all():
                    if share.item == item:
                        purchased += share.purchase_value
                        owned += share.share_count
                net_diff = 0
                if owned > 0:
                    net_diff = owned*item.current_value/purchased * 100
                item_data = {
                    'itemName': item.item_name,
                    'itemValue': item_value,
                    'itemID': item.id,
                    'shareCount': len(all_shares),
                    'averageCost': 0 if owned == 0 else purchased/owned,
                    'shareValue': item.current_value,
                    'description': item.description,
                    'sharesWorth': round(sum([0, 0]+[share.share_count*share.item.current_value for share in all_shares]), 2)
                }
                item_data['netChange'] = 0 if item_data['sharesWorth'] == 0 else item_data['sharesWorth']/sum(share.purchase_value for share in all_shares)*100
                if query in item_data['itemName'].lower() or query in item_data['description'].lower():
                    item_list.append(item_data)
            response_data['netWorth'] = sum(val['sharesWorth'] for val in item_list)
            response_data['netChange'] = 0 if response_data['netWorth'] == 0 else response_data['netWorth']*100/sum(share.purchase_value for share in transactions.active_shares.all())
            response_data['accountBalance'] = transactions.account_balance
            response_data['items'] = item_list
            response_data['success'] = True
            response_data.pop('error')
        return JsonResponse(response_data)


# Get purchased items
@csrf_exempt
def showcase_purchased(request):
    response_data = {'success': False, 'error': 'Invalid Request'}
    if request.method == 'POST':
        post_data = get_post(request)
        logged_in, account = verify_login(post_data)
        if logged_in:
            item_list = []
            transactions = models.UserTransactions.objects.get(account=account)
            for item in models.ItemShowcase.objects.all():
                p1, p2 = str(item.item_value).split('.')
                all_shares = [share for share in transactions.active_shares.all() if share.item == item]
                if len(all_shares) == 0:
                    continue
                item_value = p1 + '.' + (p2[::-1]).zfill(2)[::-1]
                purchased = 0
                owned = 0
                for share in transactions.active_shares.all():
                    if share.item == item:
                        purchased += share.purchase_value
                        owned += share.share_count
                net_diff = 0
                if owned > 0:
                    net_diff = owned*item.current_value/purchased * 100
                item_list.append({
                    'itemName': item.item_name,
                    'itemValue': item_value,
                    'itemID': item.id,
                    'shareCount': len(all_shares),
                    'averageCost': 0 if owned == 0 else purchased/owned,
                    'shareValue': item.current_value,
                    'description': item.description,
                    'sharesWorth': round(sum([0, 0]+[share.share_count*share.item.current_value for share in all_shares]), 2)
                })
                item_list[-1]['netChange'] = 0 if item_list[-1]['sharesWorth'] == 0 else item_list[-1]['sharesWorth']/sum(share.purchase_value for share in all_shares)*100
            response_data['netWorth'] = sum(val['sharesWorth'] for val in item_list)
            response_data['netChange'] = 0 if response_data['netWorth'] == 0 else response_data['netWorth']*100/sum(share.purchase_value for share in transactions.active_shares.all())
            response_data['accountBalance'] = transactions.account_balance
            response_data['items'] = item_list
            response_data['success'] = True
            response_data.pop('error')
        return JsonResponse(response_data)



# View select item
@csrf_exempt
def showcase_item(request):
    response_data = {'success': False, 'error': 'Invalid Request'}
    if not graph_data.running:
        graph_data.toggle()
    if request.method == 'POST':
        post_data = get_post(request)
        logged_in, account = verify_login(post_data)
        if logged_in and verify_fields(post_data, ['item_id']):
            filtered_item = [item for item in models.ItemShowcase.objects.all() if item.id==int(post_data.get('item_id'))]
            if len(filtered_item) > 0:
                transactions = models.UserTransactions.objects.get(account=account)
                item = filtered_item[0]
                p1, p2 = str(item.item_value).split('.')
                purchased = 0
                owned = 0
                for share in transactions.active_shares.all():
                    if share.item == item:
                        purchased += share.purchase_value
                        owned += share.share_count
                net_diff = 0
                if owned > 0:
                    net_diff = owned*item.current_value/purchased * 100
                response_data['item'] = {
                    'itemName': item.item_name,
                    'itemValue': p1 + '.' + (p2[::-1]).zfill(2)[::-1],
                    'itemID': item.id,
                    'shareValue': item.current_value,
                    'totalShares': item.total_shares,
                    'availableShares': item.available_shares,
                    'sharesWorth': round(owned*item.current_value, 2), 
                    'shareCount': owned,
                    'netChange': net_diff,
                    'description': item.description,
                    'averageCost': 0 if owned == 0 else purchased/owned
                }
                show_type = post_data.get('show_type', 'day')
                response_data['graph'] = graph_data.get(show_type)
                response_data['success'] = True
                response_data.pop('error')
        return JsonResponse(response_data)


# Buy/Sell a share
@csrf_exempt
def new_transaction(request, transaction_type):
    response_data = {'success': False, 'error': 'Invalid Request'}
    if request.method == 'POST':
        post_data = get_post(request)
        logged_in, account = verify_login(post_data)
        if logged_in and verify_fields(post_data, ['item_id', 'share_count']):
            transactions = models.UserTransactions.objects.get(account=account)
            item = models.ItemShowcase.objects.get(id=int(post_data.get('item_id', 0)))
            share_count = float(post_data.get('share_count'))
            if transaction_type == 'buy':
                if share_count > item.available_shares:
                    response_data['error'] = 'Quantity of requested shares not available. Max available: {}'.format(item.available_shares)
                else:
                    purchase_value = item.current_value * share_count
                    if transactions.account_balance >= purchase_value:
                        item.available_shares -= share_count
                        item.save()
                        share = models.ItemShare(item=item, purchase_value=purchase_value, share_count=share_count)
                        share.save()
                        transactions.active_shares.add(share)
                        transactions.account_balance -= purchase_value
                        transactions.save()
                        response_data['success'] = True
                        response_data['result'] = 'Transaction Completed'
                        response_data.pop('error')
                    else:
                        response_data['error'] = 'Insufficient Funds. Required: ${}, Available: ${}'.format(purchase_value, transactions.account_balance)
            elif transaction_type == 'sell':
                transactions = models.UserTransactions.objects.get(account=account)
                owned = 0
                for _share in transactions.active_shares.all():
                    if _share.item == item:
                        owned += _share.share_count
                if share_count > owned:
                    response_data['error'] = 'Quantity of requested shares not available. Max available: {}'.format(owned)
                else:
                    purchase_value = item.current_value * share_count
                    item.available_shares += share_count
                    item.save()
                    to_remove = share_count
                    queryset = transactions.active_shares.all()
                    for share in queryset:
                        if to_remove == 0:
                            break
                        if share.share_count <= to_remove:
                            to_remove -= share.share_count
                            transactions.previous_shares.add(share)
                            transactions.active_shares.remove(share)
                        else:
                            share.share_count = share.share_count - to_remove
                            share.save()
                            to_remove = 0
                    transactions.account_balance = transactions.account_balance - purchase_value
                    transactions.save()
                    response_data['success'] = True
                    response_data['result'] = 'Transaction Completed'
                    response_data.pop('error')
        return JsonResponse(response_data)
