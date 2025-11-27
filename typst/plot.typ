#import "@preview/cetz:0.4.1": canvas, draw
#import draw: rect
#import "@preview/cetz-plot:0.1.2": plot, chart


#let timeSpan = (range(0, 851, step: 1)).map(x => x/10)

#let sineWavey(x, amplitude: 40, period: 10, phaseShift: 10, verticalShift: 40, widthFactor: 3) = {
  amplitude * (calc.sin((1/period) * x/widthFactor - phaseShift)) + verticalShift
}

#let domeycurve(x) = {
  sineWavey(x)//, period: 10, widthFactor: 3.8, phaseShift: 1)
  // { 6.3 * (( (x - 45)/5 ) / ( calc.sqrt( 1 + calc.pow(x/30, 2))) + .5 ) + 61  }
  // { 8 * (( x/7 ) / ( 
  //   calc.sqrt( 1 + calc.pow(x/80, 2))) + .5 ) + 0 }
}

#let dome(x) = {
  
  if x <= 80 { domeycurve(x) }
  else  { sineWavey(x) } 
  // else { 0 }
}
#let dome-sum-prod = { (timeSpan.map(x => x * dome(x))).sum() }
#let dome-sum-weight = { (timeSpan.map(dome)).sum() }
#let dome-TCOGf = { (timeSpan.map(dome)).sum() / timeSpan.len() }
#let dome-TCOGt = dome-sum-prod / dome-sum-weight

#let scoop(x) = {
  if x <= 0 { 0 } 
  // else if x <= 80 { 80 * calc.sin((2 * calc.pi) / 320 * (x - 80) + 80) } 
  else if x <= 80 { 84 * 1/(1 + calc.pow(calc.e, -(x - 50)/10) ) } 
  else  { sineWavey(x) } 
}
#let scoop-sum-prod = { (timeSpan.map(x => x * scoop(x))).sum() }
#let scoop-sum-weight = { (timeSpan.map(scoop)).sum() }
#let scoop-TCOGf = { (timeSpan.map(scoop)).sum() / timeSpan.len() }
#let scoop-TCOGt = scoop-sum-prod / scoop-sum-weight

#let sla(x) = {
 if x <= 0 { 0 }
 else if x <= 80 { x }
 else if x <= 160 { 80 - (x - 80) } 
 else { 0 }
}
#let sla-sum-prod = { (timeSpan.map(x => x * sla(x))).sum() }
#let sla-sum-weight = { (timeSpan.map(sla)).sum() }
#let sla-TCOGf = { (timeSpan.map(sla)).sum() / timeSpan.len() }
#let sla-TCOGt = sla-sum-prod / sla-sum-weight




#canvas(length: 1cm, {
  import draw: *
  
  // Set up the plot
  plot.plot(
    size: (14.8, 8),
    x-tick-step: none,
    y-tick-step: none,
    x-min: -10, x-max: 175,
    y-min: -10, y-max: 90,
    x-label: "Time",
    y-label: "Frequency",
    x-grid: false,
    y-grid: false,
    // x-equal: "y",
    {
      // SCOOP
      plot.add(
        style: (stroke: (paint: blue.transparentize(0%), dash:"dashed", thickness: 2pt)),
        ((0, scoop-TCOGf), (80, scoop-TCOGf))
      )
      plot.add(
        style: (stroke: (paint: blue.transparentize(0%), dash:"dashed", thickness: 2pt)),
        ((scoop-TCOGt,-10), (scoop-TCOGt, 100))
      )
      plot.annotate(
          circle(
            (scoop-TCOGt, scoop-TCOGf), radius: 1.5,
            stroke: (paint: blue, thickness: 2pt), fill: white
          )
      )

      // DOME
      plot.add(
        style: (stroke: (paint: red.transparentize(0%), dash:"dashed", thickness: 2pt)),
        ((0, dome-TCOGf), (80, dome-TCOGf))
      )
      plot.add(
        style: (stroke: (paint: red.transparentize(0%), dash:"dashed", thickness: 2pt)),
        ((dome-TCOGt,-10), (dome-TCOGt, 100))
      )
      plot.annotate(
          circle(
            (dome-TCOGt, dome-TCOGf), radius: 1.5,
            stroke: (paint: red, thickness: 2pt), fill: white
          )
      )
      
      // SCOOP
      plot.add(
        style: (stroke: (paint: blue.transparentize(100%))),
        domain: (-10, 175),
        mark: "square",
        mark-style: (fill: none, stroke: (paint: blue.transparentize(0%), thickness: 2pt)),
        mark-size: 0.12,
        samples: 100,
        (x) => { scoop(x) }
      )

      // DOME
      plot.add(
        style: (stroke: (paint: red.transparentize(0%))),
        domain: (-10, 175),
        // mark: "x",
        mark-style: (fill: none, stroke: (paint: red.transparentize(0%), thickness: 1.5pt)),
        mark-size: 0.11,
        samples: 10000,
        (x) => { dome(x) }
      )

      // plot.add-bar(
      //   (-10, 175)
      // )

      plot.annotate(
          rect(
            (-10, -10),
            (0, 90),
            stroke: (paint: black.transparentize(100%), thickness: .7pt),
            fill: black.transparentize(80%)
          )
      )
      plot.annotate(
          rect(
            (85, -10),
            (175, 90),
            stroke: (paint: black.transparentize(100%), thickness: .7pt),
            fill: black.transparentize(80%)
          )
      )
      

    }
  )
})

// #canvas(length: 1cm, {
//   import draw: *
  
//   // Set up the plot
//   plot.plot(
//     size: (14.8, 8),
//     x-tick-step: none, y-tick-step: none,
//     x-min: -10, x-max: 175, y-min: -10, y-max: 90,
//     x-label: "Time", y-label: "Frequency",
//     x-grid: false, y-grid: false,
//     {

//       // SLA
//       plot.add(
//         style: (stroke: (paint: blue.transparentize(0%), dash:"dashed", thickness: 2pt)),
//         ((0, sla-TCOGf), (80, sla-TCOGf))
//       )
//       plot.add(
//         style: (stroke: (paint: blue.transparentize(0%), dash:"dashed", thickness: 2pt)),
//         ((sla-TCOGt,-10), (sla-TCOGt, 100))
//       )
//       plot.annotate(
//           circle(
//             (sla-TCOGt, sla-TCOGf), radius: 2,
//             stroke: (paint: black, thickness: 2pt), fill: white
//           )
//       )

//       // SLA
//       plot.add(
//         style: (stroke: (paint: blue.transparentize(0%), dash: "solid", thickness: 4pt)), // mark: "o", mark-size: 0.17,
//         domain: (-10, 175),
//         samples: 100,
//         (x) => { sla(x) }
//       )

//       // gray'd out
//       plot.annotate(
//           rect( (-10, -10), (0, 90), stroke: (paint: black.transparentize(100%), thickness: .7pt), fill: black.transparentize(80%) )
//       )
//       plot.annotate(
//           rect( (80, -10), (175, 90), stroke: (paint: black.transparentize(100%), thickness: .7pt), fill: black.transparentize(80%) )
//       )
//     }
//   )
// }
// )


// #canvas(length: 1cm, {
//   import draw: *
  
//   // Set up the plot
//   plot.plot(
//     size: (12, 8),
//     x-tick-step: none,
//     y-tick-step: none,
//     x-min: -10, x-max: 175,
//     y-min: -10, y-max: 90,
//     x-label: "Time",
//     y-label: "Frequency",
//     x-grid: false,
//     y-grid: false,
//     {
//       // SCOOP
//       plot.add(
//         style: (stroke: (paint: black.transparentize(40%), thickness: 2pt)),
//         ((0, 29.084079), (80, 29.084079)) // (X, F0)
//       )
//       plot.add(
//         style: (stroke: (paint: black.transparentize(40%), thickness: 2pt)),
//         ((59.1838,-10), (59.1838, 100)) // (TIME, Y)
//       )
//       plot.annotate(
//           rect(
//             (57.1838, 27.084079),
//             (61.1838, 31.084079),
//             stroke: (paint: black, thickness: 2pt),
//             fill: white
//           )
//       )

      
//       // SCOOP
//       plot.add(
//         style: (stroke: (paint: black.transparentize(100%))),
//         domain: (-10, 175),
//         mark: "o",
//         mark-style: (fill: none, stroke: (paint: black.transparentize(25%), thickness: 1pt)),
//         mark-size: 0.145,
//         samples: 100,
//         (x) => {
//           if x <= 0 { 0 }
//           else if x <= 80 { 80 * calc.sin((2 * calc.pi )/320 * (x - 80) ) + 80 }
//           else if x <= 160 { 80 - (x - 80) }
//           else { 0 }
//         }
//       )
//       plot.annotate(
//           rect(
//             (-10, -10),
//             (0, 90),
//             stroke: (paint: black.transparentize(100%), thickness: .7pt),
//             fill: black.transparentize(80%)
//           )
//       )
//       plot.annotate(
//           rect(
//             (80, -10),
//             (175, 90),
//             stroke: (paint: black.transparentize(100%), thickness: .7pt),
//             fill: black.transparentize(80%)
//           )
//       )
      

//     }
//   )
// })


// #canvas(length: 1cm, {
//   import draw: *
  
//   // Set up the plot
//   plot.plot(
//     size: (14.8, 8),
//     x-tick-step: none,
//     y-tick-step: none,
//     x-min: -10, x-max: 175,
//     y-min: -10, y-max: 90,
//     x-label: "Time",
//     y-label: "Frequency",
//     x-grid: false,
//     y-grid: false,
//     {

//       // DOME
//       plot.add(
//         style: (stroke: (paint: red.transparentize(40%), thickness: 2pt)),
//         ((0, 50.915921), (80, 50.915921)) // (X, F0)
//       )
//       plot.add(
//         style: (stroke: (paint: red.transparentize(40%), thickness: 2pt)),
//         ((50.95813,-10), (50.95813, 100)) // (TIME, Y)
//       )
//       plot.annotate(
//           rect(
//             (48.95813, 48.915921),
//             (52.95813, 52.915921),
//             stroke: (paint: black, thickness: 2pt),
//             fill: white
//           )
//       )


//       // DOME
//       plot.add(
//         style: (stroke: (paint: red.transparentize(100%))),
//         domain: (-10, 175),
//         mark: "x",
//         mark-style: (fill: none, stroke: (paint: red.transparentize(25%), thickness: 1.5pt)),
//         mark-size: 0.13,
//         samples: 100,
//         (x) => {
//           if x <= 0 { 0 }
//           else if x <= 80 { 80 * calc.sin((2 * calc.pi )/320 * (x) ) }
//           else if x <= 160 { 80 - (x - 80) }
//           else { 0 }
//         }// average = 50.915921
//       )

//       plot.annotate(
//           rect(
//             (-10, -10),
//             (0, 90),
//             stroke: (paint: black.transparentize(100%), thickness: .7pt),
//             fill: black.transparentize(80%)
//           )
//       )
//       plot.annotate(
//           rect(
//             (80, -10),
//             (175, 90),
//             stroke: (paint: black.transparentize(100%), thickness: .7pt),
//             fill: black.transparentize(80%)
//           )
//       )
//     }
//   )
// })
