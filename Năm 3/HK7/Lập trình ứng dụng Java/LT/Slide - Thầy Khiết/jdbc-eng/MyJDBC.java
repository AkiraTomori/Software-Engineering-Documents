import java.sql.*;

public class MyJDBC
{
	public static void main(String args[])
	{
		Connection con = null;
		
		try
		{
		
			/*
			Class.forName("sun.jdbc.odbc.JdbcOdbcDriver");
			con = DriverManager.getConnection("jdbc:odbc:ProductDS");
			*/
			Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
            con = DriverManager.getConnection("jdbc:sqlserver://localhost:1433;databaseName=Product;user=sa;password=password");
			
			Statement st = con.createStatement();
			
			//String strsql = "select * from product";
			String strsql = "insert into product(productid, productname, productdescription) values (3,'RAM','1066MHz')";
			
			//ResultSet rs = st.executeQuery(strsql);
			int iAffectedRecord = st.executeUpdate(strsql);
			
			/*
			while (rs.next())
			{
				int iID = rs.getInt("ProductID");
				String strName = rs.getString(2);
				String strDesc = rs.getString(3);
				
				System.out.println("ID: " + iID + " - Name: " + strName + " - Desc: " + strDesc);
				
			}*/
			
			con.close();
		}
		catch (Exception ex){
			System.out.println("Error: " + ex.getMessage());
		}
	}
}