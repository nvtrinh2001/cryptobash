import { IsNotEmpty } from 'class-validator';
import { ApiProperty } from '@nestjs/swagger';

export class QueryDataDto {
  @ApiProperty()
  @IsNotEmpty()
  crytoName: string;

  @ApiProperty()
  @IsNotEmpty()
  numberOfDay: number;
}
