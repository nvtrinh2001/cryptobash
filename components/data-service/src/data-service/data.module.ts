import { Module } from '@nestjs/common';
import { DataService } from './data.service';
import { DataController } from './data.controller';
import { MongooseModule } from '@nestjs/mongoose';
import { CryptoData, CryptoDataSchema } from './schema/data.schema';

@Module({
  controllers: [DataController],
  providers: [DataService],
  imports: [
    MongooseModule.forFeature([
      { name: CryptoData.name, schema: CryptoDataSchema },
    ]),
  ],
  exports: [DataService],
})
export class DataModule {}
