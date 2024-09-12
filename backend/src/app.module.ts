import { Module } from '@nestjs/common';
import { UserModule } from './domain/user/user.module';
import { ShelterModule } from './domain/shelter/shelter.module';

@Module({
  imports: [UserModule, ShelterModule],
  controllers: [],
  providers: [],
})
export class AppModule {}
