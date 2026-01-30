import java.io.*;

public class BufferedReader2
{
	public static void main(String args[])throws IOException
	{
		BufferedReader br = new BufferedReader(new FileReader("a1.txt"));
		String str ;
		while (true)
		{
			str = br.readLine();
			if (str==null)
				break;
			System.out.println(str);	
		}
	}
}
