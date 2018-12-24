//
//  day22.swift
//  AoC
//
//  Created by Paul Landers
//

import Foundation

let runDay22 = true

class Cave :CustomStringConvertible {
    enum CaveType {
        case rocky
        case narrow
        case wet
        case unknown
    }
    
    let erosions :FiniteGrid<Int>
    let map :FiniteGrid<CaveType>
    let mouth = Point(0,0)
    let target :Point
    let depth :Int
    let area :Area
    
    init(depth: Int, target:Point) {
        area = Area(asBoundingBoxOf: [mouth,target])
        self.depth = depth
        self.target = target
        erosions = FiniteGrid(defaultValue: -1, area: area)
        map = FiniteGrid(defaultValue: .unknown, area: area)
        self.scan()
    }
    
    private func scan() {
        for p in area {
            erosions[p] = erosionLevel(p)
        }
        for p in area {
            map[p] = typeOf(erosionLevel: erosions[p])
        }
    }

    private func geologicIndex(_ point:Point) -> Int {
        if point == mouth || point == target {
            return 0
        } else if point.y == 0 {
            return point.x * 16807
        } else if point.x == 0 {
            return point.y * 48271
        } else {
            return erosionLevel(point + (-1,0)) * erosionLevel(point + (0,-1))
        }
    }

    func erosionLevel(_ point:Point) -> Int {
        let cached = erosions[point]
        if cached >= 0 {
            return cached
        }
        let magicNumber = 20183
        let erosion = (geologicIndex(point) + depth) % magicNumber
        erosions[point] = erosion
        return erosion
    }
    
    private func typeOf(erosionLevel:Int) -> CaveType {
        switch erosionLevel % 3 {
        case 0: return .rocky
        case 1: return .wet
        case 2: return .narrow
        default: assertionFailure("impossible modulo")
        }
        return .unknown
    }
    
    func typeAt(_ point:Point) -> CaveType {
        return map[point]
    }
    
    var riskLevel :Int {
        var risk = 0
        for p in area {
            switch map[p] {
            case .rocky: risk += 0
            case .wet: risk += 1
            case .narrow: risk += 2
            case .unknown: assertionFailure("riskLevel cannot be determined before cave is fully scanned")
            }
        }
        return risk
    }
    
    var description :String {
        return map.stringBy { (caveType) -> Character in
            switch caveType {
            case .rocky: return "."
            case .wet:  return "="
            case .narrow:  return "|"
            case .unknown:  return "?"
            }
        }
    }
}

func day22 (_ input:String) -> Solution {
    var solution = Solution()
    Direction.defaultOrigin = .topLeft
    
    let lines = input.lines()
    let d = lines[0].extract(format: "depth: %")!.first!
    let txy = lines[1].extract(format: "target: %,%")!
    let cave = Cave(depth: d, target:Point(txy[0],txy[1]))
    
//    print(cave)
    solution.partOne = "\(cave.riskLevel)"
//    solution.partTwo = "\()"
    return solution
}
