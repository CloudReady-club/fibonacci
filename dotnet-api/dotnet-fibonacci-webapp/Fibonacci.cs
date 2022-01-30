using System.Numerics;
public class Fibonacci{

public static BigInteger Run(){
            var a = new BigInteger(0);
            var b = new BigInteger(1);
            BigInteger tmp;

       	    // Initialize limit as 10^999, the smallest integer with 100 000 digits.
            var limit = BigInteger.Pow(10,9999);

            while(BigInteger.Compare(a,limit) < 0){
                a = BigInteger.Add(a,b);
                tmp = a;
                a = b;
                b = tmp;
            }
            return a;

    }
}