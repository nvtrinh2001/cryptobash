import { Module } from '@nestjs/common';
import { DataService } from './data.service';
//import { dataController } from './data.controller';
import { MongooseModule } from '@nestjs/mongoose';
import { CryptoData, CryptoDataSchema } from './schema/data.schema';

@Module({
  //controllers: [dataController],
  providers: [DataService],
  imports: [
    MongooseModule.forFeature([
      { name: CryptoData.name, schema: CryptoDataSchema },
    ]),
  ],
  exports: [DataService],
})
export class DataModule {}
