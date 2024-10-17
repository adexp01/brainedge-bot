/*
  Warnings:

  - You are about to drop the `CompletedQuiz` table. If the table is not empty, all the data it contains will be lost.
  - You are about to drop the `_CompletedQuiz` table. If the table is not empty, all the data it contains will be lost.
  - Added the required column `score` to the `LessonCompletion` table without a default value. This is not possible if the table is not empty.

*/
-- DropForeignKey
ALTER TABLE "_CompletedQuiz" DROP CONSTRAINT "_CompletedQuiz_A_fkey";

-- DropForeignKey
ALTER TABLE "_CompletedQuiz" DROP CONSTRAINT "_CompletedQuiz_B_fkey";

-- AlterTable
ALTER TABLE "LessonCompletion" ADD COLUMN     "score" DOUBLE PRECISION NOT NULL;

-- DropTable
DROP TABLE "CompletedQuiz";

-- DropTable
DROP TABLE "_CompletedQuiz";
