/*
  Warnings:

  - You are about to drop the `CategoryVal` table. If the table is not empty, all the data it contains will be lost.
  - You are about to drop the `_CategoryValToPosition` table. If the table is not empty, all the data it contains will be lost.

*/
-- DropForeignKey
ALTER TABLE "CategoryVal" DROP CONSTRAINT "CategoryVal_categoryId_fkey";

-- DropForeignKey
ALTER TABLE "_CategoryValToPosition" DROP CONSTRAINT "_CategoryValToPosition_A_fkey";

-- DropForeignKey
ALTER TABLE "_CategoryValToPosition" DROP CONSTRAINT "_CategoryValToPosition_B_fkey";

-- DropTable
DROP TABLE "CategoryVal";

-- DropTable
DROP TABLE "_CategoryValToPosition";

-- CreateTable
CREATE TABLE "Tag" (
    "id" SERIAL NOT NULL,
    "categoryId" INTEGER NOT NULL,
    "value" TEXT NOT NULL,
    "description" TEXT,

    CONSTRAINT "Tag_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "_PositionToTag" (
    "A" INTEGER NOT NULL,
    "B" INTEGER NOT NULL
);

-- CreateIndex
CREATE UNIQUE INDEX "_PositionToTag_AB_unique" ON "_PositionToTag"("A", "B");

-- CreateIndex
CREATE INDEX "_PositionToTag_B_index" ON "_PositionToTag"("B");

-- AddForeignKey
ALTER TABLE "Tag" ADD CONSTRAINT "Tag_categoryId_fkey" FOREIGN KEY ("categoryId") REFERENCES "Category"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "_PositionToTag" ADD FOREIGN KEY ("A") REFERENCES "Position"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "_PositionToTag" ADD FOREIGN KEY ("B") REFERENCES "Tag"("id") ON DELETE CASCADE ON UPDATE CASCADE;
