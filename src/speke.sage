"""
" Filename:      speke.sage
" Author:        Junwei Wang(wakemecn@gmail.com)
" Last Modified: 2013-11-13 14:57
" Description:   Implementation of Elliptic Curve
"""

def setParams():
    """ set prime p, and choose two elemnts a, b from GF(p) """
    p = 6277101735386680763835789423207666416083908700390324961279
    F = GF(p)
    a = F(-3)
    b = F(0x64210519e59c80e70fa7e9ab72243049feb8deecc146b9b1)
    return (p, a, b)

def genRandom(p, a, b, pw):
    """ get a random element from GF(p) as 'a' and compute a*H(pw) """
    F = GF(p)
    rand = F.random_element(F)
    pwHash = simpleSWU(p, a, b, pw)
    pwHashTimesRand = multiple(p, a, b, pwHash[0], pwHash[1], (Integer)(rand))
    return (rand, pwHashTimesRand)
  
def computeKey(p, a, b, recv, rand):
    """ supoose recv = b*H(pw) and compute a*(b*H(pw)) """
    return multiple(p, a, b, recv[0], recv[1], (Integer)(rand))

def testSpeke():
    p, a, b = setParams()
    F = GF(p)
    pw = F.random_element(F)

    # For Alice
    randA, sendToB = genRandom(p, a, b, pw)    
    print "randA = ", randA
   
    # For Bob
    randB, sendToA = genRandom(p, a, b, pw)    
    print "randB = ", randB
    keyB = computeKey(p, a, b, sendToB, randB)
     
    # For Alice
    keyA = computeKey(p, a, b, sendToA, randA)

    print "Share a same key?: ", keyA == keyB 
