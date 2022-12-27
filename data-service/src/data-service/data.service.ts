import { Injectable } from '@nestjs/common';
import { InjectModel } from '@nestjs/mongoose';
import { Model } from 'mongoose';
import { CryptoData, CryptoDataDocument } from './schema/data.schema';
import { CreateCryptoDataDto } from './dto/create-data.dto';

@Injectable()
export class DataService {
  constructor(
    @InjectModel(CryptoData.name)
    private readonly model: Model<CryptoDataDocument>,
  ) {}
  async findAll(): Promise<CryptoData[]> {
    return await this.model.find().exec();
  }
  async create(createCryptoData: CreateCryptoDataDto): Promise<CryptoData> {
    return await new this.model({
      ...createCryptoData,
    }).save();
  }
  async findOneNearest(
    crytoName: string,
    numberOfDay: number,
  ): Promise<CryptoData> {
    const result = await this.model
      .find({
        cryptoId: crytoName,
        numberOfDay: numberOfDay,
      })
      .sort({ time: -1 });
    return result[0];
  }
}
