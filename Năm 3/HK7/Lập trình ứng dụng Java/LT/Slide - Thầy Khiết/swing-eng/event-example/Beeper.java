/*
 * Beeper.java is a 1.4 example that requires
 * no other files.
 */

import java.awt.*;
import javax.swing.JFrame;
import javax.swing.JPanel;
import javax.swing.JButton;
import javax.swing.JComponent;

import java.awt.Toolkit;
import java.awt.BorderLayout;
import java.awt.event.ActionListener;
import java.awt.event.ActionEvent;

class AnotherClass implements ActionListener
{
	public void actionPerformed(ActionEvent ae)
	{
		System.out.println("From Another Class!");
	}
}

class MyClass implements ActionListener
{
	MyClass(){}
	
	public void actionPerformed(ActionEvent e)
	{
		String strActionCommand = e.getActionCommand();
		if (strActionCommand.equals("OK"))
		{
		
			Toolkit.getDefaultToolkit().beep();
	        System.out.println("BEEP");
	    }
        else
        	System.out.println("Hello!");
	}
}



public class Beeper extends JPanel{
								// implements ActionListener{
    JButton button;

    public Beeper() {
        super(new BorderLayout());
        
        button = new JButton("OK");
        button.setPreferredSize(new Dimension(200, 80));
        add(button, BorderLayout.CENTER);
        button.setActionCommand("OK");
        
        MyClass mc = new MyClass();
        button.addActionListener(mc);
        button.addActionListener(new AnotherClass());
        
        JButton button2 = new JButton("Hello");
        add(button2,BorderLayout.LINE_END);
        button2.setActionCommand("HELLO");
        
        button2.addActionListener(mc);
        
    }

/*
    public void actionPerformed(ActionEvent e) {
        Toolkit.getDefaultToolkit().beep();
        System.out.println("BEEP");
    }
*/
    /**
     * Create the GUI and show it.  For thread safety,
     * this method should be invoked from the
     * event-dispatching thread.
     */
    private static void createAndShowGUI() {
        //Make sure we have nice window decorations.
        JFrame.setDefaultLookAndFeelDecorated(true);

        //Create and set up the window.
        JFrame frame = new JFrame("Beeper");
        frame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);

        //Create and set up the content pane.
        JComponent newContentPane = new Beeper();
        
        newContentPane.setOpaque(true); //content panes must be opaque
        frame.setContentPane(newContentPane);

        //Display the window.
        frame.pack();
        frame.setVisible(true);
    }

    public static void main(String[] args) {
        //Schedule a job for the event-dispatching thread:
        //creating and showing this application's GUI.
        javax.swing.SwingUtilities.invokeLater(new Runnable() {
            public void run() {
                createAndShowGUI();
            }
        });
     
    }
}
