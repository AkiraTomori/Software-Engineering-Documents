/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package javaapplication1;

/**
 *
 * @author ksg
 */
import java.io.*;

public class BufferedReader1
{
	public static void main(String args[])throws IOException
	{
		//char c;
		BufferedReader br = new BufferedReader(
                                new InputStreamReader(System.in, "utf8"));
                //BufferedReader br = new BufferedReader(new FileReader("a1.txt"));
		System.out.print("Enter a number:");
                    String str = br.readLine();
                    int iNum = Integer.parseInt(str);
                    System.out.println(iNum);
	
	}
}
