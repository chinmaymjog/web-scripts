#!/bin/bash
## Provisioner log file
logfile=/var/log/provisioner.log
## Function to echo action with time stamp
log() {
    echo "$(date +'%X %x') $1" | sudo tee -a $logfile
}

log "Installing EPEL repository"
sudo yum install -y epel-release
log "Updating Operating System"
sudo yum update -y
log "Install basic packages for smooth system functioning."
sudo yum install -y yum-utils bash-completion fail2ban fail2ban-firewalld langpacks-en glibc-langpack-en

log "Installing Docker"
sudo yum config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
sudo yum -y install docker-ce docker-ce-cli containerd.io docker-compose-plugin
log "Enable docker"
sudo systemctl enable docker.service

log "## System hardening ##"
log "Adding time stamp to command history"
echo 'export HISTTIMEFORMAT="%Y-%m-%d %H:%M:%S "' | sudo tee -a /root/.bashrc
echo "
########################################################################
# Authorized access only!
# If you are not authorized to access or use this system, disconnect now!
########################################################################
" | sudo tee /etc/mybanner

log "Securing SSH"
sudo mv /etc/ssh/sshd_config /etc/ssh/sshd_config_org
echo "Include /etc/ssh/sshd_config.d/*.conf
AuthorizedKeysFile .ssh/authorized_keys
Protocol 2
Banner /etc/mybanner
PermitRootLogin no
PasswordAuthentication no
PermitEmptyPasswords no
MaxAuthTries 3
ClientAliveInterval 300
ClientAliveCountMax 2
AllowUsers azureuser gcpuser
X11Forwarding no
Subsystem sftp	/usr/libexec/openssh/sftp-server
"| sudo tee /etc/ssh/sshd_config

sudo systemctl reload sshd.service

log "Enable firewalld & allow SSH, HTTP, HTTPS services"
sudo systemctl enable firewalld.service
sudo systemctl start firewalld.service
sudo firewall-cmd --permanent --add-service=ssh
sudo firewall-cmd --permanent --add-service=http
sudo firewall-cmd --permanent --add-service=https
sudo firewall-cmd --reload

log "Enable fail2ban & configure it to protect SSH against DDOS"
sudo systemctl enable fail2ban.service
sudo systemctl start fail2ban.service

echo "[sshd]
enabled = true
filter = sshd
bantime = 30m
findtime = 30m
maxretry = 5
"| sudo tee /etc/fail2ban/jail.local

sudo cp /etc/fail2ban/jail.d/00-firewalld.conf /etc/fail2ban/jail.d/00-firewalld.local
sudo systemctl restart fail2ban.service

log "Disable SELinux"
sudo sed -i s/SELINUX=enforcing/SELINUX=disabled/g /etc/selinux/config
