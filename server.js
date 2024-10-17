import dotenv from "dotenv";
import express from "express";
import cron from "node-cron";
import fetch from "node-fetch";
import { Telegraf } from "telegraf";
import refreshUserClickerData from "./refreshUsers.js";
import "./worker.js";
dotenv.config();

const app = express();
const url = process.env.LOGIN_URL;
const PORT = process.env.PORT || 3001;

app.listen(PORT, () => {
  console.log(`Server is running on port ${PORT}`);
  console.log("Starting user clicker data refresh...");
  const bot = new Telegraf(process.env.TELEGRAM_BOT_TOKEN);
  console.log(process.env.TELEGRAM_BOT_TOKEN, "token");
  bot
    .launch()
    .then(() => {
      console.log("Bot started");
    })
    .catch(err => {
      console.error("Failed to start bot :(", err);
    });

  bot.start(async ctx => {
    const userId = ctx.from.id.toString();
    const isPremium = ctx?.from?.is_premium ?? false;
    const referralCode = ctx.startPayload;
    const body = {
      id: userId,
      referralCode: referralCode,
      balance: 0,
      referredByUserId: undefined,
      isPremium: isPremium,
      name: `${ctx.from.first_name} ${ctx.from.last_name ?? ""}`,
      username: ctx.from.username
    };

    try {
      await fetch(url, {
        method: "POST",
        headers: {
          "Content-Type": "application/json"
        },
        body: JSON.stringify(body)
      });
    } catch (error) {
      console.error("Error during login/signup:", error);
    }
  });
});

cron.schedule("0 0 * * *", async () => {
  console.log("Starting user clicker data refresh...");
  await refreshUserClickerData();
  console.log("User clicker data refresh completed.");
});
