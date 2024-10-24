import { PrismaClient } from "@prisma/client";

const prisma = new PrismaClient();

export const getStats = async () => {
  return await prisma.stats.findMany({
    take: 1,
    orderBy: {
      createdAt: "desc"
    }
  });
};

export const writeMetrics = async () => {
  const generalMetrics = await getAppMetrics();
  console.log(generalMetrics);
  const gamePlayed = await getUsersGamePlayed();
  console.log(gamePlayed);
  const userActivityMetrics = await getUserActivityMetrics();
  console.log(userActivityMetrics);
  const taskCompletion = await getTaskCompletion();
  console.log(taskCompletion);

  await prisma.stats.create({
    data: {
      ...generalMetrics,
      ...gamePlayed,
      ...userActivityMetrics,
      specificTaskCompletion: taskCompletion
    }
  });
};

export const getUsersGamePlayed = async () => {
  const lowPop = await prisma.clickerUser.count({
    where: {
      lowPopLimit: {
        not: 2
      }
    }
  });

  const brainSlate = await prisma.clickerUser.count({
    where: {
      brainSlateLimit: {
        not: 2
      }
    }
  });

  const smileQuest = await prisma.clickerUser.count({
    where: {
      smileQuestLimit: {
        not: 2
      }
    }
  });

  const lowPopAndBrainSlate = await prisma.clickerUser.count({
    where: {
      AND: [
        {
          lowPopLimit: {
            not: 2
          }
        },
        {
          brainSlateLimit: {
            not: 2
          }
        }
      ]
    }
  });

  const lowPopAndSmileQuest = await prisma.clickerUser.count({
    where: {
      AND: [
        {
          lowPopLimit: {
            not: 2
          }
        },
        {
          smileQuestLimit: {
            not: 2
          }
        }
      ]
    }
  });

  const smileQuestAndBrainSlate = await prisma.clickerUser.count({
    where: {
      AND: [
        {
          brainSlateLimit: {
            not: 2
          }
        },
        {
          smileQuestLimit: {
            not: 2
          }
        }
      ]
    }
  });

  const allGamesPlayed = await prisma.clickerUser.count({
    where: {
      AND: [
        {
          lowPopLimit: {
            not: 2
          }
        },
        {
          brainSlateLimit: {
            not: 2
          }
        },
        {
          smileQuestLimit: {
            not: 2
          }
        }
      ]
    }
  });

  return {
    lowPop,
    brainSlate,
    smileQuest,
    lowPopAndBrainSlate,
    lowPopAndSmileQuest,
    smileQuestAndBrainSlate,
    allGamesPlayed
  };
};

export const getUserActivityMetrics = async () => {
  const now = new Date();
  const startOfDay = new Date(now.getFullYear(), now.getMonth(), now.getDate());
  const threeDaysAgo = new Date(startOfDay);
  threeDaysAgo.setDate(startOfDay.getDate() - 3);
  const sevenDaysAgo = new Date(startOfDay);
  sevenDaysAgo.setDate(startOfDay.getDate() - 7);
  const fourteenDaysAgo = new Date(startOfDay);
  fourteenDaysAgo.setDate(startOfDay.getDate() - 14);
  const thirtyDaysAgo = new Date(startOfDay);
  thirtyDaysAgo.setDate(startOfDay.getDate() - 30);

  const dailyActiveUsers = await prisma.clickerUser.count({
    where: {
      lastLogin: {
        gt: startOfDay
      }
    }
  });

  const inactiveLast3Days = await prisma.clickerUser.count({
    where: {
      OR: [{ lastLogin: { lt: threeDaysAgo } }, { lastLogin: null }]
    }
  });

  const inactiveLast7Days = await prisma.clickerUser.count({
    where: {
      OR: [{ lastLogin: { lt: sevenDaysAgo } }, { lastLogin: null }]
    }
  });

  const inactiveLast14Days = await prisma.clickerUser.count({
    where: {
      OR: [{ lastLogin: { lt: fourteenDaysAgo } }, { lastLogin: null }]
    }
  });

  const inactiveLast30Days = await prisma.clickerUser.count({
    where: {
      OR: [{ lastLogin: { lt: thirtyDaysAgo } }, { lastLogin: null }]
    }
  });

  const activeSinceLast3Days = await prisma.clickerUser.count({
    where: {
      lastLogin: {
        gt: threeDaysAgo
      }
    }
  });

  const activeSinceLast7Days = await prisma.clickerUser.count({
    where: {
      lastLogin: {
        gt: sevenDaysAgo
      }
    }
  });

  const activeSinceLast14Days = await prisma.clickerUser.count({
    where: {
      lastLogin: {
        gt: fourteenDaysAgo
      }
    }
  });

  const activeSinceLast30Days = await prisma.clickerUser.count({
    where: {
      lastLogin: {
        gt: thirtyDaysAgo
      }
    }
  });

  return {
    dailyActiveUsers,
    inactiveLast3Days,
    inactiveLast7Days,
    inactiveLast14Days,
    inactiveLast30Days,
    activeSinceLast3Days,
    activeSinceLast7Days,
    activeSinceLast14Days,
    activeSinceLast30Days
  };
};

export const getAppMetrics = async () => {
  const defaultFullTank = 2;
  const startOfDay = new Date();
  startOfDay.setHours(0, 0, 0, 0);

  const users = await prisma.clickerUser.count();

  const fullTankSum = await prisma.clickerUser.aggregate({
    _sum: {
      fullTank: true
    }
  });

  const bp = await prisma.clickerUser.aggregate({
    _sum: {
      balance: true
    }
  });

  const hats = await prisma.clickerUser.aggregate({
    _sum: {
      hat: true
    }
  });

  const weeklyUsers = await prisma.clickerUser.count({
    where: {
      weeklyBalance: {
        gt: 0
      }
    }
  });

  const claimed10K = await prisma.clickerUser.count({
    where: {
      dailyBalance: {
        gte: 10000
      }
    }
  });

  const claimedDailyReward = await prisma.clickerUser.count({
    where: {
      dailyRewardClaimedAt: {
        not: null
      }
    }
  });

  const completedDailyTasks = await prisma.clickerUser.count({
    where: {
      dailyTaskCompletion: {
        gte: 5
      }
    }
  });

  const completedDailyTasksAndClaimDailyReward = await prisma.clickerUser.count(
    {
      where: {
        AND: [
          {
            dailyTaskCompletion: {
              gte: 5
            }
          },
          {
            dailyRewardClaimedAt: {
              not: null
            }
          }
        ]
      }
    }
  );

  let fullTanksUsed = 0;
  if (fullTankSum?._sum?.fullTank) {
    fullTanksUsed = users * defaultFullTank - fullTankSum?._sum?.fullTank;
  }

  return {
    totalUsers: users,
    boostsUsed: fullTanksUsed,
    bp: bp._sum.balance ?? 0,
    hats: hats._sum.hat ?? 0,
    weeklyActiveUsers: weeklyUsers,
    claimed10K,
    claimedDailyReward,
    completedDailyTasks,
    completedDailyTasksAndClaimDailyReward
  };
};

export const getTaskCompletion = async () => {
  const tasks = await prisma.task.findMany();
  const specificTaskCompletion = [];

  for (const task of tasks) {
    const count = await prisma.clickerUserTaskCompletion.count({
      where: {
        taskId: task.id,
        completedAt: {
          not: null
        }
      }
    });

    specificTaskCompletion.push({ title: task.description, value: count });
  }

  return specificTaskCompletion;
};
