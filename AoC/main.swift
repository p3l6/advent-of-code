//
//  main.swift
//  AoC
//

// https://developer.apple.com/library/content/documentation/Swift/Conceptual/Swift_Programming_Language/GuidedTour.html

import Foundation


let input = 265149

var x = 0
var y = 0
var band = 0

for i in 1..<input {
    
    //print("\(i) is (\(x),\(y))")
    
    let bandMax = squared(band*2+1)
    let width = band*2+1
    let lastMax = squared((max(band,1)-1)*2+1)
    let bandIndex = i - lastMax
    
    if bandMax == i {
        band += 1
        x += 1
    } else if bandIndex < width-1 {
        y += 1
    } else if bandIndex < 2*(width-1) {
        x -= 1
    } else if bandIndex < 3*(width-1) {
        y -= 1
    } else  {
        x += 1
    }
    
}


//print("\(input) is (\(x),\(y))")

print("part one: \(abs(x)+abs(y))") // 438



var values = [1]

func indexOfCoord(_ xx :Int, _ yy: Int) -> Int {
    var x = 0
    var y = 0
    var band = 0
    
    for i in 1... {
        
        if x == xx && y == yy {
            return i-1
        }
        
        let bandMax = squared(band*2+1)
        let width = band*2+1
        let lastMax = squared((max(band,1)-1)*2+1)
        let bandIndex = i - lastMax
        
        if bandMax == i {
            band += 1
            x += 1
        } else if bandIndex < width-1 {
            y += 1
        } else if bandIndex < 2*(width-1) {
            x -= 1
        } else if bandIndex < 3*(width-1) {
            y -= 1
        } else  {
            x += 1
        }
    }
    return 0
}

func valueAt(_ x :Int, _ y: Int) -> Int {
    let index = indexOfCoord(x, y)
    if index >= values.count {
        return 0
    }
    return values[index]
}


x = 0
y = 0
band = 0

for i in 1... {
    
    let bandMax = squared(band*2+1)
    let width = band*2+1
    let lastMax = squared((max(band,1)-1)*2+1)
    let bandIndex = i - lastMax
    
    if bandMax == i {
        band += 1
        x += 1
    } else if bandIndex < width-1 {
        y += 1
    } else if bandIndex < 2*(width-1) {
        x -= 1
    } else if bandIndex < 3*(width-1) {
        y -= 1
    } else  {
        x += 1
    }
    
    // calculate value for these new coords
    var value = 0
    value += valueAt(x-1, y-1)
    value += valueAt(x-1, y  )
    value += valueAt(x-1, y+1)
    value += valueAt(x  , y-1)
//  value += valueAt(x  , y  )  this square
    value += valueAt(x  , y+1)
    value += valueAt(x+1, y-1)
    value += valueAt(x+1, y  )
    value += valueAt(x+1, y+1)
    
    values.append(value)
    //print("\(value) is (\(x),\(y))")
    if value > input {
        print("part two: \(value)") // 226330
        break
    }
   
}


