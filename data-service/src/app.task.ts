import { Controller, OnModuleInit } from '@nestjs/common';
import { Cron } from '@nestjs/schedule';
import fetch from 'node-fetch';
import data from './data/cryptoList.json';
import { DataService } from './data-service/data.service';

@Controller()
export class AppTask implements OnModuleInit {
  constructor(private readonly service: DataService) {}

  @Cron('* 21 * * *') // cronTime to change call every day
  async handleCron1() {
    console.log('Cron task');
    await this.updateCrytoData();
  }

  async onModuleInit() {
    await this.updateCrytoData();
  }
  sleep(ms) {
    return new Promise((resolve) => setTimeout(resolve, ms));
  }
  async updateCrytoData() {
    console.log('update cryto data');
    console.log('importing');
    const numberOfDays = [7, 14, 30];
    for (let i = 0; i < data.length; i++) {
      for (let j = 0; j < numberOfDays.length; j++) {
        const coinId = data[i].id;
        //const currentcy = 'usd';
        // 7 days
        const numberOfDay = numberOfDays[j];
        const tmp_url =
          'https://api.coingecko.com/api/v3/coins/' +
          coinId +
          '/market_chart?vs_currency=usd&days=' +
          numberOfDay +
          '&interval=hourly';
        const url = new URL(tmp_url);
        const result = await fetch(url, {
          method: 'GET',
          headers: {
            Accept: '*/*',
            'Content-Type': 'application/json',
            Connection: 'keep-alive',
          },
        })
          .then((response) => {
            if (response.ok) {
              return response.json();
            }
            return response.json().then((response) => {
              throw new Error(response.error + ' Message: ' + response.message);
            });
          })
          .catch(function (error) {
            console.log('Error at element i:' + i + ' and j: ' + j);
            console.error(error);
          });
        //storing data
        const tmp_data = {
          crytoId: coinId,
          time: new Date().getTime(),
          numberOfDay: numberOfDay,
          prices: result.prices,
        };
        await this.service.create(tmp_data);
        //await delay(4000);
      }
      await this.sleep(20000);
    }
    console.log('Done');
  }
}
