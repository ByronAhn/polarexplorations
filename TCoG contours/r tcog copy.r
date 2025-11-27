# dome <- function(x) {
#     if (x <= 0) {
#         return (0)
#     } else if ((x > 0) && (x <= 80)) {
#         return( 80 * sin((2 * pi )/320 * (x) ))
#     } else if (x <= 160) { 
#         return (80 - (x - 80))
#     } else {
#         return(0)
#     }
# }


# scoop <- function(x) {
#     if (x <= 0) {
#         return (0)
#     } else if ((x > 0) && (x < 80)) {
#         return(80 * sin((2 * pi )/320 * (x - 80) ) + 80)
#     } else if (x <= 160) { 
#         return (80 - (x - 80))
#     } else {
#         return(0)
#     }
# }


# sla <- function(x) {
#     if (x <= 0) {
#         return (0)
#     } else if ((x > 0) && (x <= 80)) {
#         return(x)
#     } else if (x <= 160) { 
#         return (80 - (x - 80))
#     } else {
#         return(0)
#     }
# }


# ### DOME
# # tcogF ( = mean f0 ):
# tcogF <- sum(sapply(seq(0,80,.1), \(x) dome(x)))/length(seq(0,80,.1))
# # sumProd
# sumProd <- sum(sapply(seq(0,80,.1), \(x) x * dome(x)))
# # sumWeight
# sumWeight <- sum(sapply(seq(0,80,.1), dome))
# # tCogT
# tcogT <- sumProd/sumWeight
# cat(sprintf("Dome:\n  TCoG for f0 = %f\n  TCoG for time = %f\n\n", tcogF, tcogT))

# ### SLA
# # tcogF ( = mean f0 ):
# tcogF <- sum(sapply(seq(0,80,.1), \(x) sla(x)))/length(seq(0,80,.1))
# # sumProd
# sumProd <- sum(sapply(seq(0,80,.1), \(x) x * sla(x)))
# # sumWeight
# sumWeight <- sum(sapply(seq(0,80,.1), sla))
# # tCogT
# tcogT <- sumProd/sumWeight
# cat(sprintf("SLA:\n  TCoG for f0 = %f\n  TCoG for time = %f\n\n", tcogF, tcogT))

# ### SCOOP
# # tcogF ( = mean f0 ):
# tcogF <- sum(sapply(seq(0,80,.1), \(x) scoop(x)))/length(seq(0,80,.1))
# # sumProd
# sumProd <- sum(sapply(seq(0,80,.1), \(x) x * scoop(x)))
# # sumWeight
# sumWeight <- sum(sapply(seq(0,80,.1), scoop))
# # tCogT
# tcogT <- sumProd/sumWeight
# cat(sprintf("Scoop:\n  TCoG for f0 = %f\n  TCoG for time = %f\n\n", tcogF, tcogT))


# # sum(sapply(seq(0,80,.1), \(x) dome(x) * x))/(sum(sapply(seq(0,80,.1), dome)))
# # sum(sapply(seq(0,80,.1), \(x) sla(x) * x))/(sum(sapply(seq(0,80,.1), sla)))
# # sum(sapply(seq(0,80,.1), \(x) scoop(x) * x))/(sum(sapply(seq(0,80,.1), scoop)))


# # #let sineWavey(x, amplitude: 40, period: 10, phaseShift: 10, verticalShift: 40, widthFactor: 3) = {
# #   amplitude * (calc.sin((1/period) * x/widthFactor - phaseShift)) + verticalShift
# # }

# library(ggplot2)
# library(tidyverse)



# # dome
# # sineWavey <- function(x, xShift=0, midline=0) {
# #     (0.5 + sin((x-xShift)*pi-pi/2) / 2)^(( 2 * (1 - (x-xShift)))^1) + midline
# # }

# domy <- function(x, A, B, C, D) {
#     A * sin(B * (x-C)) + D
# }

# domedata <- tibble(
#     x = seq(
#             from = -.50,
#             to = 1.5, 
#             length.out = 200
#     ),
#     y = domy(x, A=0.533079, B=3.36035, C=0.428144, D=0.513009),
#     label = 1:length(x)
# )

# ggplot(scoopdata, aes(x=x,y=y)) +
# xlim(0, 1) +
# ylim(0, 1) +
# geom_line(color= "red", size = 3) + 
# theme(aspect.ratio=1)



# # STARTING OVER

# # general <- function(x, A, B, C, D, E, F, shift=0){
#     # (A * (B + sin( ((x-shift)*C) / D ) )^E ) + F
# # }

# # dome  <- function(x){general(x, A=1, P=2.25, S=-0.369111, K=-0.159175, M=0)}
# # dome  <- function(x){general(x, A=1, P=4, S=-0.369111, K=-0.159175, M=0, shift=-.25)}
# # scoop  <- function(x){general(x, A=0.984, P=1.8, S=-15, K=0.3, M=.01565, shift=.1)}
# scoop  <- function(x) {
#     ifelse(
#         x <= 0.98, 
#         ifelse(
#             x<=0,
#             0.0025,
#             general(x, A=3.89*10^13, B=4.23007, C=8.50957, D=-5.59385, E=-26.68888, F=0, shift=-.03)
#         ), 
#         sin(1.5*x - 1.5 + pi/2)
#     )
# }
# dome  <- function(x) {
#     ifelse(
#         x <= 0.98, 
#         ifelse(
#             x<=0,
#             0.005,
#             general(x, A=0.242, B=0.555045, C=-.85, D=-0.637767, E=3.42145, F=-.1, shift=-.175)
#         ), 
#         sin(1.5*x - 1.5 + pi/2)
#     )
# }
# sla <- function(x){
#     ifelse(
#         x <=0,
#         0,
#         ifelse(
#             x<=1,
#             x,
#             1-(x-1)
#         )
#     )
# }

# ggplot() +
# xlim(-.2, 1.2) +
# ylim(0, 1) +
# # geom_line(color= "blue", size = 3, alpha=.8) +
# geom_function(fun = dome, color= "blue", size = 3, alpha=.8) +
# geom_point(data=data.frame(x=0.678688,y=0.539944), aes(x=x,y=y), color="blue", size=6) +
# geom_function(fun = scoop, color= "red", size = 3, alpha=.8) +
# geom_point(data=data.frame(x=0.811671,y=0.294934), aes(x=x,y=y), color="red", size=6) +
# geom_function(fun = sla, color= "black", size = 3, alpha=.5) +
# theme(aspect.ratio=1/1.4, panel.background=element_rect(fill="transparent")) 
# # # geom_rect(data=data.frame(xmin = 1, xmax = 2, ymin = 0, ymax = 1), aes(xmin = xmin, xmax = xmax, ymin = ymin, ymax = ymax), fill="black")
# # annotate("rect", xmin = 1, xmax = 1.2, ymin = 0, ymax = 1, alpha=0.6) +
# # annotate("rect", xmin = -.2, xmax = 0, ymin = 0, ymax = 1, alpha=0.6) +
# # geom_line(data=sladata, color= "black", size = 3, alpha=.5) +
# # geom_point(data=data.frame(x=0.666667,y=0.5), color="black", size=6)

library(ggplot2)
library(tidyverse)
options(tikzLatex = "/Library/TeX/texbin")
library(tikzDevice)

tcogf <- function(fun, rangestart=0, rangeend=1, rangestep=0.01) {
    tcogF <- sum(sapply(seq(rangestart, rangeend, rangestep), \(x) fun(x)))/length(seq(0,1,.010))
    return(tcogF)
}
tcogt <- function(fun, rangestart=0, rangeend=1, rangestep=0.01) {
    sumProd <- sum(sapply(seq(rangestart, rangeend, rangestep), \(x) x * fun(x)))
    sumWeight <- sum(sapply(seq(rangestart, rangeend, rangestep), fun))
    tcogT <- sumProd/sumWeight
    return(tcogT)
}

general <- function(x, f, A, P, B, W, k, g) {
    out <- f * ( (A * (x - P)) / ((1 + abs(B * (x - W))^k )^(1/k) ) ) + g
    # out <- ifelse(out < 0, 0, ifelse(out>1, 1, out))
    return(out)
}
sla <- function(x) {
    # out <- ifelse(x < 0.00, 0, ifelse(x<=1, x, 1 - (x-1)))
    out <- ifelse(x < 0.00, 0, (sin(pi*(x-.5))+1)/2)
    return(out)
}
dome <- function(x) {
    # general(x, f=-0.612427, A=-5.56734, P=0.18, B=-5.56734, W=0.18, k=1.75553, g=0.416228)
    a=0.332233
    b=70.89856
    # c=-0.419577
    c=-0.45
    k=4.16746
    d=-0.0051665
    out <- 1/cosh(a * (b * (x-c))/ (1-b * (x-c)^k))-d
    out <- ifelse(x < 0, 0, ifelse(x>1, sla(x), out))
    return(out)
}
scoop <- function(x) {
    out <- general(x, f=0.631655, A=9.25657, P=0.626861, B=9.25657, W=0.626861, k=1.03568, g=0.549519)*0.953
    out <- ifelse(x < 0, 0, ifelse(x>1, sla(x), out))
    return(out)
}
fall <- function(x) {
    out <- (sin(pi*(x+.75))+1)/2
    return(out)
}

# xstart <- -0.007
# xend <- 1
# ystart <- -0.05
# yend <- 1.2
# zeroToOneRange <- seq(xstart,xend,.000001)
#
# tcogplot <- ggplot() +
#     xlim(xstart, xend) + ylim(ystart, yend) +
#     # ###########
#     # geom_line(
#     #     data=data.frame(x=c(sla(tcogf(sla)), xend),y=c(tcogf(sla), tcogf(sla))),
#     #     aes(x=x, y=y), 
#     #     color= "#444444",
#     #     size = 2,
#     #     alpha=.35,
#     #     linetype=1) +
#     # geom_line(
#     #     data=data.frame(x=c(tcogt(sla), tcogt(sla)),y=c(ystart, sla(tcogt(sla)))), 
#     #     aes(x=x, y=y), 
#     #     color= "#444444", 
#     #     size = 2, 
#     #     alpha=.35, 
#     #     linetype=1) +
#     ###########
#     geom_line(
#         data=data.frame(x=c(xstart, zeroToOneRange[which.min(abs(fall(zeroToOneRange)-tcogf(fall)))]),y=c(tcogf(fall), tcogf(fall))), 
#         aes(x=x, y=y), 
#         color= "#cc00bb",
#         size = 2,
#         alpha=.35,
#         linetype=1) +
#     geom_line(
#         data=data.frame(x=c(tcogt(fall), tcogt(fall)),y=c(ystart, fall(tcogt(fall)))), 
#         aes(x=x, y=y), 
#         color= "#cc00bb", 
#         size = 2, 
#         alpha=.35, 
#         linetype=1) +
#     ###########
#     geom_line(
#         data=data.frame(x=c(zeroToOneRange[which.min(abs(dome(zeroToOneRange)-tcogf(dome)))], xend),y=c(tcogf(dome), tcogf(dome))), 
#         aes(x=x, y=y), 
#         color= "#0088ee", 
#         size=2, 
#         alpha=.35, 
#         linetype=1) +
#     geom_line(
#         data=data.frame(x=c(tcogt(dome), tcogt(dome)),y=c(ystart, dome(tcogt(dome)))), 
#         aes(x=x, y=y), 
#         color= "#0088ee", 
#         size=2, 
#         alpha=.35, 
#         linetype=1) +
#     ###########
#     geom_line(
#         data=data.frame(x=c(zeroToOneRange[which.min(abs(scoop(zeroToOneRange)-tcogf(scoop)))], xend),y=c(tcogf(scoop), tcogf(scoop))), 
#         aes(x=x, y=y), 
#         color= "#ee8800", 
#         size = 2, 
#         alpha=.35, 
#         linetype=1) +
#     geom_line(
#         data=data.frame(x=c(tcogt(scoop), tcogt(scoop)),y=c(ystart, scoop(tcogt(scoop)))), 
#         aes(x=x, y=y), 
#         color= "#ee8800", 
#         size = 2, 
#         alpha=.35, 
#         linetype=1) +
#     # ###########
#     # # stat_function(fun = sla, fill= "#686868", alpha=.25, xlim=c(0,1), geom="area") +
#     # geom_point(data=data.frame(x=tcogt(sla), y=tcogf(sla)), aes(x=x,y=y), color="black", stroke=3, fill="#444444", alpha=1, shape=23, size=6) +
#     # geom_function(fun = sla, color= "#444444", linewidth = 3.5, alpha=.4) +
#     # geom_function(fun = sla, color= "#444444", linewidth = 3.5, alpha=1, linetype="4121") +
#     # # stat_function(fun = sla, n = 40, size=4, geom = "point", shape=15) +
#     ###########
#     # stat_function(fun = fall, fill= "#686868", alpha=.25, xlim=c(0,1), geom="area") +
#     geom_point(data=data.frame(x=tcogt(fall), y=tcogf(fall)), aes(x=x,y=y), color="black", stroke=3, fill="#cc00bb", alpha=1, shape=23, size=6) +
#     geom_function(fun = fall, color= "#cc00bb", linewidth = 3.5, alpha=.4) +
#     geom_function(fun = fall, color= "#cc00bb", linewidth = 3.5, alpha=1, linetype="66") +
#     # stat_function(fun = fall, n = 40, size=4, geom = "point", shape=15) +
#     ###########
#     # stat_function(fun = dome, fill= "#0088ee", alpha=.25, xlim=c(0,1), geom="area") +
#     geom_point(data=data.frame(x=tcogt(dome),y=tcogf(dome)), aes(x=x,y=y), color="black", stroke=3, fill="#0088ee", alpha=1, shape=23, size=6) +
#     geom_function(fun = dome, color= "#0088ee", size = 3.5, alpha=.4) +
#     geom_function(fun = dome, color= "#0088ee", size = 3.5, alpha=1, linetype="12", lineend="round") +
#     # stat_function(fun = dome, n = 40, fill= "#0088ee", size=4, geom = "point", shape=24) +
#     ###########
#     # stat_function(fun = scoop, fill= "#ee8800", alpha=.25, xlim=c(0,1), geom="area") +
#     geom_point(data=data.frame(x=tcogt(scoop), y=tcogf(scoop)), aes(x=x,y=y), color="black", stroke=3, fill="#ee8800", alpha=1, shape=23, size=6) +
#     geom_function(fun = scoop, color= "#ee8800", size = 3.5, alpha=.4) +
#     geom_function(fun = scoop, color= "#ee8800", size = 3.5, alpha=1, linetype="33", lineend="round") +
#     # stat_function(fun = scoop, n = 40, fill= "#ee8800", size=4, geom = "point", shape=23) +
#     ###########
#     # geom_line(data=data.frame(x=c(0, 0, 1), y=c(1,0,0)), aes(x=x, y=y), size=4) +
#     # annotate("rect", xmin = xstart, xmax = xend, ymin = ystart, ymax = yend, fill="transparent", color="black", size=4) +
#     # annotate("segment", x = 0, xend = 1, y = 0, yend = 0, color="black", size=2) +
#     # annotate("segment", x = 0, xend = 0, y = 0, yend = 1, color="black", size=2) +
#     ###########
#     # annotate("rect", xmin = 1, xmax = xend, ymin = ystart, ymax = yend, alpha=0.6) +
#     # annotate("rect", xmin = xstart, xmax = 0, ymin = ystart, ymax = yend, alpha=0.6) +
#     annotate("rect", xmin = xstart, xmax = xend, ymin = ystart, ymax = yend, fill="transparent", color="black", size=3.05) +
#     labs(x = "Time", y = "Frequency") +
#     theme(
#         # line = element_blank(), 
#         # text = element_blank(), 
#         # title = element_blank(), 
#         # aspect.ratio=(yend-ystart)/(1.5*(xend-xstart)), 
#         aspect.ratio=.75, 
#         # axis.line = element_line(colour = "black"),
#         axis.title.x = element_text(size = 30, face = "bold", vjust=3),
#         axis.title.y = element_text(size = 30, face = "bold", vjust=-3),
#         axis.text=element_blank(),
#         axis.ticks=element_blank(),
#         # panel.grid.major = element_blank(), 
#         # panel.grid.minor = element_blank(),
#         panel.background=element_rect(fill="transparent"), 
#         plot.margin=margin(0, 0, 0, 0, "mm")
#         # panel.border = element_rect(colour = "black", fill=NA, linewidth=5),
#     ) #+ scale_y_continuous(expand = c(0,0)) + scale_x_continuous(expand = c(0,0))
# tcogplot

# ggsave("tcog.png", width = 15*.75, height = 10.2*.75)



thefuns <- list(
    # list(fall, "#cc00bb", "66"),
    # list(sla, "#333333", "4121")
    list(fall, "#333333", "22"),
    list(scoop, "#ee8800", "2131")
)
thefuns <- list(
    list(dome, "#0088ee", "11"),
    list(scoop, "#ee8800", "2131")
)
{
    # xstart <- -0.007
    xstart <- 0.1
    xend <- 1.0
    ystart <- -0.15
    yend <- 1.2
    zeroToOneRange <- seq(xstart,xend,.000001)
    ybase <- ystart+0.0425
    ybase <- ystart
    p <- ggplot() + xlim(xstart, xend) + ylim(ystart, yend)
    for (x in thefuns) {
        thefun <- unlist(x[[1]])
        thecolor <- unlist(x[[2]])
        thelinetype <- unlist(x[[3]])

        tcogf_value <- tcogf(thefun, rangestart=xstart, rangeend=xend)
        tcogt_value <- tcogt(thefun, rangestart=xstart, rangeend=xend)
        intercept_tcogfHoriz_funCurve <- zeroToOneRange[which.min(abs(thefun(zeroToOneRange)-tcogf_value))]
        if (intercept_tcogfHoriz_funCurve < tcogt_value) {
            tcogpoint_line_xCoords <- c(intercept_tcogfHoriz_funCurve, xend)
        } else {
            tcogpoint_line_xCoords <- c(xstart, intercept_tcogfHoriz_funCurve)
        }
        intercept_tcogtVert_funCurve <- tcogf_value
        if (intercept_tcogtVert_funCurve > thefun(tcogt_value)) {
            tcogpoint_line_yCoords <- c(thefun(tcogt_value), yend)
        } else {
            tcogpoint_line_yCoords <- c(ybase, thefun(tcogt_value))
        }

        p <- p +
            # under-curve fill:
            # stat_function(fun = thefun, fill= thecolor, alpha=.5, xlim=c(xstart,xend), geom="area") +
            # tcog
            ## lines:
                geom_line(
                data=data.frame(x=tcogpoint_line_xCoords, y=c(tcogf_value, tcogf_value)), 
                aes(x=x, y=y), 
                color= thecolor,
                size = 2,
                alpha=.35,
                linetype=1) +
                geom_line(
                    data=data.frame(x=c(tcogt_value, tcogt_value),y=tcogpoint_line_yCoords), 
                    aes(x=x, y=y), 
                    color= thecolor, 
                    size = 2, 
                    alpha=.35, 
                    linetype=1) +
            ## point:
                geom_point(data=data.frame(x=tcogt_value, y=tcogf_value), aes(x=x,y=y), color="black", stroke=3, fill=thecolor, alpha=1, shape=23, size=6) +
            # curve background:
            geom_function(fun = thefun, color= thecolor, linewidth = 3.5, alpha=.4) +
            # curve pattern:
            geom_function(fun = thefun, color= thecolor, linewidth = 3.5, alpha=1, linetype=thelinetype)
    }
    p <- p + 
        annotate("rect", xmin = xstart, xmax = xend, ymin = ybase, ymax = yend, fill="transparent", color="black", size=3.05) +
        labs(x = "Time", y = "Frequency") +
        theme(
            aspect.ratio=.75, 
            axis.title.x = element_text(size = 30, face = "bold", vjust=4),
            axis.title.y = element_text(size = 30, face = "bold", vjust=-3),
            axis.text=element_blank(),
            axis.ticks=element_blank(),
            panel.background=element_rect(fill="transparent"), 
            plot.margin=margin(0, 0, 0, 0, "mm")
        )
    p
}
ggsave("tcog-two-rises.png", width = 15*.75, height = 10.2*.75)
ggsave("tcog-rise-vs-fall.png", width = 15*.75, height = 10.2*.75)













dev.off()
tikz(file = "tcog_plot.tex", width = 15*.75, height = 10.2*.75)
print(tcogplot)
dev.off()

x <- 1
\(x) (sin(pi*(x-.5))+1)/2
