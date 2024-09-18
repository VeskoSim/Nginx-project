#!/usr/bin/python

from flask import Flask, render_template
import os

app = Flask(__name__)

# Environment variable
env = os.getenv('ENV', 'Development')

@app.route('/health', methods=['GET'])
def health_check():
    return {'status': 'healthy'}, 200

@app.route("/")
def home():
    # Changing the message for testing
    return render_template('index-2.html')

@app.route("/hello")
def hello():
    # Changing the message for testing
    return f"Hello from {env}! This is the updated version."

@app.route("/picture")
def pic():
    # Loads the template index.html
    return render_template('index.html')

@app.route("/user/<username>")
def show_user_profile(username):
    return f"Hello, {username}!"

if __name__ == "__main__":
    app.run(host='0.0.0.0')
