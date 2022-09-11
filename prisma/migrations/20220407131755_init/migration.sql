-- CreateTable
CREATE TABLE "Position" (
    "id" SERIAL NOT NULL,
    "name" TEXT NOT NULL,
    "description" TEXT,
    "weight_g" INTEGER,
    "volume_ml" INTEGER,
    "ingredients" TEXT NOT NULL,

    CONSTRAINT "Position_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Category" (
    "id" SERIAL NOT NULL,
    "name" TEXT NOT NULL,
    "description" TEXT,

    CONSTRAINT "Category_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "CategoryVal" (
    "id" SERIAL NOT NULL,
    "categoryId" INTEGER NOT NULL,
    "value" TEXT NOT NULL,
    "description" TEXT,

    CONSTRAINT "CategoryVal_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "_CategoryValToPosition" (
    "A" INTEGER NOT NULL,
    "B" INTEGER NOT NULL
);

-- CreateIndex
CREATE UNIQUE INDEX "_CategoryValToPosition_AB_unique" ON "_CategoryValToPosition"("A", "B");

-- CreateIndex
CREATE INDEX "_CategoryValToPosition_B_index" ON "_CategoryValToPosition"("B");

-- AddForeignKey
ALTER TABLE "CategoryVal" ADD CONSTRAINT "CategoryVal_categoryId_fkey" FOREIGN KEY ("categoryId") REFERENCES "Category"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "_CategoryValToPosition" ADD FOREIGN KEY ("A") REFERENCES "CategoryVal"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "_CategoryValToPosition" ADD FOREIGN KEY ("B") REFERENCES "Position"("id") ON DELETE CASCADE ON UPDATE CASCADE;
