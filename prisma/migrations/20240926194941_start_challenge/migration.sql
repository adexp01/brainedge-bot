-- AlterTable
ALTER TABLE "ClickerUserTaskCompletion" ADD COLUMN     "started" BOOLEAN NOT NULL DEFAULT false,
ALTER COLUMN "completedAt" DROP NOT NULL,
ALTER COLUMN "completedAt" DROP DEFAULT;
