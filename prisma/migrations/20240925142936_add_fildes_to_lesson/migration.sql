/*
  Warnings:

  - Added the required column `questionsJson` to the `LessonCompletion` table without a default value. This is not possible if the table is not empty.
  - Added the required column `slug` to the `LessonCompletion` table without a default value. This is not possible if the table is not empty.
  - Added the required column `title` to the `LessonCompletion` table without a default value. This is not possible if the table is not empty.
  - Added the required column `videoSrc` to the `LessonCompletion` table without a default value. This is not possible if the table is not empty.

*/
-- AlterTable
ALTER TABLE "LessonCompletion" ADD COLUMN     "questionsJson" JSONB NOT NULL,
ADD COLUMN     "slug" TEXT NOT NULL,
ADD COLUMN     "title" TEXT NOT NULL,
ADD COLUMN     "videoSrc" JSONB NOT NULL;
