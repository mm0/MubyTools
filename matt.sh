#!/bin/bash
clear;

##			Mysql	Dump	Configuration		##
TIME=$(/bin/date +%H-%M-%S)
DAY=$(/bin/date +%F)
FILE="mysqldump-${DAY}-${TIME}.sql"

##			Local	Configuration			##
LOCALHOST="127.0.0.1"
LOCAL_KEY_DIRECTORY="/Users/matt/.ssh/"
REMOTE_SERVER_KEY="${LOCAL_KEY_DIRECTORY}gassy.pem"
SSH_TUNNEL_PORT="3318"
TUNNEL_PORT="3312"
TUNNEL_SLEEP="20"
LOCAL_SERVER_USER="root"
DEV_PATH="/var/www/dev/"
STAGING_PATH="/var/www/staging/"
PRODUCTION_PATH="/var/www/git/gas/"
EC2_API_TOKEN='A80325AA4DAB186C80828ED5138633E3F49160D9'
##			Remote	Server	Configuration		##
REMOTE_SERVER_IP="dev.gatherandsave.com"
REMOTE_SERVER_USER="root"
REMOTE_DEV_PATH="/var/www/dev/"
REMOTE_STAGING_PATH="/var/www/staging/"
REMOTE_PRODUCTION_PATH="/var/www/git/gas/"
REMOTE_PORT="3306"	#	Mysql Port
REMOTE_SSH_PORT="22"
REMOTE_GIT_PATH="/var/www/git/gas/"

##			Git	Configuration			##
GIT_PATH="/Users/matt/Documents/Git/"
GIT_ROOT_PATH="/Users/matt/Documents/Git/gas/"

##			URL	Configuration			##
DEV_URL="http://dev.gatherandsave.com/"
STAGING_URL="http://staging.gatherandsave.com/"
PRODUCTION_URL="http://www.gatherandsave.com/"

##			MYSQL	Configuration			##
MYSQL_PASSW0RD="password"
MYSQL_USER="root"
MYSQL_DUMP_DIR="/tmp/mysql_dumps";

DEV_USER="gassy_dev"
DEV_PASSWORD="password"
DEV_DB="gassy_dev"

STAGING_USER="gassy_staging"
STAGING_PASSWORD="password"
STAGING_DB="gassy_staging"

PRODUCTION_USER="gassy"
PRODUCTION_PASSWORD="password"
PRODUCTION_DB="gassy"

SSH_KEYS=("${LOCAL_KEY_DIRECTORY}babeebook.pem" 
	"${LOCAL_KEY_DIRECTORY}vinport.pem" 
	"${LOCAL_KEY_DIRECTORY}mytowns.pem"
	"${LOCAL_KEY_DIRECTORY}mhcmarlins.pem" 
	"${LOCAL_KEY_DIRECTORY}boothify_new.pem" 
	"${LOCAL_KEY_DIRECTORY}gasapp.pem")
SSH_PORTS=('22' 
		'22' 
		'22' 
		'22' 
		'22' 
		'22')
SSH_USERS=('root' 
		'root' 
		'root' 
		'serveradmin%prolificstaging.com' 
		'root' 
		'root')
Servers=('babeebook.com' 
	'vinport.com' 
	'23.23.86.212'  
	'prolificstaging.com' 
	'boothify.me' 
	'dev.gas.vg') 
#'ec2-23-23-26-4.compute-1.amazonaws.com')
##			PROBABLY DON'TOUCH BELOW UNLESS YOU KNOW WHAT YOU'RE DOING		##
# Text color variables
txtund=$(tput sgr 0 1)          # Underline
txtbld=$(tput bold)             # Bold
bldred=${txtbld}$(tput setaf 1) #  red
bldblu=${txtbld}$(tput setaf 4) #  blue
bldwht=${txtbld}$(tput setaf 7) #  white
txtrst=$(tput sgr0)             # Reset
info=${bldwht}*${txtrst}        # Feedback
pass=${bldblu}*${txtrst}
warn=${bldred}*${txtrst}
ques=${bldblu}?${txtrst}

##			Functions				##

function connect_remote {
#SHOW Server List
sub_menu "${Servers[@]}"
ser=$?
#TODO: Validate Input
	ssh -i ${SSH_KEYS[$ser]} -l ${SSH_USERS[$ser]} ${Servers[$ser]} -p ${SSH_PORTS[$ser]}
}
function dump_db {
#TODO: DISPLAY USER INFO + DIR + FILE then confirm with option to manually input username password, dir,file
#TODO: Ability to cancel
        echo dumping mysql
        mysqldump -u$MYSQL_USER -p$MYSQL_PASSW0RD --all-databases > $MYSQL_DUMP_DIR$FILE
        echo dump complete: $MYSQL_DUMP_DIR$FILE
}
function import_db {
        echo -n enter file '> '
        read -e file1
        if [ ! -r $file1 ];then
                echo file doesn\'t exist
                exit 2
        fi
        if [ "${file1#*.}" != 'sql' ] ; then
                echo invalid file extension
                exit 2
        fi
#TODO: DISPLAY USER INFO + DIR + FILE then confirm with option to manually input username password, file
        echo importing db
        mysql -u$MYSQL_USER -p$MYSQL_PASSW0RD < $file1
        echo import done
	echo restarting db
#TODO: CHECK OS
#ubuntu
#	service mysql restart
#centos service mysqld restart
	service mysqld restart
	echo done
}
function get_remote_db {
#TODO: DISPLAY CONNECTION Info then confirm with option to manually input 
	echo creating ssh tunnel $TUNNEL_PORT:$LOCALHOST:$REMOTE_PORT
	ssh -f -L$TUNNEL_PORT:localhost:$REMOTE_PORT $REMOTE_SERVER_USER@$REMOTE_SERVER_IP -i $REMOTE_SERVER_KEY sleep $TUNNEL_SLEEP
# dump through tunnel
	echo starting dump
	mysqldump -P $TUNNEL_PORT -h $LOCALHOST -u$MYSQL_USER -p$MYSQL_PASSW0RD --all-databases > $MYSQL_DUMP_DIR$FILE
	echo dump complete: $MYSQL_DUMP_DIR$FILE
}
function send_db_to_remote {
#TODO: DISPLAY CONNECTION Info then confirm with option to manually input 
        echo -n enter file '> '
        read -e file1
        if [ ! -r $file1 ];then
                echo file doesn\'t exist
                exit 2
        fi
        if [ "${file1#*.}" != 'sql' ] ; then
                echo invalid file extension
                exit 2
        fi
	echo creating ssh tunnel $SSH_TUNNEL_PORT:$LOCALHOST:$REMOTE_PORT
	ssh -i $REMOTE_SERVER_KEY -l $LOCAL_SERVER_USER -f $REMOTE_SERVER_IP -L $SSH_TUNNEL_PORT:localhost:$REMOTE_SSH_PORT sleep $TUNNEL_SLEEP 
	echo opening tunnel ...
	ssh -i $REMOTE_SERVER_KEY -l $REMOTE_SERVER_USER $LOCALHOST -p $SSH_TUNNEL_PORT
	echo sending db ...
	#uname -r
#	mysql -P TUNNEL_PORT -h $LOCALHOST -u$MYSQL_USER -p$MYSQL_PASSW0RD < $file1
}
function send_remote_cmd {
#TODO: DISPLAY CONNECTION Info then confirm with option to manually input 
	echo -n enter local port '> '
	read tport
	echo -n enter cmd '> '	
	read cmd
	echo creating ssh tunnel $tport:LOCALHOST:$REMOTE_SSH_PORT
	ssh -i $REMOTE_SERVER_KEY -l $LOCAL_SERVER_USER -f $REMOTE_SERVER_IP -L $tport:$LOCALHOST:$REMOTE_SSH_PORT sleep $TUNNEL_SLEEP 
	echo opening tunnel ...
	`ssh -i $REMOTE_SERVER_KEY -l $REMOTE_SERVER_USER $LOCALHOST -p "$tport"`
	expect "yes/no"
	send \"yes\r\"
	close; 
#	$cmd
}

function set_hosts_file_local {
#TODO: DISPLAY URLS then confirm with option to manually enter urls 
	unset_hosts_file_local
	sudo echo -e '127.0.0.1\tvinport.com\n127.0.0.1\twww.vinport.com\n127.0.0.1\tdev.vinport.com\n127.0.0.1\tstaging.vinport.com\n127.0.0.1\tbeta.vinport.com\n127.0.0.1\tsample.vinport.com\n' >> /etc/hosts
}
function unset_hosts_file_local {
#TODO: DISPLAY KEYWORD(URL) then confirm with option to manually enter urls 
	sudo sed "/vinport/d" /etc/hosts -i
}
function save_to_git { 
        echo -n enter message '> '
        read message
	git add -A $GIT_ROOT_PATH; 
	git commit -a -m "$message" ; 
	git push ; 
} 
function send_file_to_remote {
#TODO: DISPLAY CONNECTION Info then confirm with option to manually input 
	echo -n local file/dir '> '
	read -e local_file
	echo -n remote_file/dir '> '
	read -e remote_file
#	prompt for local file prompt for remote file, scp file
	scp -i $REMOTE_SERVER_KEY $local_file $REMOTE_SERVER_USER@$REMOTE_SERVER_IP:$remote_file
}
function retrieve_remote_file {
#TODO: DISPLAY CONNECTION Info then confirm with option to manually input 
	echo -n local file/dir '> '
	read -e local_file
	echo -n remote_file/dir '> '
	read -e remote_file
	scp -i $REMOTE_SERVER_KEY $REMOTE_SERVER_USER@$REMOTE_SERVER_UP:$remote_file $local_file
}
function set_dev {
#	update local mysql db, set the urls, update config.xml/local.xml to use correct mysql user+pass+db
# this is custom for vinport/magento

table='vp_core_config_data'
query="UPDATE $table SET value='$DEV_URL' WHERE path in ('web/unsecure/base_url','web/sercure/base_url')";
	mysql -u$MYSQL_USER -p$MYSQL_PASSW0RD -e "$query" $DEV_DB
localxml=$DEV_PATH'app/etc/local.xml'
configxml=$DEV_PATH'app/etc/config.xml'
	sed -i.backup  "s/<dbname>magento<\/dbname>/<dbname>$DEV_DB<\/dbname>/" $configxml
	sed -i.backup "s/<username><!\[CDATA\[\w*\]\]><\/username>/<username><!\[CDATA\[$DEV_USER\]\]><\/username>/;s/<password><!\[\CDATA\[\w*\]\]><\/password>/<password><!\[CDATA\[$DEV_PASSWORD\]\]><\/password>/;s/<dbname><!\[CDATA\[\w*\]\]><\/dbname>/<dbname><!\[CDATA\[$DEV_DB\]\]><\/dbname>/" $localxml

#	update local mysql db, set the urls, update config.xml/local.xml to use correct mysql user+pass+db
}

function set_staging {
# this is custom for vinport/magento
table='vp_core_config_data'
query="UPDATE $table SET value='$STAGING_URL' WHERE path in ('web/unsecure/base_url','web/sercure/base_url')";
	mysql -u$MYSQL_USER -p$MYSQL_PASSW0RD -e "$query" $STAGING_DB
localxml=$STAGING_PATH'app/etc/local.xml'
configxml=$STAGING_PATH'app/etc/config.xml'
	sed -i.backup  "s/<dbname>\w*<\/dbname>/<dbname>$STAGING_DB<\/dbname>/" $configxml
	sed -i.backup  "s/<username><!\[CDATA\[\w*\]\]><\/username>/<username><!\[CDATA\[$STAGING_USER\]\]><\/username>/;s/<password><!\[\CDATA\[\w*\]\]><\/password>/<password><!\[CDATA\[$STAGING_PASSWORD\]\]><\/password>/;s/<dbname><!\[CDATA\[\w*\]\]><\/dbname>/<dbname><!\[CDATA\[$STAGING_DB\]\]><\/dbname>/" $localxml
#	update local mysql db, set the urls, update config.xml/local.xml to use correct mysql user+pass+db
}
function replicate_db {
	mysqldump -u$MYSQL_USER -p$MYSQL_PASSW0RD $PRODUCTION_DB | mysql -u$MYSQL_USER -p$MYSQL_PASSW0RD $DEV_DB
	mysqldump -u$MYSQL_USER -p$MYSQL_PASSW0RD $PRODUCTION_DB | mysql -u$MYSQL_USER -p$MYSQL_PASSW0RD $STAGING_DB
}
#function set_production {
#query='UPDATE $table SET path?=$blah WHERE blah 
#	mysql -u$MYSQL_USER -p$MYSQL_PASSW0RD -e $query $db
#	update local mysql db, set the urls, update config.xml/local.xml to use correct mysql user+pass+db
#}
function git_pull {
	cd $GIT_ROOT_PATH
	git pull	
}
function git_to_dev {
#	pull from github to repository, copy over to dev folder
	rsync -vr $GIT_PATH $REMOTE_DEV_PATH
}
function git_to_stage {
#	$REMOTE_GIT_PATH
#	pull from github to repository, copy over to stage folder
	rsync -vr $GIT_PATH $REMOTE_STAGING_PATH
}
#function git_to_production {
#	cd to repository,pull from github to ec2 repository, copy to live folder
#}
function dev_to_stage {
	rsync -vr $REMOTE_DEV_PATH $REMOTE_STAGING_PATH
}
function stage_to_production {
	rsync -vr $REMOTE_STAGING_PATH $REMOTE_PRODUCTION_PATH
}
function setup_ec2_command_line_tools {
	tools_url="http://www.amazon.com/gp/redirect.html/ref=aws_rc_ec2tools?location=http://s3.amazonaws.com/ec2-downloads/ec2-api-tools.zip&token=${EC2_API_TOKEN}"
	path="/var/www/"
	cd $path
	wget "$tools_url" -O ec2-api-tools.zip
	unzip ec2-api-tools.zip
	rm -f ec2-api-tools.zip
	cd ec2-api-tools-*
	check_java=`which java`
	if [ "$check_java" = "/usr/bin/java" ] ;then 
		echo "Java ok.."
	java_version=` $JAVA_HOME/bin/java -version`
		echo $java_version
	else
		echo "Java is missing...install to continue.."
	fi
	should_bashrc=`grep -l "export JAVA_HOME=/usr" ~/.bashrc`
	if [ "$should_bashrc" = "" ] ;then
		echo "export JAVA_HOME=/usr" >> ~/.bashrc
	else 
		echo "bashrc already ok.."
	fi
	should_bashrc=`grep -l "export EC2_HOME=" ~/.bashrc`
	if [ "$should_bashrc" = "" ] ;then
	dir=`pwd`
		echo "export EC2_HOME=$dir" >> ~/.bashrc
	else 
		echo "bashrc already ok.."
	fi
	should_bashrc=`grep -l "export PATH=" ~/.bashrc`
	if [ "$should_bashrc" = "" ] ;then
		echo "export PATH=\$PATH:$EC2_HOME/bin" >> ~/.bashrc
	else 
		echo "bashrc already ok.."
	fi
	should_bashrc=`grep -l "export AWS_ACCESS_KEY=" ~/.bashrc`
	if [ "$should_bashrc" = "" ] ;then
		echo -n "Enter AWS Access Key> "
		read -e aws_access_key
		echo "export AWS_ACCESS_KEY=$aws_access_key" >> ~/.bashrc
	else 
		echo "bashrc already ok.."
	fi
	should_bashrc=`grep -l "export AWS_SECRET_KEY=" ~/.bashrc`
	if [ "$should_bashrc" = "" ] ;then
		echo -n "Enter AWS Secret Key> "
		read -e aws_secret_key
		echo "export AWS_SECRET_KEY=$aws_secret_key" >> ~/.bashrc
	else 
		echo "bashrc already ok.."
	fi
}
function run_instance {
	echo -n "Enter AMI ID> "
	read -e ami_id
#TODO: Validate AMI ID
	ec2-run-instances $ami_id 
}
function ec2_set_default_ports_open {
#TODO: Be able to select Instance
	ec2-authorize default -p 22
	ec2-authorize default -p 80
}
function my_exit {
	clear;
#TODO: Make this do something annoying
	echo "Goodbye."
	sleep 1;
	exit 2
}
Functions=('connect_remote' 
		'dump_db' 
		'import_db' 
		'get_remote_db' 
		'send_db_to_remote' 
		'send_remote_cmd' 
		'set_hosts_file_local' 
		'unset_hosts_file_local' 
		'save_to_git' 
		'dev_to_stage' 
		'stage_to_production' 
		'send_file_to_remote' 
		'retrieve_remote_file'
		'replicate_db'
		'git_pull'
		'git_to_dev'
		'git_to_stage'
		'set_dev'
		'set_staging'
		'setup_ec2_command_line_tools'
		'ec2_set_default_ports_open' 
		'my_exit')


Categories=('Unix'
		'MySQL'
		'Git'
		'RSync'
		'EC2'
		'Exit')

Unix_Functions=('connect_remote'
		'send_remote_cmd'
		'set_hosts_file_local'
		'unset_hosts_file_local'
		'retrieve_remote_file')

Mysql_Functions=('dump_db'
		'import_db'
		'get_remote_db'
		'send_db_to_remote'
		'replicate_db'
		'set_dev'
		'set_staging')

Git_Functions=('save_to_git' 
		'git_pull')

RSync_Functions=('dev_to_stage'
		'git_to_dev'
		'git_to_stage')

EC2_Functions=('setup_ec2_command_line_tools'
		'ec2_set_default_port_open')

Function_descriptions=('Connect to Remote Server' 
			'Dump local MySQL DB' 
			'Import MySQL DB from Local File' 
			'Retrieve Remote MySQL DB Dump' 
			"Export Local MySQL DB Dump To Remote Server" 
			"Send Command to Remote Server via SSH" 
			"Set Local /etc/hosts File for development" 
			"Unset Local /etc/hosts File" 
			"Quick Add+Commit+Push To Github" 
			'Rsync Dev->Staging'
			'Rsync Staging->Production' 
			'Send File to Remote' 
			'Retrieve Remote File'
			'Replicate DB'
			'Pull from Git'
			'Git to Dev'
			'Git to Staging'
			'Set Dev'
			'Set Staging'	
			'Setup EC2 Command-line tools'
			'Open EC2 Ports 22 & 80'
			'Exit')
function sub_menu {
#SHOWS+Handles Sub Menu
	clear
	A=("$@")
	i=${#A[@]}
	echo 'Servers[n]:';
	for ((k=0;k<$i;k++));
	do
		echo "[$(tput setaf 2)${k}$(tput sgr0)]: $(tput setaf 1)${A[${k}]}$(tput sgr0)"
	done

	echo -n '> ' 
	read serv
	return $serv
}
function start_menu {
#SHOWS+Handles Main Menu
	clear;
	i=${#Functions[@]}
	echo " $(tput setaf 4)$(tput sgr 0 1)Functions [n]:$(tput sgr0)";
	for ((k=0;k<$i;k++));
	do
		echo "[$(tput setaf 2)${k}$(tput sgr0)]: $(tput setaf 1)${Function_descriptions[${k}]}$(tput sgr0)"
	done

	echo -n enter function '> ' 
	read func
	if ! [[ $func =~ ^[0-9]+$ ]]; then
		start_menu;
	fi
	if [ ${#func} -eq 0 ]; then
		start_menu;
	fi
	if [ ${func} -lt 0 ]; then
		start_menu;
	fi
	last=${#Functions[@]}-1
	if [[ "$func" -gt "$last" ]]; then
		start_menu;
	fi
	ISF="`type -t ${Functions[${func}]}`"
	if [ "$ISF" != "function" ]; then
	       exit 2
	fi
	${Functions[${func}]}
}
start_menu
exit 2

