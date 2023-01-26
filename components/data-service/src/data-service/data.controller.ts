import {
  Body,
  Controller,
  Delete,
  Get,
  Param,
  Post,
  Put,
  Query,
} from '@nestjs/common';
import { DataService } from './data.service';
import { CreateCryptoDataDto } from './dto/create-data.dto';
import { QueryDataDto } from './dto/query-data.dto';

@Controller('data-service')
export class DataController {
  constructor(private readonly dataService: DataService) {}

  @Get()
  findOne(@Query() query: QueryDataDto) {
    return this.dataService.findOneNearest(query);
  }
  @Post()
  create(@Body() createData: CreateCryptoDataDto) {
    return this.dataService.create(createData);
  }
  @Put(':id')
  async update(
    @Param('id') id: string,
    @Body() updateData: CreateCryptoDataDto,
  ) {
    return await this.dataService.update(id, updateData);
  }
  @Delete(':id')
  async delete(@Param('id') id: string) {
    return await this.dataService.delete(id);
  }
}
