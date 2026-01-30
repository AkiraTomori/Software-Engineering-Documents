import java.awt.*;
import javax.swing.*;

public class GridLayoutDemo 
{
    public final static boolean RIGHT_TO_LEFT = false;

    public static void addComponentsToPane(Container pane) 
    {
        if (RIGHT_TO_LEFT) 
        {
            pane.setComponentOrientation(
                ComponentOrientation.RIGHT_TO_LEFT);
        }

        pane.setLayout(new GridLayout(1,5));

        pane.add(new JButton("Button 1"));
        pane.add(new JButton("Button 2"));
        pane.add(new JButton("Button 3"));
        pane.add(new JButton("Long-Named Button 4"));
        pane.add(new JButton("5"));
    }

    private static void createAndShowGUI() 
    {
        //JFrame.setDefaultLookAndFeelDecorated(true);
        JFrame frame = new JFrame("GridLayoutDemo");
        frame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);

        addComponentsToPane(frame.getContentPane());

        frame.pack();
        frame.setVisible(true);
    }

    public static void main(String[] args) 
    {
        javax.swing.SwingUtilities.invokeLater(new Runnable() 
        {
            public void run()
            {
                createAndShowGUI();
            }
        });
    }
}
