# Automatic scripts
Each script must be run with `bash`.

For the automatic scripted run you would need to set variables in the start of the script.


## Apache
Script for Apache.

### How to
Verify configurations and SSL certificates by running the following command:

```
# bash apache.sh
```

### Example automatic output
```
# bash apache.sh
Default HTTP site is NOT running.
Default HTTP site is NOT running.
CND site is already running.
Delivered config file is found cnd-orig.conf
There is an difference between delivered config and running config file
Overwritten running config with delivered config.
Private key exists in /etc/ssl/private/apache-signed.key
Public key exists in /etc/ssl/certs/apache-signed.crt
Configuration file does not contain ServerName.
Successfully added ServerName to the /etc/apache2/sites-enabled/cnd-site.conf.
Module running: headers
Module running: ssl
Module running: socache_shmcb
Module running: rewrite
```

## Linux
Script for hardening Linux.

### How to
Verify configuration by running the following command:

```
# bash linux.sh
```

### Example automatic output
```
# bash linux.sh
ufw is running.
UFW status before running through rules.
Status: active

To                         Action      From
--                         ------      ----
48721/tcp                  ALLOW       Anywhere                  
80/tcp                     ALLOW       Anywhere                  
443/tcp                    ALLOW       Anywhere                  
48721/tcp (v6)             ALLOW       Anywhere (v6)             
80/tcp (v6)                ALLOW       Anywhere (v6)             
443/tcp (v6)               ALLOW       Anywhere (v6)             

Successfully allowed all outgoing traffic.
Successfully denied all incoming traffic.
Successfully enabled logging.
Successfully allowed traffic on 80/tcp.
Successfully allowed traffic on 443/tcp.
Successfully allowed traffic on 48721/tcp.
Updates are active.
Updates are active.
Updates are active.
Updates are active.
Updates are active.

Viewing sysctl.conf:
fail2ban is running.
```

## SSH
Script for hardening SSH.

### How to
Verify configuration by running the following command:

```
# bash sshd.sh
```

### Example automatic output
```
# bash sshd.sh
Checking if key pair exists in a users home directory
Successfully found key pair with the name id_rsa.
SSH port is set to: 48721
Sucessfully changed SSH parameter to 48721
ListenAddress is set to: 192.168.1.120
Sucessfully changed ListenAddress parameter to 192.168.1.120
LoginGraceTime is set to: 1m
Sucessfully changed LoginGraceTime parameter to 1m
PermitRootLogin is set to: no
Sucessfully changed PermitRootLogin parameter to no
X11Forwarding is set to: no
Sucessfully changed X11Forwarding parameter to no
AllowGroups is set to: ssh
Sucessfully changed AllowGroups parameter to ssh
PasswordAuthentication is set to: no
Sucessfully changed PasswordAuthentication parameter to no
AuthenticationMethods is set to: publickey,keyboard-interactive
Sucessfully changed AuthenticationMethods parameter to publickey,keyboard-interactive
ChallengeResponseAuthentication is set to: yes
Sucessfully changed ChallengeResponseAuthentication parameter to yes
PubkeyAuthentication is set to: yes
Sucessfully changed PubkeyAuthentication parameter to yes
Adding user cnd to group adm
Adding user cnd to group ssh
Adding user cnd to group sudo

Viewing running SSHd configuration:
```