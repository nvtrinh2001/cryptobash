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
  crytoId: string;

  @Prop()
  time: number;

  @Prop()
  numberOfDay: number;

  @Prop()
  prices: Element[];
}

export const CryptoDataSchema = SchemaFactory.createForClass(CryptoData);
