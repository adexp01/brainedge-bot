-- CreateTable
CREATE TABLE "CompletedQuiz" (
    "id" TEXT NOT NULL,
    "lessonId" TEXT NOT NULL,
    "results" TEXT[],
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "CompletedQuiz_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "_CompletedQuiz" (
    "A" TEXT NOT NULL,
    "B" TEXT NOT NULL
);

-- CreateIndex
CREATE UNIQUE INDEX "_CompletedQuiz_AB_unique" ON "_CompletedQuiz"("A", "B");

-- CreateIndex
CREATE INDEX "_CompletedQuiz_B_index" ON "_CompletedQuiz"("B");

-- AddForeignKey
ALTER TABLE "_CompletedQuiz" ADD CONSTRAINT "_CompletedQuiz_A_fkey" FOREIGN KEY ("A") REFERENCES "CompletedQuiz"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "_CompletedQuiz" ADD CONSTRAINT "_CompletedQuiz_B_fkey" FOREIGN KEY ("B") REFERENCES "LessonCompletion"("id") ON DELETE CASCADE ON UPDATE CASCADE;
