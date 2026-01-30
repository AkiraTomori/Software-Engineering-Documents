import java.io.*;

class KeyboardInput {
	public static void main(String args[]) throws IOException {
		
		byte data[] = new byte[10];
		System.out.println("Enter some characters.");
		System.in.read(data);
		System.out.print("You entered: ");
		for(int i=0; i < data.length; i++)
			System.out.print((char)data[i] + " ");
		System.out.println();
	}
}
