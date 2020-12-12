
import Foundation

let runDay12 = false

func day12 (_ input:String) -> Solution {
    var solution = Solution()
    
    let directions: [(Character, Int)] = input.lines().map {
        let char = $0.first!
        let dist = Int($0.substring(fromIndex: 1))!
        return (char, dist)
    }
    
    let start = Point(0,0)
    var dir = Direction.east
    var loc = start
    
    for (char, dist) in directions {
        switch char {
        case "N": loc = loc.move(.north, by: dist)
        case "S": loc = loc.move(.south, by: dist)
        case "E": loc = loc.move(.east, by: dist)
        case "W": loc = loc.move(.west, by: dist)
        case "L": for _ in 0..<(dist/90) { dir = dir.left }; continue
        case "R": for _ in 0..<(dist/90) { dir = dir.right }; continue
        case "F": loc = loc.move(dir, by: dist)
        default: print("[ERROR] Unexpected character in input")
        }
    }
    
    solution.partOne = "\(loc.taxi(to: start))"
    
    dir = Direction.east
    loc = start
    var waypoint = Point(10,1)
    
    for (char, dist) in directions {
        switch char {
        case "N": waypoint = waypoint.move(.north, by: dist)
        case "S": waypoint = waypoint.move(.south, by: dist)
        case "E": waypoint = waypoint.move(.east, by: dist)
        case "W": waypoint = waypoint.move(.west, by: dist)
        case "L": for _ in 0..<(dist/90) { waypoint = Point(-waypoint.y, waypoint.x) }
        case "R": for _ in 0..<(dist/90) { waypoint = Point(waypoint.y, -waypoint.x) }
        case "F": for _ in 0..<dist { loc = loc + (waypoint.x, waypoint.y) }
        default: print("[ERROR] Unexpected character in input")
        }
    }
    
    solution.partTwo = "\(loc.taxi(to: start))"
    return solution
}

