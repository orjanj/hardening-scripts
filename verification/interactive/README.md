# Interactive scripts
Each script must be run with `bash`.


## Apache
Scripts for Apache.

### How to
Verify configurations and SSL certificates by running the following command:

```
$ bash apache.sh
```

### Example interactive output
```
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

