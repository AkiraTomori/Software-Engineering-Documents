import java.io.*;

public class FileWriter1
{
	public static void main(String args[])throws IOException 
	{
		String str;
		FileWriter fw;
		int i;
		try 
		{
			fw = new FileWriter("a1.txt");
		}
		catch(IOException exc) 
		{
			System.out.println("Error opening file");
			return ;
		}
		
		System.out.println("Writting to file");
		
		for (i = 0;i<=10; i++)
		{
			str = "Xin chào : " + i;
			str = str + "\r\n"; 
			fw.write(str);
		} 
		
		fw.close();
		System.out.println("Finished ! Check your file !");
	}
}
