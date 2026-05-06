import secrets
import string
from django.core.mail import send_mail
from django.conf import settings


def generate_secure_password(length=8):
    """
    Generate a secure random password
    """
    chars = string.ascii_letters + string.digits + "!@#$%^&*"
    return ''.join(secrets.choice(chars) for _ in range(length))


def send_user_credentials_email(username, password, email):
    """
    Send user credentials via email
    """

    subject = "Your Theta Docs Account Access"

    message = f"""
Hello {username},

Your account has been successfully created.

Here are your login details:

Username: {username}
Password: {password}

⚠️ Please login and change your password immediately for security.

Login here:
{settings.SITE_URL}

Regards,  
Theta Docs Team
"""

    try:
        send_mail(
            subject,
            message,
            settings.DEFAULT_FROM_EMAIL,
            [email],
            fail_silently=False,  # change to True in production if needed
        )
        print(f"Email sent successfully to {email}")

    except Exception as e:
        print("❌ Email sending failed:", str(e))
