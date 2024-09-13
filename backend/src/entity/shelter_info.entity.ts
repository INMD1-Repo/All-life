import {
  BaseEntity,
  Column,
  Entity,
  ManyToOne,
  OneToMany,
  PrimaryGeneratedColumn,
} from 'typeorm';
import { ShelterType } from './shelter_type.entity';
import { ShelterChecklistAnswer } from './shelter_checklist_answer.entity';

@Entity()
export class ShelterInfo extends BaseEntity {
  @PrimaryGeneratedColumn()
  shelter_info_id: number;

  @Column()
  name: string;

  @Column()
  score: string;

  @ManyToOne((type) => ShelterType, (shelterType) => shelterType.shelterInfo, {
    eager: true,
  }) // 대비소 정보 > 대피소 분류
  shelterType: ShelterType;

  @OneToMany(
    (type) => ShelterChecklistAnswer,
    (shelterChecklistAnswer) => shelterChecklistAnswer.shelterInfo,
    { eager: true },
  ) // 대피소 정보 < 점검 답변
  shelterChecklistAnswer: ShelterChecklistAnswer;
}
