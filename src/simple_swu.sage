"""
" Filename:      simple_swu.sage
" Author:        Junwei Wang(wakemecn@gmail.com)
" Last Modified: 2013-11-12 19:07
" Description:   Implementation of simple SWU
"""

def genParams(k = 160):
    """ Generate k-bit prime p, and choose to random elemnts from GF(P) """
    p = 1
    while (p % 4) == 1:
        p = random_prime(2^k)
    F = GF(p)
    a = F.random_element()
    b = F.random_element()
    return (p, a, b)

def simpleSWU(p, a, b, t):
    """ Hash t from GF(p) to point on elliptic curve y^2 = x^3 + ax + b """
    alpha = -t^2
    x2 = -(b / a) * (1 + 1/(alpha^2+alpha))
    x3 = alpha * x2
    h2 = x2^3 + a*x2 + b
    h3 = x3^3 + a*x3 + b

    """
    Let tmp = h2^((p-3)/4)
    then h2^((p-1)/2) = tmp^2*h2, which is used to test whether h2 is a square
         h2^((p+1)/4) = tmp*h2, which is the square root of h2
    """
    tmp = h2 ^ ((p - 3) // 4) 
    if tmp^2 * h2 == 1:
        return (x2, tmp * h2 )
    else:
        return (x3, h3 ^ ((p+1)//4))

def testSimpleSWU():
    p, a, b = genParams()
    t = GF(p).random_element()
    x, y = simpleSWU(p, a, b, t)
    print "p = ", p, "\na = ", a, "\nb = ", b, "\nx = ", x, "\ny = ", y
    print "y^2 == x^3+ax+b:",y^2 == x^3+a*x+b
