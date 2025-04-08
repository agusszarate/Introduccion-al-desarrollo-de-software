from flask import Flask, render_template, request, redirect, url_for, send_from_directory

app = Flask(__name__, static_folder='../static', static_url_path='/static', template_folder='../templates')

@app.route('/')
def index():
    return render_template('index.html')

@app.route('/contact')
def contact():
    return render_template('contact.html')

@app.route('/menu')
def menu():
    return render_template('menu.html')

if __name__ == '__main__':
    app.run(debug=True)