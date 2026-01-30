import java.io.*;

public class FileReader2
{
	public static void main(String args[])throws IOException
	{
		FileReader fr = new FileReader("a.txt");
		
		FileWriter fw= new FileWriter("d.txt");
		
		while (true)
		{
			int i = fr.read();
			if (i==-1)
				break;
			fw.write(i);
		}
		fr.close();
		fw.close();
	}
}
