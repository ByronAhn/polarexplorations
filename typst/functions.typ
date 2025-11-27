#let dome(x) = {
  if x <= 0 { 0 } 
  else if x <= 80 { 80 * calc.sin((2 * calc.pi) / 320 * x) } 
  else if x <= 160 { 80 - (x - 80) } 
  else { 0 }
}

#let scoop(x) = {
  if x <= 0 { 0 } 
  else if x <= 80 { 80 * calc.sin((2 * calc.pi) / 320 * (x - 80) + 80) } 
  else if x <= 160 { 80 - (x - 80) } 
  else { 0 }
}

#let sla(x) = {
 if x <= 0 { 0 }
 else if x <= 80 { x }
 else if x <= 160 { 80 - (x - 80) } 
 else { 0 }
}





#let timeSpan = (range(0, 801, step: 1)).map(x => x/10)

#let dome-sum-prod = { (timeSpan.map(x => x * dome(x))).sum() }
#let dome-sum-weight = { (timeSpan.map(dome)).sum() }
#let dome-TCOGf = { (timeSpan.map(dome)).sum() / timeSpan.len() }
#let dome-TCOGt = dome-sum-prod / dome-sum-weight

#let scoop-sum-prod = { (timeSpan.map(x => x * scoop(x))).sum() }
#let scoop-sum-weight = { (timeSpan.map(scoop)).sum() }
#let scoop-TCOGf = { (timeSpan.map(scoop)).sum() / timeSpan.len() }
#let scoop-TCOGt = scoop-sum-prod / scoop-sum-weight

#let sla-sum-prod = { (timeSpan.map(x => x * sla(x))).sum() }
#let sla-sum-weight = { (timeSpan.map(sla)).sum() }
#let sla-TCOGf = { (timeSpan.map(sla)).sum() / timeSpan.len() }
#let sla-TCOGt = sla-sum-prod / sla-sum-weight

#page[
#sla-TCOGf
#sla-TCOGt
]