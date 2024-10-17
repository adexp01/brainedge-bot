-- CreateEnum
CREATE TYPE "LanguageEnum" AS ENUM ('EN', 'FR', 'ES');

-- CreateEnum
CREATE TYPE "SubjectEnum" AS ENUM ('BLOCKCHAIN', 'FINANCE', 'LIFE_SKILLS', 'MACHINE_LEARNING');

-- CreateEnum
CREATE TYPE "TransactionMethodEnum" AS ENUM ('DAILY_REWARD', 'CLICKER_REWARD', 'QUIZ_REWARD', 'DAILY_QUIZ_REWARD');

-- CreateEnum
CREATE TYPE "LeaderboardLevel" AS ENUM ('Learner', 'Apprentice', 'Analyst', 'Scholar', 'Mentor', 'Advisor', 'Professor', 'Innovator', 'Chancellor', 'Visionary', 'Mastermind');

-- CreateTable
CREATE TABLE "Subject" (
    "id" TEXT NOT NULL,
    "subject" "SubjectEnum" NOT NULL,
    "language" "LanguageEnum" NOT NULL,
    "title" TEXT NOT NULL,
    "subTitle" TEXT NOT NULL,
    "description" TEXT NOT NULL,
    "thumbnailUrl" TEXT NOT NULL,
    "conceptMapUrl" TEXT NOT NULL,

    CONSTRAINT "Subject_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Track" (
    "id" TEXT NOT NULL,
    "subject" "SubjectEnum" NOT NULL,
    "language" "LanguageEnum" NOT NULL,
    "title" TEXT NOT NULL,
    "subTitle" TEXT NOT NULL,
    "description" TEXT NOT NULL,
    "thumbnailUrl" TEXT NOT NULL,
    "courseOrderById" TEXT[],
    "subjectId" TEXT,

    CONSTRAINT "Track_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Course" (
    "id" TEXT NOT NULL,
    "language" "LanguageEnum" NOT NULL,
    "title" TEXT NOT NULL,
    "subTitle" TEXT NOT NULL,
    "description" TEXT NOT NULL,
    "thumbnailUrl" TEXT NOT NULL,
    "scormUrl" TEXT NOT NULL,
    "lessonReward" INTEGER NOT NULL,
    "trackId" TEXT,

    CONSTRAINT "Course_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "BrainPointBalance" (
    "id" TEXT NOT NULL,
    "userId" TEXT NOT NULL,
    "balance" INTEGER NOT NULL DEFAULT 0,
    "dailyRewardClaimedAt" TIMESTAMP(3),
    "dailyRewardStreak" INTEGER NOT NULL DEFAULT 0,
    "maxDailyRewardStreak" INTEGER NOT NULL DEFAULT 0,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "BrainPointBalance_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "BrainPointTransaction" (
    "id" TEXT NOT NULL,
    "userId" TEXT NOT NULL,
    "amount" INTEGER NOT NULL,
    "method" "TransactionMethodEnum" NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "BrainPointTransaction_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "DailyQuiz" (
    "id" TEXT NOT NULL,
    "question" TEXT NOT NULL,
    "answers" TEXT[],
    "correct" INTEGER NOT NULL,
    "reward" INTEGER NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "DailyQuiz_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "AppUser" (
    "id" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "privyId" TEXT NOT NULL,
    "walletSigner" TEXT NOT NULL,
    "walletAbstract" TEXT,
    "admin" BOOLEAN NOT NULL DEFAULT false,
    "email" TEXT,
    "google" TEXT,
    "twitter" TEXT,
    "discord" TEXT,
    "walletExternal" TEXT,
    "username" TEXT,
    "profileImageUrl" TEXT,
    "bio" TEXT,
    "pendingLearn" INTEGER NOT NULL DEFAULT 0,
    "leaderboardScore" INTEGER NOT NULL DEFAULT 0,
    "leaderboardRank" INTEGER NOT NULL DEFAULT 0,
    "referralCode" TEXT NOT NULL,
    "referredByUserId" TEXT,
    "referralCount" INTEGER NOT NULL DEFAULT 0,
    "banned" BOOLEAN NOT NULL DEFAULT false,
    "bannedReason" TEXT,

    CONSTRAINT "AppUser_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "CourseCompletion" (
    "id" TEXT NOT NULL,
    "userId" TEXT NOT NULL,
    "courseId" TEXT NOT NULL,
    "progress" DOUBLE PRECISION NOT NULL,
    "completed" BOOLEAN NOT NULL DEFAULT false,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "CourseCompletion_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "LessonCompletion" (
    "id" TEXT NOT NULL,
    "userId" TEXT NOT NULL,
    "courseCompletionId" TEXT,
    "lessonId" TEXT NOT NULL,
    "progress" DOUBLE PRECISION NOT NULL,
    "completed" BOOLEAN NOT NULL DEFAULT false,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "LessonCompletion_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "WhiteList" (
    "id" TEXT NOT NULL,
    "telegramId" TEXT NOT NULL,
    "twitterConfirmAt" TIMESTAMP(3),
    "telegramConfirmAt" TIMESTAMP(3),
    "completed" BOOLEAN NOT NULL DEFAULT false,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "WhiteList_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "ClickerUser" (
    "id" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "username" TEXT,
    "photo_url" TEXT,
    "isPremium" BOOLEAN NOT NULL DEFAULT false,
    "balance" INTEGER NOT NULL DEFAULT 0,
    "weeklyBalance" INTEGER NOT NULL DEFAULT 0,
    "hat" INTEGER NOT NULL DEFAULT 0,
    "weeklyHat" INTEGER NOT NULL DEFAULT 0,
    "tapingGuru" INTEGER NOT NULL DEFAULT 4,
    "tapingGuruTimeOut" TIMESTAMP(3),
    "fullTank" INTEGER NOT NULL DEFAULT 4,
    "fullTankTimeOut" TIMESTAMP(3),
    "multiTapLevel" INTEGER NOT NULL DEFAULT 1,
    "EnergyLimitLevel" INTEGER NOT NULL DEFAULT 1,
    "RechargingSpeedLevel" INTEGER NOT NULL DEFAULT 1,
    "LeaderboardLevel" "LeaderboardLevel" NOT NULL DEFAULT 'Learner',
    "dailyRewardStreak" INTEGER NOT NULL DEFAULT 0,
    "dailyRewardClaimedAt" TIMESTAMP(3),
    "referralCode" TEXT NOT NULL,
    "referredByUserId" TEXT,
    "currentEnergy" INTEGER NOT NULL DEFAULT 1000,
    "maxEnergy" INTEGER NOT NULL DEFAULT 1000,
    "energyUpdatedAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "friends3RewardClaimed" BOOLEAN NOT NULL DEFAULT false,
    "friends7RewardClaimed" BOOLEAN NOT NULL DEFAULT false,
    "friends15RewardClaimed" BOOLEAN NOT NULL DEFAULT false,
    "friends50RewardClaimed" BOOLEAN NOT NULL DEFAULT false,
    "friends100RewardClaimed" BOOLEAN NOT NULL DEFAULT false,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "ClickerUser_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "AdminUser" (
    "id" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "email" TEXT NOT NULL,
    "password" TEXT NOT NULL,

    CONSTRAINT "AdminUser_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "AirdropItems" (
    "id" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "name" TEXT NOT NULL,
    "description" TEXT NOT NULL,

    CONSTRAINT "AirdropItems_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Task" (
    "id" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "link" TEXT NOT NULL,
    "description" TEXT NOT NULL,
    "reward" INTEGER NOT NULL,
    "icon" TEXT NOT NULL,

    CONSTRAINT "Task_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "ClickerUserTaskCompletion" (
    "clickerUserId" TEXT NOT NULL,
    "taskId" TEXT NOT NULL,
    "completedAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "ClickerUserTaskCompletion_pkey" PRIMARY KEY ("clickerUserId","taskId")
);

-- CreateTable
CREATE TABLE "DailyReward" (
    "id" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "bp" INTEGER,
    "hat" INTEGER,
    "order" INTEGER NOT NULL,

    CONSTRAINT "DailyReward_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "BrainPointBalance_userId_key" ON "BrainPointBalance"("userId");

-- CreateIndex
CREATE UNIQUE INDEX "AppUser_privyId_key" ON "AppUser"("privyId");

-- CreateIndex
CREATE UNIQUE INDEX "AppUser_walletSigner_key" ON "AppUser"("walletSigner");

-- CreateIndex
CREATE UNIQUE INDEX "AppUser_walletAbstract_key" ON "AppUser"("walletAbstract");

-- CreateIndex
CREATE UNIQUE INDEX "AppUser_email_key" ON "AppUser"("email");

-- CreateIndex
CREATE UNIQUE INDEX "AppUser_google_key" ON "AppUser"("google");

-- CreateIndex
CREATE UNIQUE INDEX "AppUser_twitter_key" ON "AppUser"("twitter");

-- CreateIndex
CREATE UNIQUE INDEX "AppUser_discord_key" ON "AppUser"("discord");

-- CreateIndex
CREATE UNIQUE INDEX "AppUser_walletExternal_key" ON "AppUser"("walletExternal");

-- CreateIndex
CREATE UNIQUE INDEX "AppUser_username_key" ON "AppUser"("username");

-- CreateIndex
CREATE UNIQUE INDEX "AppUser_referralCode_key" ON "AppUser"("referralCode");

-- CreateIndex
CREATE UNIQUE INDEX "WhiteList_telegramId_key" ON "WhiteList"("telegramId");

-- CreateIndex
CREATE UNIQUE INDEX "ClickerUser_referralCode_key" ON "ClickerUser"("referralCode");

-- CreateIndex
CREATE UNIQUE INDEX "AdminUser_email_key" ON "AdminUser"("email");

-- CreateIndex
CREATE UNIQUE INDEX "DailyReward_order_key" ON "DailyReward"("order");

-- AddForeignKey
ALTER TABLE "Track" ADD CONSTRAINT "Track_subjectId_fkey" FOREIGN KEY ("subjectId") REFERENCES "Subject"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Course" ADD CONSTRAINT "Course_trackId_fkey" FOREIGN KEY ("trackId") REFERENCES "Track"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "BrainPointBalance" ADD CONSTRAINT "BrainPointBalance_userId_fkey" FOREIGN KEY ("userId") REFERENCES "AppUser"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "BrainPointTransaction" ADD CONSTRAINT "BrainPointTransaction_userId_fkey" FOREIGN KEY ("userId") REFERENCES "AppUser"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "CourseCompletion" ADD CONSTRAINT "CourseCompletion_userId_fkey" FOREIGN KEY ("userId") REFERENCES "AppUser"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "LessonCompletion" ADD CONSTRAINT "LessonCompletion_userId_fkey" FOREIGN KEY ("userId") REFERENCES "AppUser"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "LessonCompletion" ADD CONSTRAINT "LessonCompletion_courseCompletionId_fkey" FOREIGN KEY ("courseCompletionId") REFERENCES "CourseCompletion"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "ClickerUserTaskCompletion" ADD CONSTRAINT "ClickerUserTaskCompletion_clickerUserId_fkey" FOREIGN KEY ("clickerUserId") REFERENCES "ClickerUser"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "ClickerUserTaskCompletion" ADD CONSTRAINT "ClickerUserTaskCompletion_taskId_fkey" FOREIGN KEY ("taskId") REFERENCES "Task"("id") ON DELETE RESTRICT ON UPDATE CASCADE;
