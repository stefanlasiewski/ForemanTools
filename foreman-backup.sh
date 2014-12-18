#!/usr/bin/env bash

# Backup The Foreman, following the advice at 
# http://theforeman.org/manuals/1.7/index.html#5.5.1Backup

# Currently a very simple script.

# stefanl@nersc.gov

# Temporary: Be verbose
#set -x

# If any command fails, stop this script.
set -e

ME=`basename $0`

main () {

	DATE=$(date '+%Y%m%d.%H%M')
	BACKUPDIR=/data/backups/backup-$DATE
	mkdir $BACKUPDIR
	chgrp postgres $BACKUPDIR
	chmod g+w $BACKUPDIR
	
	cd $BACKUPDIR
	
	# Backup postgres database
	su - postgres -c "pg_dump -Fc foreman > $BACKUPDIR/foreman.dump"
	
	# Backup config ifles
	
	tar --selinux -czf $BACKUPDIR/etc_foreman_dir.tar.gz /etc/foreman
	tar --selinux -czf $BACKUPDIR/var_lib_puppet_dir.tar.gz /var/lib/puppet/ssl
	tar --selinux -czf $BACKUPDIR/tftpboot-dhcp.tar.gz /var/lib/tftpboot /etc/dhcp/ /var/lib/dhcpd/
	
	ls -lh *tar.gz foreman.dump

}

main 2>&1 | /usr/bin/logger -t $ME
