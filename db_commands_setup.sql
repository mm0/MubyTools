BEGIN TRANSACTION;

	/*	CATEGORIES	*/
	INSERT INTO admin_categories VALUES(1, 'LOCAL CLI Commands','Commands to be executed locally through a Shell');
	INSERT INTO admin_categories VALUES(2, 'REMOTE CLI Commands','Commands to be executed remotely through SSH');
	INSERT INTO admin_categories VALUES(3, 'DATABASE Commands','Commands used for managing databases');
	INSERT INTO admin_categories VALUES(4, 'VAGRANT Commands','Commands to be executed remotely through SSH');

	/*	COMMAND TYPES*/
	INSERT INTO admin_command_types VALUES(null, 'Current User','Executes Commands using Current User');
	INSERT INTO admin_command_types VALUES(null, 'Sudo','Executes Commands using Sudo');

	/*	COMMAND INPUT TYPES*/
	INSERT INTO admin_command_input_types VALUES(null, 'Regular Input (Text)','Determines where to search for user input');
	INSERT INTO admin_command_input_types VALUES(null, 'Regular Input (Filename)','Helpers for local filesystem file input');
	INSERT INTO admin_command_input_types VALUES(null, 'User TTY Input (Text)','Determines where to search for user input');
	INSERT INTO admin_command_input_types VALUES(null, 'STDIN Input','Determines where to search for user input');

	/*	COMMANDS*/
INSERT INTO admin_commands VALUES(NULL,1,1,'ssh $1:$2 $3','Connect to Remote Server','Connect to Remote Server',1,2,1,'ssh_connect');
INSERT INTO admin_commands VALUES(NULL,1,1,'gunzip $1','GUNZIP File','Expands a GZ file',1,2,1,'gunzip');
INSERT INTO admin_commands VALUES(NULL,2,1,'scp $1:$2 $3','Retrieve a remote file through SCP','Retrieve a remote file through SCP',1,3,1,'scp_retrieve');
INSERT INTO admin_commands VALUES(NULL,2,1,'scp $4 $1:$2 ','Send a remote file through SCP','Send a local file to Remote server through SCP',1,3,1,'scp_send');
INSERT INTO admin_commands VALUES(NULL,1,2,"echo '$1' >> /etc/hosts",'Set Local /etc/hosts File for development','Set Local /etc/hosts File for development',1,1,0,'set_local_hosts');
INSERT INTO admin_commands VALUES(NULL,3,1,"mysql -u$1 -p'$2' $3 < $4 ",'Import local MySQL DB','Import local MySQL DB',1,3,1,'mysql_import');
INSERT INTO admin_commands VALUES(NULL,1,1,'exit','exit','Exit',1,0,0,'exit');
INSERT INTO admin_commands VALUES(NULL,4,1,'vagrant up $1 ','Start Vagrant Server ','Start Vagrant Server via SSH',1,0,1,'vagrant_start');
INSERT INTO admin_commands VALUES(NULL,4,1,"vagrant ssh -c'$1' ",'Send Command to Vagrant Server via SSH','Send Command to Vagrant Server via SSH',1,1,0,'vagrant_execute_cmd');
COMMIT;
/*
INSERT INTO admin_commands VALUES(NULL,NULL,9,'dump_db','Dump local MySQL DB','Dump local MySQL DB','MySQL','');
INSERT INTO admin_commands VALUES(NULL,NULL,7,'unset_local_hosts','Unset Local /etc/hosts File for development','Unset Local /etc/hosts File for development','Unix','');
INSERT INTO admin_commands VALUES(NULL,NULL,11,'get_remote_db','Retrieve remote MySQL DB Dump','Retrieve remote MySQL DB Dump','MySQL','');
INSERT INTO admin_commands VALUES(NULL,NULL,12,'export_local_db','Export Local MySQL DB Dump to Remote Server','Export Local MySQL DB Dump to Remote Server','MySQL','');
INSERT INTO admin_commands VALUES(NULL,NULL,1,'send_remote_file','Send a file to remote server through SCP','Send a file to remote server through SCP','Unix','');
INSERT INTO admin_commands VALUES(NULL,NULL,1,'connect_remote','Dump local MySQL DB','Dump local MySQL DB','Unix','');
INSERT INTO admin_commands VALUES(NULL,NULL,8,'rsync_directories','Rsync Local Directories','Rsync Local Directories','Unix','');
INSERT INTO admin_commands VALUES(NULL,NULL,13,'git_pull','Git Pull','Git Pull','Git','');
INSERT INTO admin_commands VALUES(NULL,NULL,14,'git_quick_commit','Quick Add+Commit+Push To Github','Quick Add+Commit+Push To Github','Git','');
INSERT INTO admin_commands VALUES(NULL,NULL,15,'setup_ec2_command_line_tools','Setup EC2 Command Line Tools','Setup EC2 Command Line Tools','EC2','');
INSERT INTO admin_commands VALUES(NULL,NULL,16,'show_servers','List EC2 Servers','Lists EC2 Servers','EC2','');
INSERT INTO admin_commands VALUES(NULL,NULL,17,'show_images','List EC2 Snapshots','Lists EC2 Snapshots','EC2','');
INSERT INTO admin_commands VALUES(NULL,NULL,18,'show_emis','List EC2 EMIs','Lists EC2 EMIs','EC2','');
INSERT INTO admin_commands VALUES(NULL,NULL,19,'open_ec2_port','Open EC2 Port','Open EC2 Port','EC2','');
INSERT INTO admin_commands VALUES(NULL,NULL,20,'close_ec2_port','Close EC2 Port','Close EC2 Port','EC2','');
*/
