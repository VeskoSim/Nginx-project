#!/usr/bin/python

from flask import Flask, render_template
import os

app = Flask(__name__)

# Променлива на околната среда
env = os.getenv('ENV', 'Development')

@app.route("/")
def home():
    # Променяме съобщението за тестване
    return render_template('index-2.html')

@app.route("/hello")
def hello():
    # Променяме съобщението за тестване
    return f"Hello from {env}! This is the updated version."

@app.route("/picture")
def pic():
    # Зарежда шаблона index.html
    return render_template('index.html')

@app.route("/user/<username>")
def show_user_profile(username):
    return f"Hello, {username}!"

if __name__ == "__main__":
    app.run(host='0.0.0.0')
