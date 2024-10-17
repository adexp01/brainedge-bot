/*
  Warnings:

  - You are about to drop the column `results` on the `CompletedQuiz` table. All the data in the column will be lost.
  - Added the required column `maxScore` to the `CompletedQuiz` table without a default value. This is not possible if the table is not empty.
  - Added the required column `score` to the `CompletedQuiz` table without a default value. This is not possible if the table is not empty.

*/
-- AlterTable
ALTER TABLE "CompletedQuiz" DROP COLUMN "results",
ADD COLUMN     "maxScore" DOUBLE PRECISION NOT NULL,
ADD COLUMN     "score" DOUBLE PRECISION NOT NULL;
