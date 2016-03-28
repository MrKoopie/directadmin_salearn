#!/bin/bash
# @description	Installs the spamassassin sa-learn scripts for a new e-mail account.
# @author 		Daniel Koop <mail@danielkoop.me>
# @link 		http://danielkoop.me/portfolio-item/directadmin-spamassassin-sa-learn-every-user/
# @copyright 	Daniel Koop 2016

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

create_teachspamfolder_for_single_email_account_in_domain()
{
	domain=${1};
	account=${2};
	diradmin_user=${3};

	for raw_account_data in `cat /etc/virtual/$domain/passwd`;
	do
		emailbox_name=`echo $raw_account_data | cut -d\: -f1`;
		if [ $account == $emailbox_name ];
		then
			maildir="`echo $raw_account_data | cut -d ':'  -f6`/Maildir";

			# echo "Working on email box $emailbox_name@$domain"
			create_teach_folders $maildir $diradmin_user;
		fi;
	done;
}


# Run the scripts
create_teachspamfolder_for_single_email_account_in_domain $domain $user $username;


exit 0;