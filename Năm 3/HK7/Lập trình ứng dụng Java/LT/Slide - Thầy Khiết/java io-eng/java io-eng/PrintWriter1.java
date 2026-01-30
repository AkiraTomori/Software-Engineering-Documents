import java.io.*;

public class PrintWriter1 {
  public static void main(String args[])
  {
  	try
  	{
  		File fOut = new File("a1.txt");
	    PrintWriter out = new PrintWriter(fOut);
	
	    out.write("...123");
	    	    
	    out.println("456789");
	
		double d=1.23;
		out.println(d);
		out.printf("%d %c\n",49,49);
	    
	    out.close();
  	}
  	catch (IOException ioe)
  	{
  		System.out.println(ioe.getMessage());
  	}
    
  }
}
