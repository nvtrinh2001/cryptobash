import { Injectable } from '@nestjs/common';
import { InjectModel } from '@nestjs/mongoose';
import { Model } from 'mongoose';
import { CryptoData, CryptoDataDocument } from './schema/data.schema';
import { CreateCryptoDataDto } from './dto/create-data.dto';
import { QueryDataDto } from './dto/query-data.dto';

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
  async findOneNearest(query: QueryDataDto): Promise<CryptoData> {
    console.log('querying...');
    console.log(query);
    const result = await this.model
      .find({
        crytoId: query.crytoName,
      })
      .exec();
    console.log(result);
    let index = 0;
    for (let i = 0; i < result.length; i++) {
      if (result[i].numberOfDay == query.numberOfDay) {
        index = i;
      }
    }
    //console.log(result);
    return result[index];
  }
  async update(
    id: string,
    updateData: CreateCryptoDataDto,
  ): Promise<CryptoData> {
    return await this.model.findByIdAndUpdate(id, updateData).exec();
  }

  async delete(id: string): Promise<any> {
    return await this.model.findByIdAndDelete(id).exec();
  }
}
