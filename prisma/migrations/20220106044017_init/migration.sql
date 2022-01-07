-- CreateTable
CREATE TABLE `User` (
    `user_id` VARCHAR(191) NOT NULL,
    `username` VARCHAR(255) NOT NULL,
    `password` VARCHAR(191) NOT NULL,
    `first_name` VARCHAR(191) NOT NULL,
    `last_name` VARCHAR(191) NOT NULL,
    `email` VARCHAR(191) NOT NULL,
    `pfp` VARCHAR(191) NULL,
    `createdAt` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),

    UNIQUE INDEX `User_username_key`(`username`),
    UNIQUE INDEX `User_email_key`(`email`),
    PRIMARY KEY (`user_id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `Order` (
    `order_id` VARCHAR(191) NOT NULL,
    `order_name` VARCHAR(191) NOT NULL,
    `cost` DECIMAL(65, 30) NOT NULL DEFAULT 0.00,
    `tax` DECIMAL(65, 30) NOT NULL DEFAULT 0.00,
    `shipping` DECIMAL(65, 30) NOT NULL DEFAULT 0.00,
    `savings` DECIMAL(65, 30) NOT NULL DEFAULT 0.00,
    `total` DECIMAL(65, 30) NOT NULL DEFAULT 0.00,
    `vendor` VARCHAR(191) NULL,
    `items` INTEGER NOT NULL DEFAULT 0,
    `date_of_purchase` DATETIME(3) NOT NULL,
    `arrival_date` DATETIME(3) NOT NULL,
    `arrived` BOOLEAN NOT NULL DEFAULT false,
    `delayed` BOOLEAN NOT NULL DEFAULT false,
    `user_id` VARCHAR(191) NOT NULL,
    `createdAt` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),

    PRIMARY KEY (`order_id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `Item` (
    `item_id` VARCHAR(191) NOT NULL,
    `item_name` VARCHAR(191) NOT NULL,
    `item_price` DECIMAL(65, 30) NOT NULL,
    `category` VARCHAR(191) NOT NULL,
    `order_id` VARCHAR(191) NOT NULL,
    `createdAt` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),

    PRIMARY KEY (`item_id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
