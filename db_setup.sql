BEGIN TRANSACTION;
CREATE TABLE admin_config (
		Id INTEGER PRIMARY KEY,
        Name TEXT, 
		Option TEXT
     ) ;
CREATE TABLE
       admin_databases (
			Id INTEGER PRIMARY KEY, 
			Name TEXT, 
			Host TEXT,
		    Port INTEGER, 
			Type TEXT,
		    Enabled INTEGER
       );
CREATE TABLE
       admin_servers (
		    Id INTEGER PRIMARY KEY, 
			Name TEXT, 
			Host TEXT,
		    Port INTEGER,
		    Enabled INTEGER
       );
CREATE TABLE
       admin_ssh_keys (
			Id INTEGER PRIMARY KEY, 
			User TEXT, 
			Key TEXT, 
			Type TEXT
		);
CREATE TABLE
       admin_ssh_keys_servers (
			Server_Id INTEGER,
       		Ssh_Key_Id INTEGER, 
			Enabled BOOLEAN,
			FOREIGN KEY(Server_Id) REFERENCES admin_servers(Id),
			FOREIGN KEY(Ssh_Key_Id) REFERENCES admin_ssh_keys(Id)
     ) ;
COMMIT;
