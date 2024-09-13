import {
  BaseEntity,
  Column,
  Entity,
  ManyToOne,
  OneToMany,
  PrimaryGeneratedColumn,
} from 'typeorm';
import { User } from './user.entity';
import { LanguageTypeEnum } from './enum/languageType.enum';

@Entity()
export class Language extends BaseEntity {
  @PrimaryGeneratedColumn()
  lang_id: number;

  @Column()
  type: LanguageTypeEnum;

  @OneToMany((type) => User, (user) => user.language, { eager: false }) // 언어분류 < 유저정보
  user: User;
}
