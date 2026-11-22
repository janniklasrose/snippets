/* pi.c
 *
 * See https://stackoverflow.com/q/507819/
 *
 * Copyright (c) 2019 Jan N Rose
 */

#include <stdio.h>
#include <math.h>

int main(int argc, char **argv)
{
    // FLOATING-POINT PRECISION
    printf("Floating-point precision:\n");
    printf("True value of pi: 3.141592653589793238462643383279\n");
    // true 30 digits
    long double pi = 3.141592653589793238462643383279L;
    printf("(long double)pi = %.30Lf\n", pi);
    printf("(double)pi      = %.30f\n", (double)pi);
    printf("(float)pi       = %.30f\n", (float)pi);

    // TRIGONOMETRIC FUNCTIONS
    printf("\nTrigonometric functions:\n");
    printf("(long double)pi = %.30Lf\n", pi);
    // cos(pi/2) = 0
    long double pi_acos0 = 2.0L*acos(0.0L);
    printf("2.0L*acos(0.0L) = %.30Lf\n", pi_acos0);
    // cos(pi) = -1
    long double pi_acosm1 = acos(-1.0L);
    printf("acos(-1.0L)     = %.30Lf\n", pi_acosm1);
    // tan(pi/4) = 1
    long double pi_atan1 = 4.0L*atan(1.0L);
    printf("4.0L*atan(1.0L) = %.30Lf\n", pi_atan1);

    // END
    return 0;
}
