curve <- function(x) {
    if (x <= 0) {
        return (0)
    } else if ((x > 0) && (x <= 80)) {
        return( 80 * sin((2 * pi )/320 * (x) ))
    } else if (x <= 160) { 
        return (80 - (x - 80))
    } else {
        return(0)
    }
}


sumProd <- sum(sapply(seq(0,80,.1), \(x) x * curve(x)))
sumWeight <- sum(sapply(seq(0,80,.1), curve))

f <- sum(sapply(seq(0,80,.1), \(x) curve(x)))/length(seq(0,80,.1))
t <- sumProd/sumWeight
