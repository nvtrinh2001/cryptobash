import { ApiProperty } from '@nestjs/swagger';
import { IsNotEmpty, IsNumber, IsString } from 'class-validator';

export class ElementDto {
  x: number;
  y: number;
}

export class CreateCryptoDataDto {
  @IsNotEmpty()
  @IsString()
  @ApiProperty()
  crytoId: string;

  @IsNumber()
  @IsNotEmpty()
  @ApiProperty()
  time: number;

  @IsNumber()
  @IsNotEmpty()
  @ApiProperty()
  numberOfDay: number;

  @IsNotEmpty()
  @ApiProperty()
  prices: Element[];
}
