/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package javaapplication1;

/**
 *
 * @author SONY
 */


public class Demo1
{
    public static int calculate(int a, int b)
    {
        int ret = 0;
        try
        {
            ret = a/b;
        }
        catch (ArithmeticException ae)
        {
            //System.out.println(ae.toString());
            throw ae;
        }
        return ret;
    }
    
    public static void main(String args[])
    {  
        int a = 5;
        int b = 0;
        try
        {
            int ret = calculate(a,b);
            System.out.println(ret);
        }
        catch (ArithmeticException ae)
        {
            System.out.println("Division by zero!");
        }
        System.out.println("Finished !");
    }
}
