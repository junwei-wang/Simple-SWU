"""
" Filename:      elliptic_curve.sage
" Author:        Junwei Wang(wakemecn@gmail.com)
" Last Modified: 2013-11-14 20:19
" Description:   Implementation of Elliptic Curve
"""

def setParamsEC():
    """ Set the parameters of elliptic curve, only used in test:
        - p is the order of the finite field,
        - a and b is the coefficient of elliptic curve, i.e., y^2 = x^3+a*x+b,
        - n is the order of the group on the elliptic curve,
        - (G_x, G_y) is the generator of the group,
        - (e_x, e_y) is the identity element of the group,  
        - and (e_x, e_y) = n * (G_x, G_y).
    """
    p = 6277101735386680763835789423207666416083908700390324961279
    F = GF(p)
    a = F(-3)
    b = F(0x64210519e59c80e70fa7e9ab72243049feb8deecc146b9b1)
    n = 6277101735386680763835789423176059013767194773182842284081
    G_x = F(0x188da80eb03090f67cbf20eb43a18800f4ff0afd82ff1012)
    G_y = F(0x07192b95ffc8da78631011ed6b24cdd573f977a11e794811)
    e_x = F(5369744403678710563432458361254544170966096384586764429448)
    e_y = F(847867355597609724085134516292412287829582146117606403156)
    return (p, a, b, n, (G_x, G_y), (e_x, e_y))

def isOnEC(p, a, b, P):
    " Test whether point P on y^2 = x^3 + a*x + b % p, and exit if not "
    x = P[0]
    y = P[1]
    if y^2 == x^3 + a*x + b:
        return True

    return False

def equalsToIdentity(p, a, b, e, P):
    " Test whether point P on EC equals to the identity element " 
    if not isOnEC(p, a, b, P):
        print "Point is not on elliptic curve." 
        exit()

    return e[0] == P[0] and e[1] == P[1]

def addition(p, a, b, e, P, Q):
    " Compute P + Q on y^2 = x^3 + a*x + b % p "
    if (not isOnEC(p, a, b, P)) or (not isOnEC(p, a, b, Q)):
        print "One of the points is not on elliptic curve." 
        exit()

    if equalsToIdentity(p, a, b, e, P): # e * Q = Q
        return Q
    if equalsToIdentity(p, a, b, e, Q): # P * e = P
        return P

    x1 = P[0]
    y1 = P[1]
    x2 = Q[0]
    y2 = Q[1]
    if x1 == x2:      # if P = Q or P = -Q
        if y1 == -y2: # if P = -Q
            return e
        var_lambda = (3 * x1^2 + a) // (2 * y1)
    else:             # if P != Q and P != -Q
        var_lambda = (y2 - y1) // (x2 - x1)
    
    x3 = var_lambda^2 - x1 - x2
    y3 = var_lambda * (x1 - x3) - y1

    return (x3, y3)

def multiplication(p, a, b, e, P, d):
    " Compute d*P on y^2 = x^3 + a*x + b % p "
    if not isOnEC(p, a, b, P):
        print "Point is not on elliptic curve." 
        exit()
   
    if d < 0:
	print "d should be at least 0"
	exit()

    if d == 0 or equalsToIdentity(p, a, b, e, P): # 0*P = e; e^d = e 
        return e
    
    Q = P
    dBits = d.bits()
  # dBits = (d%n).bits();
    dBits.pop()
    for i in range(d.nbits() - 1):                # double andadd algorithm
	Q = addition(p, a, b, e, Q, Q)
        if dBits.pop() == 1:
	    Q = addition(p, a, b, e, Q, P)
    
    return Q

def inverse(p, a, b, e, P):
    " Compute -P on y^2 = x^3 + a*x + b % p "
    if not isOnEC(p, a, b, P):
        print "Point is not on elliptic curve." 
        exit()

    if equalsToIdentity(p, a, b, e, P):           # -e = e
        return e

    return (P[0], -P[1])
  
    
def testEC():
    p, a, b, n, G, e = setParamsEC()

    print "G == G + e == e + G == (n+1) * G == 1 * G:", G\
       == addition(p, a, b, e, G, e)\
       == addition(p, a, b, e, e, G) == multiplication(p, a, b, e, G, n+1)
    print "e == e + e = -e == 1 * e = 0 * G = n * G == G + (-G):", e\
       == addition(p, a, b, e, e, e)\
       == inverse(p, a, b, e, e) == multiplication(p, a, b, e, e, 1)\
       == multiplication(p, a, b, e, G, 0) == multiplication(p, a, b, e, G, n)\
       == addition(p, a, b, e, G, inverse(p, a, b, e, G))
    print "G + 2*G == 3 * G = (n+3) * G:",\
       addition(p, a, b, e, G, multiplication(p, a, b, e, G, 2))\
       == multiplication(p, a, b, e, G, 3)\
       == multiplication(p, a, b, e, G, n+3)
    print "-G == (n-1) * G:", inverse(p, a, b, e, G)\
       == multiplication(p, a, b, e, G, (n-1))

