from flask import Flask
from config import Config
from extensions import db, login_manager
from routes.auth import auth_bp
from routes.recipes import recipes_bp
from routes.admin import admin_bp
import os

def create_app():
    app = Flask(__name__)
    app.config.from_object(Config)

    db.init_app(app)
    login_manager.init_app(app)
    login_manager.login_view = 'auth.login'
    login_manager.login_message = 'Please log in to access this page.'
    login_manager.login_message_category = 'warning'

    app.register_blueprint(auth_bp)
    app.register_blueprint(recipes_bp)
    app.register_blueprint(admin_bp, url_prefix='/admin')

    os.makedirs(app.config['UPLOAD_FOLDER'], exist_ok=True)

    return app

app = create_app()

if __name__ == '__main__':
    app.run(debug=True)
