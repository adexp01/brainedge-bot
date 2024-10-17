/*
  Warnings:

  - You are about to drop the column `questionsJson` on the `LessonCompletion` table. All the data in the column will be lost.
  - You are about to drop the column `slug` on the `LessonCompletion` table. All the data in the column will be lost.
  - You are about to drop the column `title` on the `LessonCompletion` table. All the data in the column will be lost.
  - You are about to drop the column `videoSrc` on the `LessonCompletion` table. All the data in the column will be lost.

*/
-- AlterTable
ALTER TABLE "LessonCompletion" DROP COLUMN "questionsJson",
DROP COLUMN "slug",
DROP COLUMN "title",
DROP COLUMN "videoSrc";
