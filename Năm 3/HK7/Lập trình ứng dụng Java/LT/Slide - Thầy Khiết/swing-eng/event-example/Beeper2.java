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

class NewClass implements ActionListener
{
	public void actionPerformed(ActionEvent e)
	{
		//................
		String str = e.getActionCommand();
		if (str.equals("button1"))
		{
			//.....................
			System.out.println("Process for button1");
		}
		else
			if (str.equals("button2"))
			{
				//......................
				System.out.println("Process for button2");
			}
	}
}


public class Beeper2 extends JPanel 
                    implements ActionListener {
    JButton button;
    JButton button2;

    public Beeper2() {
        super(new BorderLayout());
        button = new JButton("Click Me Now");
        
        button.setActionCommand("button1");
        
        button.setPreferredSize(new Dimension(200, 80));
        
        add(button, BorderLayout.CENTER);
        
        button.addActionListener(this);
        
        NewClass obj = new NewClass();
        button.addActionListener(obj);
        
        button2 = new JButton("Button 2");
        button2.setActionCommand("button2");
        add(button2, BorderLayout.PAGE_END);
        
        button2.addActionListener(obj);
       
     
    }

    public void actionPerformed(ActionEvent e) {
    	//.......................
        Toolkit.getDefaultToolkit().beep();
        System.out.println("Just Beep !");
       
    }

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
        JComponent newContentPane = new Beeper2();
        newContentPane.setOpaque(true); //content panes must be opaque
        frame.setContentPane(newContentPane);

        //Display the window.
        frame.pack();
        frame.setVisible(true);
    }

    public static void main(String[] args) {
        //Schedule a job for the event-dispatching thread:
        //creating and showing this application's GUI.
        //javax.swing.SwingUtilities.invokeLater(new Runnable() {
        //    public void run() {
                createAndShowGUI();
        //    }
        //});
    }
}
