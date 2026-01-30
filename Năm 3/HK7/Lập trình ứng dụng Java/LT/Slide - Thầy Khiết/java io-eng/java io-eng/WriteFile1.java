import java.io.*;

public class WriteFile1
{
	public static void main(String args[]) throws IOException
	{
		FileOutputStream fout;
		
		fout = new FileOutputStream("b.txt");
		
		try 
		{
			//fout.write(1278);
			int i;
			for (i=0;i<100;i++)
			{
				fout.write(i);
			}
			
		} 
		catch(IOException exc) 
		{
			System.out.println("Error occur when write to file");
		}
		fout.flush();
		fout.close();
	}
}
