# directadmin_spamassassin
This GIT repository contains the installation files to teach SpamAsassin spam and non-spam e-mails for every e-mail account in DirectAdmin.

# Installation
If you did not modify email_create_post.sh or user_create_post_confirmed.sh (and you did not do an installation of this script before), you can use the following commands. If you did modify those files or did a previous installation, the installer will detect this and request you to continue manually.
```bash
wget https://github.com/MrKoopie/directadmin_salearn/archive/master.tar.gz -O directadmin_salearn.tar.gz
tar zxvf directadmin_salearn.tar.gz
cd directadmin_salearn-master
chmod +x install.sh
./install.sh
```

#### Install the hooks
If you already have the hooks email_create_post.sh and/or user_create_post_confirmed.sh, the installer will not overwrite these files. Please merge the files together. The files are located in the folder da_scripts.
Tip: any script after exit 0; will be ignored. If you want to merge the files, put any script before exit 0;.


#### Install the cron
If the file /scripts/cron/learn_spamassassin.sh exists the installer will not overwrite this file. Check if you can delete this file (make a backup) and copy the file manually. Normally this should not happen, as the script is located in the mrkoopie space.
```bash
mkdir -p /scripts/cron/
cp cron/learn_spamassassin.sh /scripts/mrkoopie/cron/learn_spamassassin.sh
chmod 700 /scripts/cron/learn_spamassassin.sh
```


# Errors
#### WARNING!!! /scripts/cron/learn_spamassassin.sh EXISTS!! CHECK THE README AND INSTALL THE CRON MANUALLY!!
By default, the script installs the daily cron in /scripts/cron/learn_spamassassin.sh. If this file exists, install.sh will not overwrite this file and you have to install the cron manually (see installation).

### WARNING
This task can be resource intensive depending on the amount of active users and spam e-mails. 