import { Prop, Schema, SchemaFactory } from '@nestjs/mongoose';
import { Document } from 'mongoose';

export type CryptoDataDocument = CryptoData & Document;

@Schema({ _id: false })
export class Element {
  x: number[];
}

@Schema()
export class CryptoData {
  @Prop()
  crytoId: string; // name of the crypto currency

  @Prop()
  time: number; // time of the record

  @Prop()
  numberOfDay: number; // the number of days until now

  @Prop()
  prices: Element[]; // the data of prices for each currency
}

export const CryptoDataSchema = SchemaFactory.createForClass(CryptoData);
