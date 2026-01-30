/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package javaapplication1;

import java.io.*;

public class BufferedInputStream1 {
	public static void main(String[] args) {
		try
		{
                    
                        BufferedInputStream bin = new BufferedInputStream(
                                                    new FileInputStream("b.dat"));
                        BufferedOutputStream bout = new BufferedOutputStream(
                                                        new FileOutputStream("b1.dat"));
			while (true) {
				int datum = bin.read();

				if (datum == -1)
					break;
				bout.write(datum*2);
			}
			bout.flush();
                        bin.close();
                        bout.close();
		}
		catch (Exception e) {
			e.printStackTrace();
		}
	}
}
