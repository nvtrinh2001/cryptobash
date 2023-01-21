import {
  CallHandler,
  ExecutionContext,
  Injectable,
  NestInterceptor,
} from '@nestjs/common';
import { Request } from 'express';
import { Observable, map } from 'rxjs';

export interface Response<T> {
  statusCode: number;
  message: string;
  data: T;
}

@Injectable()
export class ResponseInterceptor<T> implements NestInterceptor<T, Response<T>> {
  intercept(
    context: ExecutionContext,
    next: CallHandler<any>,
  ): Observable<Response<T>> | Promise<Observable<Response<T>>> {
    return next.handle().pipe(
      map((data) => {
        const ctx = context.switchToHttp();
        const request = ctx.getRequest<Request>();
        if (request.method === 'POST') {
          return {
            statusCode: 201,
            message: 'success',
            data: data,
          };
        }
        if (
          request.method === 'GET' &&
          context.getClass().name == 'WeatherController' &&
          context.getHandler().name == 'findTime'
        ) {
          return {
            statusCode: 200,
            message: 'success',
            data: data.data,
          };
        } else {
          return {
            statusCode: 200,
            message: 'success',
            data: data,
          };
        }
      }),
    );
  }
}
