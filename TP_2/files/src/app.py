from flask import Flask, render_template, request, jsonify
from flask_mail import Mail, Message
from menu import short_menu, info_menu
import os
from dotenv import load_dotenv

# Load environment variables from .env file
load_dotenv()

app = Flask(__name__, static_folder='../static', static_url_path='/static', template_folder='../templates')

# Email configuration using environment variables
app.config['MAIL_SERVER'] = 'smtp.gmail.com'
app.config['MAIL_PORT'] = 587
app.config['MAIL_USE_TLS'] = True
app.config['MAIL_USE_SSL'] = False
app.config['MAIL_USERNAME'] = os.environ.get('EMAIL_USER')
app.config['MAIL_PASSWORD'] = os.environ.get('EMAIL_PASSWORD') 
app.config['MAIL_DEFAULT_SENDER'] = os.environ.get('EMAIL_USER')
mail = Mail(app)

company_name = 'Ghirardelli'

@app.route('/')
def index():
    return render_template('index.html', company_name=company_name, info_menu=short_menu)

@app.route('/contact')
def contact():
    return render_template('contact.html')

@app.route('/menu')
def menu():
    return render_template('menu.html', info_menu=info_menu)

@app.route('/sendEmail', methods=['POST'])
def send_email():
    try:
        name = request.form.get('name')
        email = request.form.get('email')
        message_text = request.form.get('message')
        
        subject = f"Contact Form Submission from {name}"
        text = f"""
        You have received a new message from the contact form:
        
        Name: {name}
        Email: {email}
        
        Message:
        {message_text}
        """
    
        to_email = os.environ.get('EMAIL_TO_SEND')
        
        msg = Message(
            subject=subject,
            recipients=[to_email],
            body=text,
            reply_to=email 
        )
        
        mail.send(msg)
        
        return jsonify({"success": True, "message": "Email sent successfully!"}), 200
    except Exception as e:
        print(f"Error sending email: {str(e)}")
        return jsonify({"success": False, "message": f"Error sending email: {str(e)}"}), 500

if __name__ == '__main__':
    app.run(debug=True)