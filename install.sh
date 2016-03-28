#!/bin/bash
# @description	Installs the spamassassin sa-learn scripts for every DirectAdmin e-mail account.
# @author 		Daniel Koop <mail@danielkoop.me>
# @link 		http://danielkoop.me/portfolio-item/directadmin-spamassassin-sa-learn-every-user/
# @copyright 	Daniel Koop 2016

pre_install_check()
{
	if [ ! -d "/usr/local/directadmin/" ]
	then
		echo "No DirectAdmin installation found. ABORTING!!";
	fi
}

copy_directadmin_hooks()
{
	if [ -f "/usr/local/directadmin/scripts/custom/email_create_post.sh" ];
	then
		echo "The custom script file email_create_post.sh exists. Please merge this file with da_scripts/email_create_post.sh.";
	else
		echo "INSTALLED custom/email_create_post.sh"
		cp da_scripts/email_create_post.sh /usr/local/directadmin/scripts/custom/email_create_post.sh
		chown diradmin: /usr/local/directadmin/scripts/custom/email_create_post.sh
		chmod 700 /usr/local/directadmin/scripts/custom/email_create_post.sh
	fi

	if [ -f "/usr/local/directadmin/scripts/custom/user_create_post_confirmed.sh" ];
	then
		echo "The custom script file user_create_post_confirmed.sh exists. Please merge this file with da_scripts/user_create_post_confirmed.sh.";
	else
		echo "INSTALLED custom/user_create_post_confirmed.sh"
		cp da_scripts/user_create_post_confirmed.sh /usr/local/directadmin/scripts/custom/user_create_post_confirmed.sh
		chown diradmin: /usr/local/directadmin/scripts/custom/user_create_post_confirmed.sh
		chmod 700 /usr/local/directadmin/scripts/custom/user_create_post_confirmed.sh
	fi
}

install_cron()
{
	if [ ! -d /scripts/mrkoopie/cron/ ];
	then
		mkdir -p /scripts/mrkoopie/cron/;
	fi

	if [ -f /scripts/mrkoopie/cron/learn_spamassassin.sh ]
	then
		echo "WARNING!!! /scripts/mrkoopie/cron/learn_spamassassin.sh EXISTS!! CHECK THE README AND INSTALL THE CRON MANUALLY!!";
	else

		# Install the cron
		cp cron/learn_spamassassin.sh /scripts/mrkoopie/cron/learn_spamassassin.sh
		chmod 700 /scripts/mrkoopie/cron/learn_spamassassin.sh
		echo "1 12 * * * /scripts/mrkoopie/cron/learn_spamassassin.sh > /dev/null 2>&1"
		service crond restart

		echo "Installed /scripts/mrkoopie/cron/learn_spamassassin.sh"
	fi
}

# Run the scripts
pre_install_check;
copy_directadmin_hooks;
install_cron;

sh first_run.sh

exit 0;