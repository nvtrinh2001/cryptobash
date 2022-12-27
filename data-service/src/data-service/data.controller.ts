import { Controller, Get, Query } from '@nestjs/common';
import { DataService } from './data.service';

@Controller()
export class DataController {
  constructor(private readonly dataService: DataService) {}

  @Get()
  findOne(@Query() crytoName: string, numberOfDay: number) {
    return this.dataService.findOneNearest(crytoName, numberOfDay);
  }
}
