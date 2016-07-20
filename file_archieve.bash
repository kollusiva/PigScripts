#!/usr/bin/ksh
#  

#
# 
#
#
PROGNAME=`basename $0`
HOSTNAME=`hostname`
TOUCHFILE=/usr/local/nmon/data/file_mark
PICKUPFOLDER=/usr/local/nmon/data/pick_up_folder
ARCHIVE_FOLDER=/usr/local/nmon/data/nmon_raw_data_archive
ARCHIVELIST=/tmp/filelist.$$
TIMESTAMP=`date +%Y%m%d`0015
LOGFILE=/usr/local/nmon/data/`echo ${PROGNAME} | cut -f1 -d.`_`date +%Y%m%d%H%M`.log


exec > $LOGFILE
exec 2>&1
umask 023

Log()
{
	echo "`date '+%d/%m/%y %T'` $1"
}



touch -t $TIMESTAMP $TOUCHFILE

for file in `ls /usr/local/nmon/data/*.csv`
do
	if [ $file -ot $TOUCHFILE ]; then
		cp $file $ARCHIVE_FOLDER
		mv $file $PICKUPFOLDER
	fi
done
scp -p -i /usr/local/scripts/aix123_key /usr/local/nmon/data/pick_up_folder/*.csv aix123@<CentralizedNMON Server>:/usr/local/nmon_data

# Clean up old log files. Archive the raw nmon data older than 14 days and 
# then delete them.

( cd $PICKUPFOLDER; find . -name "*.csv" -mtime +1 -exec rm -f {} \;)

find $ARCHIVE_FOLDER -name "*.csv" -mtime +14 > $ARCHIVELIST


	( cd $ARCHIVE_FOLDER; find . -name "*.csv" -mtime +14 -exec rm -f {} \;)
	
rm $ARCHIVELIST

( cd /usr/local/nmon/data; find . -name "*.log" -mtime +14 -exec rm -f {} \;)
( cd /usr/local/nmon/data/nmon_raw_data_archive; find . -name "*.csv" -mtime +14 -exec rm -f {} \;)
exit 0