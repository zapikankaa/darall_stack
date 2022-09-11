/*
  Warnings:

  - Made the column `price_rub` on table `Position` required. This step will fail if there are existing NULL values in that column.

*/
-- AlterTable
ALTER TABLE "Position" ALTER COLUMN "price_rub" SET NOT NULL;
