import { ValidationPipe } from '@nestjs/common';
import { NestFactory } from '@nestjs/core';
import { DocumentBuilder, SwaggerModule } from '@nestjs/swagger';
import { AppModule } from './app.module';
import { ResponseInterceptor } from './interceptors/response.interceptor';

async function bootstrap() {
  const app = await NestFactory.create(AppModule);
  app.setGlobalPrefix('crypto');
  app.enableCors();
  app.useGlobalPipes(
    new ValidationPipe({ whitelist: true, validateCustomDecorators: true }),
  );
  app.useGlobalInterceptors(new ResponseInterceptor());
  const config = new DocumentBuilder()
    .setTitle('Crypto Service version 1.0')
    .setDescription('content API description')
    .setVersion('1.0')
    .addTag('crypto-service')
    .build();
  const document = SwaggerModule.createDocument(app, config);
  SwaggerModule.setup('/crypto/swagger', app, document);
  await app.listen(3000);
}
bootstrap();
