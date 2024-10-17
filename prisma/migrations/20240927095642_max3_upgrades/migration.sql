/*
  Warnings:

  - The `friends100RewardClaimed` column on the `ClickerUser` table would be dropped and recreated. This will lead to data loss if there is data in the column.

*/
-- AlterTable
ALTER TABLE "ClickerUser" ADD COLUMN     "EnergyLimitUpgradeCount" INTEGER NOT NULL DEFAULT 0,
ADD COLUMN     "multiTapUpgradeCount" INTEGER NOT NULL DEFAULT 0,
DROP COLUMN "friends100RewardClaimed",
ADD COLUMN     "friends100RewardClaimed" INTEGER NOT NULL DEFAULT 0;
