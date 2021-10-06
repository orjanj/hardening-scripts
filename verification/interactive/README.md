# Interactive scripts
Each script must be run with `bash`.


## Apache
Script for Apache.

### How to
Verify configurations and SSL certificates by running the following command:

```
# bash apache.sh
```

### Example interactive output
```
# bash apache.sh
Default HTTP site is NOT running.
Default HTTP site is NOT running.
CND site is already running.
Delivered config file is found cnd-orig.conf
There is an difference between delivered config and running config file
Do you want to use delivered config [y]?n
Private key exists in /etc/ssl/private/apache-signed.key
Public key exists in /etc/ssl/certs/apache-signed.crt
Configuration file does not contain ServerName.
Do you want to add the Server Name to the configuration [y]?y
Successfully added ServerName to the /etc/apache2/sites-enabled/cnd-site.conf.
Module not running: headers (it must run to make the site work)
Do you want to enable the module headers [y]?y
Enabling module headers.
To activate the new configuration, you need to run:
  systemctl restart apache2
Successfully enabled headers.
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

### Example interactive output
```
# bash linux.sh
Do you want to enable ufw [y]?y
Command may disrupt existing ssh connections. Proceed with operation (y|n)? y
Firewall is active and enabled on system startup
UFW status before running through rules.
Do you want to show the ufw status [y]?y
Status: active

To                         Action      From
--                         ------      ----
48721/tcp                  ALLOW       Anywhere                  
80/tcp                     ALLOW       Anywhere                  
443/tcp                    ALLOW       Anywhere                  
48721/tcp (v6)             ALLOW       Anywhere (v6)             
80/tcp (v6)                ALLOW       Anywhere (v6)             
443/tcp (v6)               ALLOW       Anywhere (v6)             

Do you want to allow all outgoing traffic by default [y]?y
Successfully allowed all outgoing traffic.
Do you want to deny all incoming traffic by default [y]?y
Successfully denied all incoming traffic.
Do you want to enable logging [y]?y
Successfully enabled logging.
Do you want to allow traffic on port 80 [y]?y
Successfully allowed traffic on 80/tcp.
Do you want to allow traffic on port 443 [y]?y
Successfully allowed traffic on 443/tcp.
Do you want to allow traffic on port 48721 [y]?y
Successfully allowed traffic on 48721/tcp.
Updates are active.
Updates enabled.
Updates enabled.
Updates enabled.
Updates enabled.

Do you want to load sysctl parameters [y]?n
kernel.kptr_restrict = 2
Do you want to change kernel.kptr_restrict [y]?n
kernel.dmesg_restrict = 1
Do you want to change kernel.dmesg_restrict [y]?n
net.ipv6.conf.all.disable_ipv6 = 1
Do you want to change net.ipv6.conf.all.disable_ipv6 [y]?n
net.ipv6.conf.default.disable_ipv6 = 1
Do you want to change net.ipv6.conf.default.disable_ipv6 [y]?n
net.ipv6.conf.lo.disable_ipv6 = 1
Do you want to change net.ipv6.conf.lo.disable_ipv6 [y]?n
If any changed sysctl parameters, these will not be effective during next reboot.
The same values must be added to /etc/sysctl.conf

Do you want to see active sysctl parameters [y]?n
fail2ban is running.
```

## SSH
Script for hardening SSH.

### How to
Verify configuration by running the following command:

```
# bash sshd.sh
```

### Example interactive output
```
# bash sshd.sh
Checking if key pair exists in a users home directory
Enter username: cnd
Enter key pair name [id_rsa]:
Successfully found key pair with the name id_rsa.
SSH port is set to: 48721
Do you want to change this parameter [y]?y
Sucessfully changed SSH parameter to 48721
ListenAddress is set to: 192.168.1.120
Do you want to change this parameter [y]?y
Sucessfully changed ListenAddress parameter to 192.168.1.120
LoginGraceTime is set to: 1m
Do you want to change this parameter [y]?y
Sucessfully changed LoginGraceTime parameter to 1m
PermitRootLogin is set to: no
Do you want to change this parameter [y]?y
Sucessfully changed PermitRootLogin parameter to no
X11Forwarding is set to: no
Do you want to change this parameter [y]?y
Sucessfully changed X11Forwarding parameter to no
AllowGroups is set to: ssh
Do you want to change this parameter [y]?y
Sucessfully changed AllowGroups parameter to ssh
PasswordAuthentication is set to: no
Do you want to change this parameter [y]?y
Sucessfully changed PasswordAuthentication parameter to no
AuthenticationMethods is set to: publickey,keyboard-interactive
Do you want to change this parameter [y]?y
Sucessfully changed AuthenticationMethods parameter to publickey,keyboard-interactive
ChallengeResponseAuthentication is set to: yes
Do you want to change this parameter [y]?y
Sucessfully changed ChallengeResponseAuthentication parameter to yes
PubkeyAuthentication is set to: yes
Do you want to change this parameter [y]?y
Sucessfully changed PubkeyAuthentication parameter to yes
Do you want to add cnd to the adm group [y]?y
Adding user cnd to group adm
Do you want to add cnd to the ssh group [y]?y
Adding user cnd to group ssh
Do you want to add cnd to the sudo group [y]?y
Adding user cnd to group sudo

Do you want to view the SSHd config [y]?n
Not reviewing SSHd configuration.
```