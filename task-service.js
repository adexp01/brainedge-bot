import pkg from "bullmq";
const { Queue, FlowProducer } = pkg;
import { getRedisConnection } from "./redisProvider.js";

class TasksService {
  getQueue(taskName) {
    return new Queue(taskName, {
      connection: getRedisConnection(),
    });
  }

  async addTask(taskName, taskPayload, jobOptions = {}) {
    const queue = this.getQueue(taskName);
    await queue.add(taskName, taskPayload, {
      attempts: 10,
      backoff: {
        type: "fixed",
        delay: 3000,
      },
      priority: 1,
      removeOnComplete: {
        count: 100,
      },
      removeOnFail: true,
      ...jobOptions,
    });
    await queue.close();
  }

  async removeTask(taskName, jobId) {
    const queue = this.getQueue(taskName);
    await queue.remove(jobId);
    await queue.close();
  }

  async getTask(taskName, jobId) {
    const queue = this.getQueue(taskName);
    const job = await queue.getJob(jobId);
    await queue.close();
    return job;
  }

  async createTaskFlow(
    parentTaskName,
    parentTaskData,
    parentTaskOptions,
    childTasks
  ) {
    const flowProducer = new FlowProducer({ connection: getRedisConnection() });

    await flowProducer.add({
      queueName: parentTaskName,
      name: parentTaskName,
      data: parentTaskData,
      opts: {
        ...parentTaskOptions,
        removeOnComplete: true,
        removeOnFail: true,
        attempts: 10,
        backoff: {
          type: "fixed",
          delay: 3000,
        },
      },
      children: childTasks,
    });
    await flowProducer.close();
  }
  async removeAllTasks() {
    const queueNames = ["updateUserTask"];
    for (const taskName of queueNames) {
      const queue = this.getQueue(taskName);
      try {
        await queue.clean(0, Date.now(), {
          jobTypes: ["completed", "failed", "waiting", "active"],
        });
        console.log(`Removed all tasks from ${taskName}`);
      } catch (error) {
        console.error(`Failed to clean tasks from ${taskName}:`, error);
      }
    }
  }
}

export default TasksService;
