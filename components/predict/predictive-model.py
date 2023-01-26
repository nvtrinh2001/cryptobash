import numpy as np 
import pandas as pd
import datetime

from sklearn.metrics import mean_squared_error

from keras.layers.core import Dense, Activation, Dropout
from keras.layers import LSTM
from keras.models import Sequential

from datetime import datetime
from binance.client import Client 
import os
from dotenv import load_dotenv

load_dotenv()

COIN_ID = os.getenv('COIN_ID')

api_key = 'paste your keys here'
api_secret = 'paste your keys here'

client = Client(api_key, api_secret)

candles = client.get_klines(symbol=COIN_ID + 'USDT', interval=Client.KLINE_INTERVAL_1MINUTE)

price = np.array([float(candles[i][4]) for i in range(500)])
time = np.array([int(candles[i][0]) for i in range(500)])

t = np.array([datetime.fromtimestamp(time[i]/1000).strftime('%H:%M:%S') for i in range(500)])
price.shape

timeframe = pd.DataFrame({'Time':t,'Price':price})
print(timeframe)

price = price.reshape(500,1)
from sklearn.preprocessing import StandardScaler

scaler = StandardScaler()
scaler.fit(price[:374])

price = scaler.transform(price)
df = pd.DataFrame(price.reshape(100,5),columns=['First','Second','Third','Fourth','Target'])
df.head()

#75% train , 25% test

x_train = df.iloc[:74,:4]
y_train = df.iloc[:74,-1]

x_test = df.iloc[75:99,:4]
y_test = df.iloc[75:99,-1]
x_train = np.array(x_train)
y_train = np.array(y_train)
x_test = np.array(x_test)
y_test = np.array(y_test)
x_train = np.reshape(x_train, (x_train.shape[0], x_train.shape[1], 1))
x_test  = np.reshape(x_test, (x_test.shape[0], x_test.shape[1], 1))
x_train.shape , x_test.shape

model = Sequential()

model.add(LSTM(20, return_sequences=True, input_shape=(4, 1)))
model.add(LSTM(40, return_sequences=False))
model.add(Dense(1, activation='linear'))
model.compile(loss='mse', optimizer='rmsprop')

model.summary()

model.fit(x_train, y_train, batch_size=5,epochs=100)

y_pred = model.predict(x_test)

testScore = np.sqrt(mean_squared_error(scaler.inverse_transform(y_test.reshape(-1,1)),scaler.inverse_transform(y_pred)))
print('Test Score: %.2f RMSE' % (testScore))

from sklearn.metrics import r2_score

print('RSquared :','{:.2%}'.format(r2_score(y_test,y_pred)))

model.save("./components/predict/Predictive_model.h5")

