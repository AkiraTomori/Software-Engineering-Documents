//Oracle

	Connection connection = null;
    try {
        // Load the JDBC driver
        String driverName = "oracle.jdbc.driver.OracleDriver";
        Class.forName(driverName);
    
        // Create a connection to the database
        String serverName = "127.0.0.1";
        String portNumber = "1521";
        String sid = "mydatabase";
        String url = null;
		url = "jdbc:oracle:thin:@" + serverName + ":" + portNumber + ":" + sid;
        String username = "username";
        String password = "password";
        
        connection = DriverManager.getConnection(url, username, password);
        
	...
    } catch (ClassNotFoundException e) {
        // Could not find the database driver
    } catch (SQLException e) {
        // Could not connect to the database
    }


//MySQL
Connection connection = null;
    try {
        // Load the JDBC driver
        String driverName = "org.gjt.mm.mysql.Driver"; // MySQL MM JDBC driver
        Class.forName(driverName);
    
        // Create a connection to the database
        String serverName = "localhost";
        String mydatabase = "mydatabase";
        String url = "jdbc:mysql://" + serverName +  "/" + mydatabase; // a JDBC url
        String username = "username";
        String password = "password";
        connection = DriverManager.getConnection(url, username, password);
	//...
    } catch (ClassNotFoundException e) {
        // Could not find the database driver
    } catch (SQLException e) {
        // Could not connect to the database
    }


//access -driver, type 1

try
{
		Class.forName("sun.jdbc.odbc.JdbcOdbcDriver");
		con = DriverManager.getConnection("jdbc:odbc:sqldsn");
}
catch(Exception e)
{
}




//JDBC Driver for MS SQL Server 2005
try
           {
               	Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
            	con = DriverManager.getConnection("jdbc:sqlserver://localhost:1433;databaseName=TT;user=username;password=password");
				if(con!=null) 
               		System.out.println("Connection Successful!");
           }
           catch(Exception e)
           {
               JOptionPane.showMessageDialog(new JFrame(), e.getMessage(), "Error Message", JOptionPane.ERROR_MESSAGE);
               e.printStackTrace();
               System.out.println("Error Trace in getConnection() : " + e.getMessage());
           }

