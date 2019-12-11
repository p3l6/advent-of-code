//
//  day10.swift
//  AoC
//
//  Created by Paul Landers
//

import Foundation

let runDay10 = false

enum AsteroidBelt {
    case station
    case empty
    case asteroid
    case blocked
}

func detect(_ asteroids: [Point], from:Point, in size: Area) -> [Point] {
    let field = FiniteGrid<AsteroidBelt>(defaultValue: .empty, area: size)
    field[from] = .station

    for ast in asteroids {
        if field[ast] == .empty {
            field[ast] = .asteroid
            
            var fraction = (x:ast.x-from.x, y:ast.y-from.y)
            let gcd = gcdBinaryRecursiveStein(abs(fraction.x), abs(fraction.y))
            if gcd != 1 {
                fraction = (x: fraction.x / gcd, y: fraction.y / gcd)
            }
            
            var scanpast = ast + fraction
            while size.contains(point: scanpast) {
                field[scanpast] = .blocked
                scanpast = scanpast + fraction
            }
        }
    }
    
    var detected = [Point]()
    for p in size {
        if field[p] == .asteroid {
            detected.append(p)
        }
    }
    return detected
}

func angle(_ point:Point, _ origin:Point) -> Double {
    // note that the y coords are swapped, since they are in top left origin mode
    let natural = Double.pi/2 - atan2(Double(origin.y-point.y), Double(point.x-origin.x))
    return natural < 0 ? natural + 2*Double.pi : natural
}

func day10 (_ input:String) -> Solution {
    var solution = Solution()
    let lines = input.lines()
    let size = Area(at: Point(0,0), w: lines.first!.count, h:lines.count)
    var asteroids = [Point]()
    
    for point in size {
        if lines[point.y][point.x] == "#" {
            asteroids.append(point)
        }
    
    }
    
    var best = (location: Point(0,0), detected: 0)
    for point in asteroids {
        let detected = detect(asteroids, from:point, in:size).count
        if detected > best.detected {
            best = (point, detected)
        }
    }
    
    solution.partOne = "\(best.detected)"
    if best.detected < 200 {
        print("Not enough detected for part two. If this is not a small test case, add a loop.")
        return solution
    }
    
    let detected = detect(asteroids, from:best.location, in:size)
    let sorted = detected.sorted { (a, b) -> Bool in
        angle(a, best.location) < angle(b, best.location)
    }
    let bet = sorted[199]
    
    solution.partTwo = "\(bet.x*100+bet.y)"
    return solution
}
