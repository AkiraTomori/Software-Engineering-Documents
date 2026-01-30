/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package javaapplication1;

/**
 *
 * @author SONY
 */

class TooHotException extends Exception
{
    public String toString()
    {
        return "The temperature is too hot";
    }
}

class TooColdException extends Exception
{
    public String toString()
    {
        return "The temperature is too cold";
    }
}

public class Demo2 {
    public static void boilwater(int temperature) throws TooHotException,TooColdException
    {
        if (temperature > 200)
            throw new TooHotException();
        if (temperature < 10)
            throw new TooColdException();
        System.out.println("The water now is " + temperature);
    }
    
    public static void main(String args[])
    { 
        int temp = 300;
        try
        {
            boilwater(temp);
        }
        catch (Exception he)
        {
            System.out.println("Error:" + he.toString());
        }
    }
}
