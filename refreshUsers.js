import { PrismaClient } from "@prisma/client";
import TasksService from "./task-service.js";
import { getRedisConnection } from "./redisProvider.js";

const DATABASE_URL = process.env.DATABASE_URL;
const redisConnection = getRedisConnection();
const prisma = new PrismaClient({
  datasources: {
    db: {
      url: DATABASE_URL,
    },
  },
});

const tasksService = new TasksService();

const refreshUserClickerData = async () => {
  const BATCH_SIZE = 10000;

  const addUpdateTask = async (userIds, offset) => {
    const taskPayload = { userIds, offset };
    await tasksService.addTask("updateUserTask", taskPayload);
  };

  const updateUsersInBatches = async () => {
    let offset =
      parseInt(await redisConnection.get("lastProcessedUserId")) || 0;
    let hasMore = true;
    console.log(offset, hasMore, "offset, hasMore");

    while (hasMore) {
      const userIds = await prisma.clickerUser.findMany({
        select: { id: true },
        skip: offset,
        take: BATCH_SIZE,
      });

      if (userIds.length > 0) {
        await addUpdateTask(
          userIds.map((user) => user.id),
          offset
        );

        offset += userIds.length;
      } else {
        hasMore = false;
        console.log("Starting to remove all tasks");
        await tasksService.removeAllTasks();
      }
    }

    await redisConnection.del("lastProcessedUserId");
  };

  await updateUsersInBatches();
};

export default refreshUserClickerData;
