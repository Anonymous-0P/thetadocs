#!/bin/bash

echo "🚀 Starting Theta Docs Setup..."

# =========================

# UPDATE SYSTEM

# =========================

apt update -y

# =========================

# INSTALL REQUIRED PACKAGES

# =========================

apt install python3 python3-venv python3-pip nginx git -y

# =========================

# GO TO PROJECT DIRECTORY

# =========================

cd /var/www/Theta_Docs || exit

# =========================

# CREATE VIRTUAL ENV

# =========================

echo "📦 Creating virtual environment..."
python3 -m venv venv

# =========================

# ACTIVATE VENV

# =========================

source venv/bin/activate

# =========================

# INSTALL DEPENDENCIES

# =========================

echo "📦 Installing dependencies..."
pip install --upgrade pip
pip install -r requirements.txt
pip install gunicorn psycopg2-binary python-dotenv

# =========================

# RUN MIGRATIONS

# =========================

echo "🗄 Running migrations..."
python manage.py migrate

# =========================

# COLLECT STATIC FILES

# =========================

echo "🎨 Collecting static files..."
python manage.py collectstatic --noinput

# =========================

# CREATE SYSTEMD SERVICE

# =========================

echo "⚙️ Creating Gunicorn service..."

cat <<EOF > /etc/systemd/system/thetadocs.service
[Unit]
Description=Theta Docs Django App
After=network.target

[Service]
User=root
Group=www-data
WorkingDirectory=/var/www/Theta_Docs
ExecStart=/var/www/Theta_Docs/venv/bin/gunicorn core.wsgi:application --bind 0.0.0.0:8001

Restart=always

[Install]
WantedBy=multi-user.target
EOF

# =========================

# ENABLE & START SERVICE

# =========================

systemctl daemon-reload
systemctl start thetadocs
systemctl enable thetadocs

# =========================

# OPEN FIREWALL PORT

# =========================

ufw allow 8001
ufw reload

echo "✅ Setup Completed!"
echo "🌍 Access your app at: http://YOUR_SERVER_IP:8001"
