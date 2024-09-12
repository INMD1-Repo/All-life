import {
  BaseEntity,
  Column,
  Entity,
  OneToMany,
  PrimaryGeneratedColumn,
} from 'typeorm';
import { ShelterChecklistAnswer } from './shelter_checklist_answer.entity';
import { ShelterInfo } from './shelter_info.entity';

@Entity()
export class ShelterType extends BaseEntity {
  @PrimaryGeneratedColumn()
  shelter_type_id: number;

  @Column()
  desc: string;

  @OneToMany((type) => ShelterInfo, (shelterInfo) => shelterInfo.shelterType, {
    eager: true,
  }) // 대피소 정보 < 점검 답변
  shelterInfo: ShelterChecklistAnswer;
}
