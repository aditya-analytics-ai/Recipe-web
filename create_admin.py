"""
Run this script ONCE after setting up the database to:
1. Create all database tables
2. Create an admin user

Usage: python create_admin.py
"""
from app import app
from extensions import db
from models.user import User
from models.recipe import Recipe

with app.app_context():
    # Create all tables
    db.create_all()
    print("✅ Database tables created.")

    # Check if admin already exists
    admin = User.query.filter_by(email='admin@recipecraft.com').first()
    if not admin:
        admin = User(
            username='admin',
            email='admin@recipecraft.com',
            is_admin=True
        )
        admin.set_password('admin123')
        db.session.add(admin)
        db.session.commit()
        print("✅ Admin user created: admin@recipecraft.com / admin123")
    else:
        print("ℹ️  Admin user already exists.")

    print("\n🚀 Setup complete! Run: python app.py")
