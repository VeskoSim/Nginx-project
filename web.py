#!/usr/bin/python

from flask import Flask, render_template
import os

app = Flask(__name__)

# Променлива на околната среда
env = os.getenv('ENV', 'Development')

@app.route("/")
def home():
    # Променяме съобщението за тестване
    return f"Hello from {env}! This is the updated version."

@app.route("/picture")
def pic():
    # Зарежда шаблона index.html
    return render_template('index.html')

if __name__ == "__main__":
    app.run(host='0.0.0.0')
