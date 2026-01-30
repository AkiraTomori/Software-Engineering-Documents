import java.io.*;

public class ReadWriteData 
{
	public static void main(String args[]) throws IOException 
	{
		int iVal = 25678;
		double dVal = -67.76;
		boolean bVal = true;
		
		DataOutputStream dos;
		try 
		{
			dos=new DataOutputStream(
					new FileOutputStream("a.txt"));
		}
		catch(IOException exc) 
		{
			System.out.println("Error open file !");
			return;
		}
		
		try 
		{
			dos.writeInt(iVal);
			dos.writeDouble(dVal);
			dos.writeBoolean(bVal);
		}
		catch(IOException exc) 
		{
			System.out.println("Error write file.");
		}
		dos.close();
		
		/*
		
		
		int iVal = 0;
		double dVal = 0;
		boolean bVal = false;
		DataInputStream dis;
		
		try {
			dis = new DataInputStream(new FileInputStream("a.txt"));
		}
		catch(IOException exc) 
		{
			System.out.println("Error open file.");
			return;
		}
		try 
		{
			iVal = dis.readInt();
			System.out.println("Reading " + iVal);
			dVal = dis.readDouble();
			System.out.println("Reading " + dVal);
		
			
			bVal = dis.readBoolean();
			System.out.println("Reading " + bVal);
		}
		catch(IOException exc) 
		{
			System.out.println("Error reading file.");
		}
		
		dis.close();
		*/
		
	}
}
