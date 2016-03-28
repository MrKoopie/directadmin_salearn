#!/bin/bash

#set this to 1 if you want the spam be removed after the run
DELETE_TEACH_DATA=1

# Create for every DirectAdmin system account the teach spam folders.
sync_teachspam_folder_for_every_directadmin_user()
{
	for user in `ls /usr/local/directadmin/data/users`;
	do
		echo "
Working on DirectAdmin user $user
";
		sync_teach_folders /home/$user/Maildir $user;
		sync_teachspam_folder_for_every_domain_of_user $user;
	done;
}

# Create for every domain the teach spam folders
sync_teachspam_folder_for_every_domain_of_user()
{
	user=${1};

	# Loop through every domain
	for domain in `cat /usr/local/directadmin/data/users/$user/domains.list`
	do
		echo "Working on domain $domain"
		sync_teachspamfolder_for_email_accounts_in_domain $domain;
		echo ${domain};
	done
}

sync_teachspamfolder_for_email_accounts_in_domain()
{
	domain=${1};

	for raw_account_data in `cat /etc/virtual/$domain/passwd`;
	do
		emailbox_name=`echo $raw_account_data | cut -d\: -f1`;
		maildir="`echo $raw_account_data | cut -d ':'  -f6`/Maildir";

		echo "Working on email box $emailbox_name@$domain"
		sync_teach_folders $maildir;
	done;
}

sync_teach_folders()
{
	maildir=${1};
	user=${2};
	teach_ispamfolder="$maildir/.INBOX.teach-isspam";
	teach_isnotspam="$maildir/.INBOX.teach-isnotspam";

	if [ -d $maildir ];
	then
		if [ -d  $teach_ispamfolder ];
		then
			# Sync the folder
			echo "Learning spam"
			sa-learn --no-sync --spam  $teach_ispamfolder/{cur,new}

			# Remove the messages
			if [ "$DELETE_TEACH_DATA" -eq 1 ]; then
				echo "deleting"
				rm -rf "$teach_ispamfolder/*";
			fi;
		fi

		if [ ! -d $teach_isnotspam ];
		then
			# Sync the folder
			echo "Learning nospam"
			sa-learn --no-sync --ham $teach_isnotspam/{cur,new}

			# Remove the messages
		 	if [ "$DELETE_TEACH_DATA" -eq 1 ]; then
		 		echo "deleting"
				rm -rf "$teach_isnotspam/*";
			fi;
		fi

	fi;

}

# Run the scripts
sync_teachspam_folder_for_every_directadmin_user;

exit 0;