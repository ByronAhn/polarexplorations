# if (!requireNamespace("remotes", quietly=TRUE)) { install.packages("remotes") }
# remotes::install_github("xiangpin/ggstar")
library(ggplot2)
library(ggstar)
library(tidyverse)
options(tikzLatex = "/Library/TeX/texbin")
library(tikzDevice)

# set up functions for calculations
{
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
        out <- (sin(pi*(x+.35))+1)/2
        return(out)
    }
}

# set up variables for plots
{
    thefuns <- list(
        list(
            function_name = "fall", 
            line_color = "#ee0088", 
            line_type = "22", 
            curve_name= "Fall", 
            shape = 1, 
            shape_fill="transparent", 
            fillshape = 21, 
            tcog_name = "TCoG for Fall"
        ),
        list(
            function_name = "dome", 
            line_color = "#0088ee", 
            line_type = "11", 
            curve_name= "Rise (Domed)", 
            shape = 17, 
            shape_fill="#0088ee", 
            fillshape = 24, 
            tcog_name = "TCoG for Rise (Domed)"
        ),
        list(
            function_name = "scoop", 
            line_color = "#ee8800", 
            line_type = "2131", 
            curve_name= "Rise (Scooped)", 
            shape = 15, 
            shape_fill="#ee8800", 
            fillshape = 22, 
            tcog_name = "TCoG for Rise (Scooped)"
        )
    )

    xstart <- 0.1
    xend <- .85
    ystart <- -0.15
    yend <- 1.2
    ybase <- ystart+0.0425

    calcsForTCOGplot <- function(function_name, xstart, xend, ystart, yend, ybase, color="black", shape=1, curve_name=NA, tcog_name=NA) {
        zeroToOneRange <- seq(xstart,xend,.000001)
        thefun <- match.fun(function_name)
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
        if (is.na(curve_name) && is.na(tcog_name)) { 
            curve_name <- function_name
            tcog_name <- function_name
        } else if (is.na(curve_name)) { 
            curve_name <- tcog_name
        } else if (is.na(tcog_name)) { 
            tcog_name <- curve_name
        }
        return(
            list(
                curve_name = curve_name, 
                tcog_name = tcog_name, 
                tcogf_value = tcogf_value, 
                tcogt_value = tcogt_value, 
                # tcogpoint_line_xCoords = tcogpoint_line_xCoords, 
                tcogpoint_line_xMin = tcogpoint_line_xCoords[1], 
                tcogpoint_line_xMax = tcogpoint_line_xCoords[2], 
                # tcogpoint_line_yCoords = tcogpoint_line_yCoords,
                tcogpoint_line_yMin = tcogpoint_line_yCoords[1],
                tcogpoint_line_yMax = tcogpoint_line_yCoords[2],
                color = color,
                shape = shape
            )
        )
    }

    tcog_data <- lapply(
    thefuns, 
        \(x) { calcsForTCOGplot(x$function_name, xstart, xend, ystart, yend, ybase, x$line_color, x$fillshape, curve_name = x$curve_name, tcog_name = x$tcog_name) }
    ) %>% do.call(rbind.data.frame, .) %>% tibble()
}

# function to make the plot
drawit <- function(thefuns_toDraw, tcog_data_toDraw) {
    p <- ggplot() + 
        xlim(xstart, xend) + 
        ylim(ystart, yend) +
        labs(x = "Time", y = "Frequency")

    layers <- lapply(
        thefuns_toDraw, 
        \(x) {
            y <- calcsForTCOGplot(x$function_name, xstart, xend, ystart, yend, ybase)
            list(
                # TCOG horizontal lines
                geom_line(
                    data=data.frame(
                        x=c(y$tcogpoint_line_xMin, y$tcogpoint_line_xMax),
                        y=c(y$tcogf_value, y$tcogf_value)
                    ), 
                    aes(x=x, y=y), 
                    color= x$line_color,
                    size = 2,
                    alpha=.35,
                    linetype="22"
                ),
                # TCOG vertical lines
                geom_line(
                    data=data.frame(
                        x=c(y$tcogt_value, y$tcogt_value),
                        y=c(y$tcogpoint_line_yMin, y$tcogpoint_line_yMax)
                    ), 
                    aes(x=x, y=y), 
                    color= x$line_color,
                    size = 2,
                    alpha=.35,
                    linetype="22"
                ),
                # TCOG points
                geom_star(
                    data=tcog_data_toDraw,
                    aes(x=tcogt_value, y=tcogf_value),
                    inherit.aes = FALSE,
                    starstroke=2,
                    starshape = 1,
                    angle=25,
                    fill=tcog_data_toDraw$color,
                    # fill="transparent",
                    alpha=1,
                    size=8
                ),
                # curve background line
                geom_function(
                    fun = match.fun(x$function_name),
                    color = rgb(colorRamp(c(x$line_color, 'white'))(.5), maxColorValue=255),
                    linewidth = 6,
                    lineend = "round"
                ),
                # curve points
                stat_function(
                    fun = match.fun(x$function_name),
                    aes(
                        color = x$curve_name, 
                        shape = x$curve_name
                    ),
                    fill = x$shape_fill,
                    size = 3,
                    n=50,
                    stroke=2,
                    geom="point"
                )#,
                # geom_ribbon(linetype = 0, alpha = 1)
            )
        }
    )

    aesthetics <- list(
        scale_shape_manual(
            name = "Contour",
            values = sapply(thefuns_toDraw, `[[`, "shape"),
            labels = sapply(thefuns_toDraw, `[[`, "curve_name")
            ),
        scale_color_manual(
            name = "Contour",
            values = sapply(thefuns_toDraw, `[[`, "line_color"),
            labels = sapply(thefuns_toDraw, `[[`, "curve_name")
            ),
        theme(
            aspect.ratio=.75, 
            axis.title.x = element_text(size = 30, face = "bold", vjust=4),
            axis.title.y = element_text(size = 30, face = "bold", vjust=-3),
            axis.text=element_blank(),
            axis.ticks=element_blank(),
            panel.background=element_rect(fill="transparent"), 
            plot.margin=margin(0, 0, 0, 0, "mm"),
            legend.background = element_rect(colour = "black", linewidth = 1),
            legend.text=element_text(size=14),
            legend.title = element_blank(),
            legend.position = c(.8, .95)
        )
    )

    tcogplot <- p + layers + aesthetics + 
        # add a rectangle
        annotate(
            "rect", 
            xmin = xstart, xmax = xend,
            ymin = ybase, ymax = yend,
            fill="transparent",
            color="black",
            size=6
        )
    
    return(tcogplot)
}

# tcog-rise-vs-fall
drawit(
    thefuns_toDraw = list(thefuns[[1]], thefuns[[3]]),
    tcog_data_toDraw = tcog_data[c(1,3), ]
)
ggsave("tcog-rise-vs-fall.png", width = 15*.75, height = 10.2*.75)

# tcog-two-rises
drawit(
    thefuns_toDraw = list(thefuns[[2]], thefuns[[3]]),
    tcog_data_toDraw = tcog_data[c(2,3), ]
)
ggsave("tcog-two-rises.png", width = 15*.75, height = 10.2*.75)


# all 3
tcogplot <- drawit(
    thefuns_toDraw = thefuns,
    tcog_data_toDraw = tcog_data
)


tikz(file = "tcog_plot.tex", width = 15*.75, height = 10.2*.75)
print(tcogplot)
dev.off()
