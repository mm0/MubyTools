BEGIN TRANSACTION;
CREATE TABLE
       admin_categories (
		Category_Id INTEGER PRIMARY KEY,
       Title TEXT, Description TEXT
     ) ;
CREATE TABLE
       admin_command_input_types (
		   Input_Type_Id INTEGER PRIMARY KEY, 
			Text TEXT, 
			Description TEXT
       );
CREATE TABLE admin_command_types (
		Command_Type_Id INTEGER PRIMARY KEY,
		Name TEXT,
		Description TEXT);
CREATE TABLE
       admin_commands (
			Command_Id INTEGER PRIMARY KEY,
		    Category_Id INTEGER,
			Command_Type_Id INTEGER,
		    Command TEXT, 
			Title TEXT, 
			Description TEXT, 
			Input_Type_Id INTEGER,
			Inputs INTEGER, 
		    Optional_Inputs INTEGER, 
			Shortcut TEXT, 
			FOREIGN KEY(Command_Type_Id) REFERENCES admin_command_types(Command_Type_Id), 
			FOREIGN KEY(Category_Id) REFERENCES admin_categories(Category_Id), 
			FOREIGN KEY(Input_Type_Id) REFERENCES admin_command_input_types(Input_Type_Id) 
       );
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
