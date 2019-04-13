# User Setting
echo -e "*** password here ***!\n*** password here ***" | adduser admin
usermod -aG sudo admin
groups admin

# Firewall Setting
sudo ufw app list
sudo ufw allow OpenSSH
sudo ufw allow 5432
sudo ufw enable

# Download PostgreSQL & setting
sudo apt-get update
sudo apt-get install postgresql postgresql-contrib

# DB SETTING
su -c "psql -c \"CREATE DATABASE customer_info;\"" postgres
su -c "psql -c \"CREATE USER admin WITH PASSWORD '*** password here ***';\"" postgres
su -c "psql -c \"ALTER ROLE customer_info SET client_encoding TO 'utf8';\"" postgres
su -c "psql -c \"ALTER ROLE customer_info SET default_transaction_isolation TO 'read committed';\"" postgres
su -c "psql -c \"ALTER ROLE customer_info SET timezone TO 'UTC';\"" postgres
su -c "psql -c \"GRANT ALL PRIVILEGES ON DATABASE customer_info TO admin;\"" postgres
su -c "psql -c \"\du\"" postgres

### PostgreSQL localhost setting
cd /etc/postgresql/9.5/main
vim +":%s/#listen_addresses = 'localhost'/listen_addresses = '*'/g | wq" postgresql.conf

cd /etc/postgresql/9.5/main
vim +"%s/127.0.0.1\/32/0.0.0.0\/0   /g | %s/::1\/128/::\/0/g | wq" pg_hba.conf

sudo systemctl start postgresql.service
sudo systemctl enable postgresql.service
sudo systemctl status postgresql.service
sudo systemctl restart postgresql.service
