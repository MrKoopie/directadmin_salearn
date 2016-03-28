#!/bin/bash
# @description	Installs the spamassassin sa-learn scripts for every DirectAdmin e-mail account.
# @author 		Daniel Koop <mail@danielkoop.me>
# @link 		http://danielkoop.me/portfolio-item/directadmin-spamassassin-sa-learn-every-user/
# @copyright 	Daniel Koop 2016

# Create for every DirectAdmin system account the teach spam folders.
create_teachspam_folder_for_every_directadmin_user()
{
	for user in `ls /usr/local/directadmin/data/users`;
	do
		echo "
Working on DirectAdmin user $user
";
		create_teach_folders /home/$user/Maildir $user;
		create_teachspam_folder_for_every_domain_of_user $user;
	done;
}

# Create for every domain the teach spam folders
create_teachspam_folder_for_every_domain_of_user()
{
	user=${1};

	# Loop through every domain
	for domain in `cat /usr/local/directadmin/data/users/$user/domains.list`
	do
		echo "Working on domain $domain"
		create_teachspamfolder_for_email_accounts_in_domain $domain;
		echo ${domain};
	done
}

create_teachspamfolder_for_email_accounts_in_domain()
{
	domain=${1};

	for raw_account_data in `cat /etc/virtual/$domain/passwd`;
	do
		emailbox_name=`echo $raw_account_data | cut -d\: -f1`;
		maildir="`echo $raw_account_data | cut -d ':'  -f6`/Maildir";

		echo "Working on email box $emailbox_name@$domain"
		create_teach_folders $maildir;
	done;
}

create_teach_folders()
{
	maildir=${1};
	user=${2};

	if [ ! -d $maildir ];
	then
		mkdir $maildir;
		touch $maildir/subscriptions
		chown $user:mail $maildir -R;

	fi;

	if [ ! -d "$maildir/subscriptions" ];
	then
		touch $maildir/subscriptions
	fi;

	if [ ! -d "$maildir/.INBOX.teach-isspam" ];
	then
		# echo "Creating teach-isspam for $maildir/.INBOX.teach-isspam";
		mkdir $maildir/.INBOX.teach-isspam;
	fi

	if [ ! -d "$maildir/.INBOX.teach-isnotspam" ];
	then
		# echo "Creating teach-isspam for $maildir/.INBOX.teach-isnotspam";
		mkdir $maildir/.INBOX.teach-isnotspam;
	fi

	chown $user:mail $maildir/.INBOX.teach-isspam;
	chown $user:mail $maildir/.INBOX.teach-isnotspam;

	# Inspired by https://help.poralix.com/articles/script-for-bulk-create-of-sa-teach-folders
	c=`grep INBOX.teach-isspam $maildir/subscriptions -c`
    if [ $c == 0 ]; then
        echo INBOX.teach-isspam >> $maildir/subscriptions
    fi;


   	c=`grep INBOX.teach-isnotspam $maildir/subscriptions -c`
    if [ $c == 0 ]; then
        echo INBOX.teach-isnotspam >> $maildir/subscriptions
    fi;

    chown $user:mail $maildir -R;

}

# Run the scripts
create_teachspam_folder_for_every_directadmin_user;

exit 0;