"""
" Filename:      elliptic_curve.sage
" Author:        Junwei Wang(wakemecn@gmail.com)
" Last Modified: 2013-11-13 14:55
" Description:   Implementation of Elliptic Curve
"""

def setParams():
    """ set prime p, and choose two elemnts a, b from GF(P) """
    p = 6277101735386680763835789423207666416083908700390324961279
    F = GF(p)
    a = F(-3)
    b = F(0x64210519e59c80e70fa7e9ab72243049feb8deecc146b9b1)
    n = 6277101735386680763835789423176059013767194773182842284081
    G_x = 0x188da80eb03090f67cbf20eb43a18800f4ff0afd82ff1012
    G_y = 0x07192b95ffc8da78631011ed6b24cdd573f977a11e794811
    return (p, a, b, n, G_x, G_y)

def isOnEC(p, a, b, x, y):
    """ test whether point (x, y) on y^2 = x^3 + a*x + b % p"""
    return y^2 % p == x^3 + a*x + b

def isOnECTest(p, a, b, x, y):
    """ test whether point (x, y) on y^2 = x^3 + a*x + b % p with output """
    print "x = ", x, "\ny = ", y, "\n(x, y) on EC?:"
    return y^2 % p == x^3 + a*x + b

def addition(p, a, b, x1, y1, x2, y2):
    """ compute (x1, y1) + (x2, y2) on y^2 = x^3 + a*x + b % p """
    if not isOnEC(p, a, b, x1, y1):
	print "Point P is not on the elliptic curve y^2 = x^3 + ", a,\
	      "*x + ", b, " mod ", p
	exit()
    if not isOnEC(p, a, b, x2, y2):
	print "Point Q is not on the elliptic curve y^2 = x^3 + ", a,\
	      "*x + ", b, " mod ", p
        exit()
    
    if x1 == x2: # if P != Q and P != -Q
        lambda0 = (3 * x1^2 + a) // (2 * y1)
    else:
        lambda0 = (y2 - y1) // (x2 - x1)
    
    x3 = lambda0^2 - x1 - x2
    y3 = lambda0 * (x1 - x3) - y1

    return (x3, y3)

def multiple(p, a, b, x, y, d):
    """ compute d*(x, y) on y^2 = x^3 + a*x + b % p """
    if not isOnEC(p, a, b, x, y):
	print "Point P is not on the elliptic curve y^2 = x^3 + ", a,\
	      "*x + ", b, " mod ", p
	exit()
    if d <= 1:
	print "d should be bigger than 1"
	exit()

    x1 = x
    y1 = y
    dBits = d.bits()
    dBits.pop()
    for i in range(0, d.nbits() - 1):
	x1, y1 = addition(p, a, b, x1, y1, x1, y1)
        if dBits.pop() == 1:
	    x1, y1 = addition(p, a, b, x1, y1, x, y)
    
    return (x1, y1)

def inverse(p, a, b, x, y):
    """ compute -(x, y) on y^2 = x^3 + a*x + b % p """
    if not isOnEC(p, a, b, x, y):
    if y != x^3 + a*x + b: 
	print "Point P is not on the elliptic curve y^2 = x^3 + ", a,\
	      "*x + ", b, " mod ", p
        exit()
    
    return (x, -y)

def testEC():
    p, a, b, n, G_x, G_y = setParams()
    print isOnECTest(p, a, b, G_x, G_y), "\n"

    #2
    x, y = addition(p, a, b, G_x, G_y, G_x, G_y)
    print isOnECTest(p, a, b, x, y), "\n"

    x1, y1 = multiple(p, a, b, G_x, G_y, n-1)
    print isOnECTest(p, a, b, x1, y1), "\n"
