" written by Jean-Sébastien Coron "
def genParams(k=160):
  p=1
  while (p % 4)==1:
  p=random_prime(2^k)
  F=GF(p)
  a=F.random_element()
  b=F.random_element()
  return (p,a,b)

def simpleSWU(p,a,b,t):
  alpha=-t^2
  x2=-b/a*(1+1/(alpha^2+alpha))
  x3=alpha*x2
  h2=x2^3+a*x2+b
  h3=x3^3+a*x3+b
  if is_square(h2):
    return (x2,h2^((p+1)//4))
  else:
    return (x3,h3^((p+1)//4))

def testSimpleSWU():
  p,a,b=genParams()
  t=GF(p).random_element()
  x,y=simpleSWU(p,a,b,t)
  print "p=",p,"\na=",a,"\nb=",b,"\nx=",x,"\ny=",y 
  print "y^2==x^3+ax+b:",y^2==x^3+a*x+b
