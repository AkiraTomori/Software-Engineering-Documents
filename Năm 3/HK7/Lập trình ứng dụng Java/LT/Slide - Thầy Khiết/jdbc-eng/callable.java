CallableStatement cs;
try 
{
	cs = connection.prepareCall("{call myproc}");
	cs.execute();

} 
catch (SQLException e) 
{
	//.....
}

/////////////////////////////////////////////////////////////////////////
CallableStatement cs;
try 
{
	cs = connection.prepareCall("{call myproc(?)}");
	cs.setString(1, "AAAAAAAAAAAAAAAAAAA");
    
	cs.execute();
} 
catch (SQLException e) 
{
	//.....
}

/////////////////////////////////////////////////////////////////////////
CallableStatement cs;
try 
{
	cs = connection.prepareCall("{call storedproc(?)}");
    
	cs.registerOutParameter(1, Types.VARCHAR);
    
	cs.execute();
   	String outParam = cs.getString(1);

} 
catch (SQLException e) 
{
	//.....
}

/////////////////////////////////////////////////////////////////////////
CallableStatement cs;
try 
{
	cs = connection.prepareCall("{call storedproc(?, ?)}");
	cs.registerOutParameter(2, Types.VARCHAR);
	cs.setString(1, "a string");
    
	cs.execute();
	outParam = cs.getString(2);
} 
catch (SQLException e) 
{
	//.....
}
