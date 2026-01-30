import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;

public class ReadFile 
{
	public static void main(String args[]) throws IOException
	{
		int i;
		FileInputStream fin;
		try 
		{
			fin = new FileInputStream("b.txt");
		} 
		catch(FileNotFoundException exc) 
		{
			System.out.println("File Not Found");
			return;
		}
		do 
		{
			i = fin.read();
			if(i != -1) 
				System.out.print(i+" ");
		} 
		while(i != -1);
		
		fin.close();
	}
}
