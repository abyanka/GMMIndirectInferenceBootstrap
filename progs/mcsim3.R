# Monte-Carlo-Simulation 3: Die Verteilung des Varianzsch�tzers in einem GARCH-Prozess
library(MASS)

# Parameter festlegen
n <- 1000
R <- 2000
omega <- 0.1
alpha <- 0.1
beta <- 0.85
sigma2 <- 2


##################################################
# I. Verteilung f�r einfache Stichprobe aus N(0,2)
##################################################

# Vektor f�r Varianzsch�tzer anlegen
v <- rep(NA,R)

for(r in 1:R)
  {
  x <- rnorm(n,mean=0,sd=sqrt(2))
  sigma2hat <- var(x)
  v[r] <- (n-1)*sigma2hat/sigma2
  }

truehist(v) # Histogramm der normierten Sch�tzwerte
d <- seq(min(v),max(v),length=300) 
lines(d,dchisq(d,df=n-1),lwd=2) # Erg�nzen der chisq-Dichte auf Gitterpunkten d


##################################
# II. Verteilung f�r GARCH-Prozess
##################################

# Vektor f�r Varianzsch�tzer anlegen
v <- rep(NA,R)

for(r in 1:R)
  {
  # Generieren eines GARCH(1,1)-Prozesses
  x <- rep(NA,n)
  x[1] <- rnorm(1,mean=0,sd=sqrt(2)) # Startwert f�r x
  s2cond <- 2 # Startwert f�r bedingte Varianz
  for(i in 2:n)
    {
    x[i] <- rnorm(1,mean=0,sd=sqrt(s2cond))
    s2cond <- omega+alpha*x[i-1]^2+beta*s2cond
    }
  sigma2hat <- var(x)
  v[r] <- (n-1)*sigma2hat/sigma2
  }

truehist(v,ylim=c(0,0.01)) 
# Mit ylim wird die Ausdehnung in y-Richtung vorgeschrieben,
# damit sp�ter noch Platz ist f�r die Dichte der chisq-Verteilung
d <- seq(min(v),max(v),length=500) 
lines(d,dchisq(d,df=n-1),lwd=2)
