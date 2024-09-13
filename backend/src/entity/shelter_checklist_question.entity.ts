import {
  BaseEntity,
  Column,
  Entity,
  OneToMany,
  PrimaryGeneratedColumn,
} from 'typeorm';
import { ShelterChecklistAnswer } from './shelter_checklist_answer.entity';

@Entity()
export class ShelterChecklistQuestion extends BaseEntity {
  @PrimaryGeneratedColumn()
  q_id: number;

  @Column()
  sentence: string;

  @OneToMany(
    (type) => ShelterChecklistAnswer,
    (shelterChecklistAnswer) => shelterChecklistAnswer.shelterChecklistQuestion,
    { eager: false },
  ) // 점검 질문지 < 점검 답변
  shelterChecklistAnswer: ShelterChecklistAnswer;
}
