-- ===================================================
-- RecipeCraft Database Schema
-- Run this BEFORE starting the Flask application
-- ===================================================

-- 1. Create the database
CREATE DATABASE IF NOT EXISTS recipe_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE recipe_db;

-- 2. Users table
CREATE TABLE IF NOT EXISTS users (
    id          INT AUTO_INCREMENT PRIMARY KEY,
    username    VARCHAR(80)  NOT NULL UNIQUE,
    email       VARCHAR(120) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    is_admin    BOOLEAN      DEFAULT FALSE,
    created_at  DATETIME     DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 3. Recipes table
CREATE TABLE IF NOT EXISTS recipes (
    id              INT AUTO_INCREMENT PRIMARY KEY,
    title           VARCHAR(200) NOT NULL,
    description     TEXT,
    ingredients     TEXT         NOT NULL,
    steps           TEXT         NOT NULL,
    category        VARCHAR(50)  NOT NULL,
    image_filename  VARCHAR(255),
    prep_time       INT,
    cook_time       INT,
    servings        INT,
    created_at      DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at      DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    user_id         INT NOT NULL,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 4. Indexes for performance
CREATE INDEX idx_recipes_category ON recipes(category);
CREATE INDEX idx_recipes_user_id  ON recipes(user_id);
CREATE INDEX idx_recipes_title    ON recipes(title);
CREATE INDEX idx_users_email      ON users(email);

-- 5. Optional: seed admin user (password = 'admin123')
-- The hash below is for 'admin123' using werkzeug pbkdf2:sha256
-- You can also create via Flask: python create_admin.py
INSERT INTO users (username, email, password_hash, is_admin) VALUES
('admin', 'admin@recipecraft.com',
 'pbkdf2:sha256:600000$example$changethis',   -- ← use create_admin.py instead
 TRUE)
ON DUPLICATE KEY UPDATE id=id;

-- ===================================================
-- Useful queries for reference:
-- ===================================================
-- View all recipes with author names:
-- SELECT r.id, r.title, r.category, u.username, r.created_at
-- FROM recipes r JOIN users u ON r.user_id = u.id ORDER BY r.created_at DESC;

-- Count recipes per user:
-- SELECT u.username, COUNT(r.id) as recipe_count
-- FROM users u LEFT JOIN recipes r ON u.id = r.user_id GROUP BY u.id;

-- Search recipes by title:
-- SELECT * FROM recipes WHERE title LIKE '%pasta%';
