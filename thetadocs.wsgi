import sys
import os

# FORCE VENV PYTHON
activate_this = '/var/www/Theta_Docs/venv/bin/activate_this.py'
with open(activate_this) as file_:
    exec(file_.read(), dict(__file__=activate_this))

# ADD PROJECT PATH
sys.path.append('/var/www/Theta_Docs')

# DJANGO SETTINGS
os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'core.settings')

from django.core.wsgi import get_wsgi_application
application = get_wsgi_application()
