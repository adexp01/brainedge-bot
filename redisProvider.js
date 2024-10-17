import Redis from "ioredis";

let redisInstance = null;

function getRedisConnection() {
  if (!redisInstance) {
    redisInstance = new Redis(process.env.REDISCLOUD_URL, {
      maxRetriesPerRequest: null
    });
  }
  return redisInstance;
}

export { getRedisConnection };
