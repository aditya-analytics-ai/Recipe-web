# 🍳 RecipeCraft — Full Stack Recipe Management System

A complete web application built with **Flask + MySQL** for managing and sharing recipes.

---

## 📁 Project Structure

```
recipe_app/
├── app.py                  # Flask application entry point
├── config.py               # Configuration (DB, secret key, uploads)
├── extensions.py           # Flask extensions (SQLAlchemy, LoginManager)
├── utils.py                # Helper functions (image upload/delete)
├── create_admin.py         # One-time setup: create tables + admin user
├── schema.sql              # Raw SQL schema (reference / manual setup)
├── requirements.txt        # Python dependencies
│
├── models/
│   ├── __init__.py
│   ├── user.py             # User model (auth, password hashing)
│   └── recipe.py           # Recipe model (CRUD data)
│
├── routes/
│   ├── __init__.py
│   ├── auth.py             # Login, register, logout
│   ├── recipes.py          # Browse, add, edit, delete recipes
│   └── admin.py            # Admin dashboard, user/recipe management
│
├── templates/
│   ├── base.html           # Shared navbar layout
│   ├── login.html          # Login page
│   ├── register.html       # Registration page
│   ├── recipes.html        # Browse + search recipes
│   ├── recipe_detail.html  # Single recipe view
│   ├── add_recipe.html     # Add new recipe form
│   ├── edit_recipe.html    # Edit recipe form
│   ├── my_recipes.html     # User's own recipes
│   └── admin/
│       ├── base_admin.html # Admin layout with sidebar
│       ├── dashboard.html  # Stats and overview
│       ├── users.html      # User management
│       └── recipes.html    # All recipes management
│
└── static/
    ├── css/style.css       # Main stylesheet
    ├── js/main.js          # Flash messages, file preview, confirm dialogs
    └── uploads/            # Uploaded recipe images (auto-created)
```

---

## ⚙️ Setup Instructions

### 1. Prerequisites
- Python 3.8+
- MySQL 5.7+ or 8.0+

### 2. Install Python Dependencies

```bash
cd recipe_app
pip install -r requirements.txt
```

### 3. Set Up MySQL Database

Open MySQL shell and run:
```sql
CREATE DATABASE recipe_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
```

### 4. Configure Database Connection

Edit **`config.py`** with your MySQL credentials:
```python
MYSQL_USER     = 'root'           # your MySQL username
MYSQL_PASSWORD = 'yourpassword'   # your MySQL password
MYSQL_HOST     = 'localhost'
MYSQL_DB       = 'recipe_db'
```

Or set environment variables:
```bash
export MYSQL_USER=root
export MYSQL_PASSWORD=yourpassword
export SECRET_KEY=change-this-to-something-random
```

### 5. Create Tables & Admin User

```bash
python create_admin.py
```

This creates all database tables and an admin account:
- **Email:** admin@recipecraft.com
- **Password:** admin123

### 6. Run the Application

```bash
python app.py
```

Open your browser at: **http://127.0.0.1:5000**

---

## 🔗 How Flask Connects to MySQL

Flask uses **SQLAlchemy** as the ORM (Object Relational Mapper) with the **PyMySQL** driver:

```python
# config.py
SQLALCHEMY_DATABASE_URI = "mysql+pymysql://user:password@localhost/recipe_db"
```

The connection string format:
```
mysql+pymysql://  ← driver (pymysql)
username:password ← credentials
@localhost        ← host
/recipe_db        ← database name
```

SQLAlchemy translates Python class definitions (models) into SQL tables automatically. No raw SQL needed for CRUD!

---

## 🌐 URL Routes

| Route | Method | Description |
|-------|--------|-------------|
| `/` | GET | Redirect to recipes |
| `/register` | GET/POST | User registration |
| `/login` | GET/POST | User login |
| `/logout` | GET | Logout |
| `/recipes` | GET | Browse + search recipes |
| `/recipes/<id>` | GET | View recipe detail |
| `/recipes/add` | GET/POST | Add new recipe |
| `/recipes/<id>/edit` | GET/POST | Edit recipe |
| `/recipes/<id>/delete` | POST | Delete recipe |
| `/my-recipes` | GET | User's own recipes |
| `/admin/dashboard` | GET | Admin overview |
| `/admin/users` | GET | Manage users |
| `/admin/recipes` | GET | Manage all recipes |

---

## 🔐 Security Features

- **Password Hashing** — Werkzeug PBKDF2-SHA256 (no plain-text passwords ever stored)
- **Session Management** — Flask-Login with secure signed cookies
- **File Upload Validation** — Only image extensions allowed, UUID filenames
- **Admin Protection** — `@admin_required` decorator on all admin routes
- **CSRF** — Forms use POST methods; delete actions require form submission
- **Ownership Check** — Users can only edit/delete their own recipes

---

## 📋 Database Schema

```sql
-- Users
CREATE TABLE users (
    id            INT AUTO_INCREMENT PRIMARY KEY,
    username      VARCHAR(80)  NOT NULL UNIQUE,
    email         VARCHAR(120) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    is_admin      BOOLEAN DEFAULT FALSE,
    created_at    DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- Recipes
CREATE TABLE recipes (
    id             INT AUTO_INCREMENT PRIMARY KEY,
    title          VARCHAR(200) NOT NULL,
    description    TEXT,
    ingredients    TEXT NOT NULL,
    steps          TEXT NOT NULL,
    category       VARCHAR(50)  NOT NULL,
    image_filename VARCHAR(255),
    prep_time      INT,
    cook_time      INT,
    servings       INT,
    created_at     DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at     DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    user_id        INT NOT NULL,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);
```

---

## 🎨 Tech Stack

| Layer | Technology |
|-------|-----------|
| Backend | Python 3 + Flask 3.0 |
| Database ORM | Flask-SQLAlchemy |
| DB Driver | PyMySQL |
| Auth | Flask-Login |
| Password | Werkzeug (PBKDF2) |
| Frontend | HTML5 + CSS3 + Vanilla JS |
| Fonts | Google Fonts (Playfair Display + Lato) |

