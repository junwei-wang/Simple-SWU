"""
" Filename:      SPEKE.sage
" Author:        Junwei Wang(wakemecn@gmail.com)
" Last Modified: 2013-11-14 20:23
" Description:   Implementation of Elliptic Curve
"""

attach "simple_swu.sage" 
attach "elliptic_curve.sage"
import hashlib

def setParamsSPEKE():
    """ Set the parameters of elliptic curve,
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
    return (p, a, b, (e_x, e_y))

def genRand(p, a, b, e, m):
    " Get a random element from GF(p) as 'a' and compute a*H(pw) "
    F = GF(p)
    rand = F.random_element(F)
    swuHash = simpleSWU(p, a, b, m)
    toSend = multiplication(p, a, b, e, swuHash, (Integer)(rand))
    return (rand, toSend)
  
def genKey(p, a, b, e, recv, rand):
    " Supoose recv = b*H(pw) and compute rand*recv "
    return multiplication(p, a, b, e, recv, (Integer)(rand))

def testSPEKE():
    p, a, b, e = setParamsSPEKE()
    F = GF(p)

    # hash the shared password into F_p by SHA224
    pw = "You should use strong password for security"
    hashObj = hashlib.sha224()
    hashObj.update(pw)
    hashObj.hexdigest()
    hashPw = F(int("0x" + hashObj.hexdigest(), 16)) 

    # For Alice
    randA, sendToB = genRand(p, a, b, e, hashPw)    
    # For Bob
    randB, sendToA = genRand(p, a, b, e, hashPw)    
    keyB = genKey(p, a, b, e, sendToB, randB)
     
    # For Alice
    keyA = genKey(p, a, b, e, sendToA, randA)

    print "Share a same key?:", keyA == keyB 
