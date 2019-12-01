//
//  day17.swift
//  AoC
//
//  Created by Paul Landers
//

import Foundation

let runDay17 = false

enum SquareMeter {
    case Sand // = "."
    case WetSand // = "|"
    case Clay // = "#"
    case Water // = "~"
    
    var isSandy :Bool { return self == .Sand || self == .WetSand }
    var isWet :Bool { return self == .Water || self == .WetSand }
    var isSolid :Bool { return self == .Water || self == .Clay }
}

func printUnderground(area:Area, grid:FiniteGrid<SquareMeter>) {
    var s = ""
    for y in area.start.y..<area.start.y + area.height {
        for x in area.start.x..<area.start.x + area.width {
            switch grid[Point(x,y)] {
            case .Sand:  s.append(".")
            case .WetSand:  s.append("|")
            case .Clay:  s.append("#")
            case .Water:  s.append("~")
            }
        }
        s += "\n"
    }
    print(s)
}

func day17 (_ input:String) -> Solution {
    Direction.defaultOrigin = .topLeft
    
    var clayAreas = [Area]()
    var specifiedPoints = [Point]()
    for line in input.lines() {
        if let v = line.extract(format: "x=%, y=%..%") {
            clayAreas.append(Area(at: Point(v[0],v[1]), w: 1, h: v[2]-v[1]+1))
            specifiedPoints.append(Point(v[0],v[1]))
            specifiedPoints.append(Point(v[0],v[2]))
        } else if let h = line.extract(format: "y=%, x=%..%") {
            clayAreas.append(Area(at: Point(h[1],h[0]), w: h[2]-h[1]+1, h: 1))
            specifiedPoints.append(Point(h[1],h[0]))
            specifiedPoints.append(Point(h[2],h[0]))
        } else { assertionFailure("Could not parse line: \(line)") }
    }
    
    let area = Area(asBoundingBoxOf: specifiedPoints).outset(by: (2,0))
    let underground = FiniteGrid<SquareMeter>(defaultValue: .Sand, area: area)
    let waterSpring = Point(500, area.start.y) // Should be 500,0
    underground[waterSpring] = .WetSand
    
    for clay in clayAreas {
        for point in clay {
            underground[point] = .Clay
        }
    }
    
    var fallingWater = Stack<Point>()
    fallingWater.push(waterSpring)
    
    while !fallingWater.isEmpty {
        let p = fallingWater.pop()
        underground[p] = .WetSand
        if !area.contains(point: p.move(.south)) { continue }
        let south = underground[p.move(.south)]
        switch south {
        case .Clay, .Water:
            var east = p, west = p
            while underground[east.move(.east)].isSandy && underground[east.move(.south)].isSolid { east = east.move(.east) }
            while underground[west.move(.west)].isSandy && underground[west.move(.south)].isSolid { west = west.move(.west) }
            if underground[east.move(.east)] == .Clay && underground[west.move(.west)] == .Clay {
                for p in Area(asBoundingBoxOf: [east,west]) { underground[p] = .Water }
            } else {
                for p in Area(asBoundingBoxOf: [east,west]) { underground[p] = .WetSand }
                if underground[east.move(.south)] == .Sand || underground[west.move(.south)] == .Sand {
                    fallingWater.push(p); // replace p
                    if underground[east.move(.south)] == .Sand { fallingWater.push(east.move(.south)) }
                    if underground[west.move(.south)] == .Sand { fallingWater.push(west.move(.south)) }
                }
            }
        case .Sand:
            fallingWater.push(p) // replace p
            fallingWater.push(p.move(.south))
        case .WetSand:
            continue
        }
    }
    
//    printUnderground(area: area, grid: underground)
    
    var wetCount = 0, waterCount = 0
    for p in area {
        switch underground[p] {
        case .WetSand: wetCount += 1
        case .Water: wetCount += 1; waterCount += 1
        default: continue
        }
    }
    
    var solution = Solution()
    solution.partOne = "\(wetCount)"
    solution.partTwo = "\(waterCount)"
    return solution
}
