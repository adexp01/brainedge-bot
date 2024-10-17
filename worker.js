import { Worker } from "bullmq";
import { PrismaClient, Prisma } from "@prisma/client";
import { getRedisConnection } from "./redisProvider.js";

const prisma = new PrismaClient();

async function logErrorToDatabase(
  model,
  message,
  action,
  args
) {
  try {
    await prisma.log.create({
      data: {
        model,
        message,
        action,
        args
      }
    });
  } catch (error) {
    console.error("Failed to log error to the database:", error);
  }
}

prisma.$use(async (params, next) => {
  try {
    const result = await next(params);
    return result;
  } catch (error) {
    await logErrorToDatabase(
      params?.model ?? "",
      error?.meta?.message ?? "",
      params?.action ?? "",
      JSON.stringify(params?.args ?? "")
    );

    throw error;
  }
});


const redisConnection = getRedisConnection();
const worker = new Worker(
  "updateUserTask",
  async (job) => {
    const { userIds, offset } = job.data;
    console.log(`Updating ${userIds.length} users...`);
    const result = await prisma.$executeRaw`
    UPDATE "ClickerUser"
    SET 
      "dailyRewardStreak" = CASE
        WHEN "dailyRewardStreak" != 21 THEN CASE
          WHEN "dailyRewardClaimedAt" IS NULL THEN 0
          WHEN "dailyRewardClaimedAt" IS NOT NULL THEN "dailyRewardStreak" + 1
        END
        ELSE 0
      END,
      "dailyRewardClaimedAt" = CASE
        WHEN "dailyRewardClaimedAt" IS NOT NULL THEN NULL
        ELSE "dailyRewardClaimedAt"
      END,
      "tapingGuru" = 4,
      "fullTank" = 2,
      "tapingGuruTimeOut" = NULL,
      "fullTankTimeOut" = NULL,
      "multiTapUpgradeCount" = 0,
      "EnergyLimitUpgradeCount" = 0,
      "dailyBalance" = 0,
      "heart" = 5,
      "dailyTaskCompletion" = 0,
      "lowPopLimit" = 2,
      "brainSlateLimit" = 2,
      "smileQuestLimit" = 2
    WHERE "id" IN (${Prisma.join(userIds)})`;
    await redisConnection.set("lastProcessedUserId", offset);
    if (result.length > 0) {
      console.log(`Updated ${result} users.`);
    }
  },
  { connection: redisConnection }
);

worker.on("completed", async (job) => {
  console.log(`Job ${job.id} has been completed successfully!`);
  await job.remove();
});

worker.on("failed", async (job, err) => {
  console.error(`Job ${job.id} failed with error: ${err.message}`);
  await job.remove();
});
