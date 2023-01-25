from keras.models import load_model
from sklearn.preprocessing import StandardScaler
import numpy as np 
import datetime
from datetime import datetime
from binance.client import Client 

# load model
model = load_model('./components/predict/Predictive_model.h5')

# summarize model.
model.summary()
import os
from dotenv import load_dotenv

load_dotenv()

COIN_ID = os.getenv('COIN_ID')
HOURS = os.getenv('HOURS')
MINUTES = int(HOURS) * 60

api_key = 'paste your keys here'
api_secret = 'paste your keys here'
client = Client(api_key, api_secret)
candles = client.get_klines(symbol=COIN_ID + 'USDT', interval=Client.KLINE_INTERVAL_1MINUTE)

price = np.array([float(candles[i][4]) for i in range(500)])
time = np.array([int(candles[i][0]) for i in range(500)])
t = np.array([datetime.fromtimestamp(time[i]/1000).strftime('%H:%M:%S') for i in range(500)])
price.shape
price = price.reshape(500,1)

scaler = StandardScaler()
scaler.fit(price[:374])
price = scaler.transform(price)

check = client.get_klines(symbol=COIN_ID + 'USDT', interval=Client.KLINE_INTERVAL_1MINUTE)
hour = 0
index = [496,495,498,499]
while (hour < int(MINUTES)):
  candles = scaler.transform(np.array([float(check[i][4]) for i in index]).reshape(-1,1))
  model_feed = candles.reshape(1,4,1)
  index.pop(0)
  index.append(index[2] + 1)
  result = [check[index[2]][0] + 60000, 0, 0, 0, scaler.inverse_transform(model.predict(model_feed)[0].reshape(-1,1))[0][0]]
  check.append(result)
  hour += 1

f = open("/var/tmp/actual-data.txt", "w")
for element in check[:500]:
    f.write(datetime.fromtimestamp(element[0]/1000).strftime('%H:%M:%S %d-%m-%Y') + ',' + str(element[4]) + '\n')
f.close()

f = open("/var/tmp/predicted-data.txt", "w")
for element in check[500:]:
  f.write(datetime.fromtimestamp(element[0]/1000).strftime('%H:%M:%S %d-%m-%Y') + ',' + str(element[4]) + '\n')
f.close()
