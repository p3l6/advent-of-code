//
//  day18.swift
//  AoC
//
//  Created by Paul Landers
//

import Foundation

let runDay18 = false

struct KeyState :CustomStringConvertible {
    let required :Set<String>
    let found :Set<String>
    
    init(required: Set<String>, found: Set<String>) {
        self.required = required
        self.found = found
    }
    
    init() {
        required = Set<String>()
        found = Set<String>()
    }
    
    func requiring(_ char: String) -> KeyState {
        var req = required
        req.insert(char)
        return KeyState(required: req, found: found)
    }
    
    func finding(_ char: String) -> KeyState {
        var fnd = found
        fnd.insert(char)
        return KeyState(required: required, found: fnd)
    }
    
    func has(_ char: String) -> Bool {
        return found.contains(char)
    }
    
    var isComplete :Bool {
        return found == required
    }
    
    var description :String {
        return found.sorted().joined()
    }
}

enum VaultTile {
    case entrance
    case key
    case door
    case wall
    case empty
}

func day18 (_ input:String) -> Solution {
    var solution = Solution()
    let lines = input.lines()
    
    let area = Area(at: Point(0,0), w: lines.first!.count, h: lines.count)
    let map = FiniteGrid(defaultValue: VaultTile.wall, area: area)
    var pos = Point(0,0)

    var state = KeyState()
    var keys = [Point:String]()
    var doors = [Point:String]()
    
    for p in area {
        let char = lines[p.y][p.x]
        switch char {
        case "#":
            map[p] = .wall
        case ".":
            map[p] = .empty
        case "@":
            map[p] = .entrance
            pos = p
        case "a"..."z":
            map[p] = .key
            keys[p] = char
            state = state.requiring(char)
        case "A"..."Z":
            map[p] = .door
            doors[p] = char.lowercased()
        default:
            assertionFailure("Unexpected map character")
        }
    }
    
    var toVisit = Stack<(Point, Int, Point?, KeyState)>()
    toVisit.push((pos, 0, nil, state))
    
    var minDist = Int.max
    
    var visited = [String:Int]()
    
    while !toVisit.isEmpty {
        let (loc, visitDist, previous, state) = toVisit.pop()
        let nDist = visitDist + 1
        if nDist >= minDist {
            continue
        }
        
        let unique = "\(loc.x),\(loc.y),\(state)"
        if let prevDist = visited[unique], prevDist <= nDist {
            continue
        }
        visited[unique] = nDist
        
        for n in loc.adjacents() {
            if let p = previous, n == p {
                continue
            }
            
            switch map[n] {
            case .entrance, .empty:
                toVisit.push((n, nDist, loc, state))
            case .key:
                let key = keys[n]!
                let newState = state.finding(key)
                if newState.isComplete {
                    minDist = min(nDist, minDist)
                } else {
//                    print("Found key \(keys[n]!) for state \(newState)")
                    toVisit.push((n, nDist, state.has(key) ? loc : nil, newState))
                }
            case .door:
//                print("Visiting door \(doors[n]!.uppercased()) with keys \(state)")
                if state.has(doors[n]!) {
                    toVisit.push((n, nDist, loc, state))
                }
            case .wall:
                break
            }
        }
    }
    
    solution.partOne = "\(minDist)"
//    solution.partTwo = "\()"
    return solution
}
