import { Module } from '@nestjs/common';
import { ConfigModule, ConfigService } from '@nestjs/config';
import { MongooseModule } from '@nestjs/mongoose';
import { ScheduleModule } from '@nestjs/schedule';
import { AppController } from './app.controller';
import { AppService } from './app.service';
import { AppTask } from './app.task';
import { DataModule } from './data-service/data.module';

const ENV = process.env.NODE_ENV;
@Module({
  imports: [
    ConfigModule.forRoot({
      envFilePath: !ENV ? '.env' : `.env.${ENV}`,
      isGlobal: true,
    }),
    MongooseModule.forRootAsync({
      imports: [ConfigModule],
      useFactory: async (configService: ConfigService) => ({
        uri: configService.get<string>('DATABASE_URI'),
        dbName: configService.get<string>('DATABASE_DB'),
        // useNewUrlParser: true,
        // useUnfiedTopology: true,
      }),
      inject: [ConfigService],
    }),
    ScheduleModule.forRoot(),
    DataModule,
  ],
  controllers: [AppController, AppTask],
  providers: [AppService],
})
export class AppModule {}
