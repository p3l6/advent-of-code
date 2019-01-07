//
//  day20.swift
//  AoC
//
//  Created by Paul Landers
//

import Foundation

let runDay20 = true

func matchFirstParen(_ s:String) -> String.Index {
    var index = s.firstIndex(of: "(")!
    index = s.index(after: index)
    var parenCount = 1
    
    while index != s.endIndex {
        switch s[index] {
        case "(":
            parenCount += 1
        case ")":
            parenCount -= 1
            if parenCount == 0 {
                return index
            }
        default: break
        }
        index = s.index(after: index)
    }
    
    assertionFailure("Matching paren not found")
    return s.endIndex
}

class NorthBase :CustomStringConvertible {
    enum MapSquare {
        case wall
        case room
        case door
        case unknown
    }
    
    let map :FiniteGrid<MapSquare>
    let area :Area
    let origin = Point(0,0)
    
    typealias PathGraph = Graph<[Direction]>
    
    private static func recursiveCreateNodes(branchSet:String, graph:PathGraph) -> [PathGraph.Node] {
        return []
    }
    
    struct Branch {
        let path :String
        let forks :[Branch]
        
        init(path:String) {
            guard let nextFork = path.firstIndex(of:"(") else {
                self.path = path
                self.forks = []
                return
            }
            
            self.path = String(path[..<nextFork])
            let matchingIndex = matchFirstParen(path)
            let branches = Branch.components(String(path[path.index(after:nextFork) ..< matchingIndex]))
            let remainder = String(path[path.index(after: matchingIndex)..<path.endIndex])
            
            self.forks = branches.map { branch in
                return Branch(path: branch + remainder)
            }
        }
        
        private static func components(_ subStr:String) -> [String] {
            var strings = [String]()
            var buffer = ""
            var parenCount = 0
            for c in subStr {
                switch c {
                case "(":
                    buffer.append(c)
                    parenCount += 1
                case ")":
                    buffer.append(c)
                    parenCount -= 1
                case "|":
                    if parenCount == 0 {
                        strings.append(buffer)
                        buffer = ""
                    } else {
                        buffer.append(c)
                    }
                default:
                    buffer.append(c)
                }
            }
            strings.append(buffer)
            return strings
        }
    }
    
    
    init(pathsRegex:String) {
        // create Branch object structure
        let mainBranch = Branch(path: pathsRegex)
        
        var branchStack = Stack<(loc:Point, branch:Branch)>()
        branchStack.push((origin,mainBranch))
        
        // Build an infinite map of layout
        let imap = InfiniteGrid<MapSquare>(defaultValue:MapSquare.unknown)
        imap[origin] = .room
        
        while !branchStack.isEmpty {
            let (branchOrigin, branch) = branchStack.pop()
            var loc = branchOrigin
            for char in branch.path {
                var d = Direction.north
                switch char {
                case "^","$": continue
                case "N":  d = .north
                case "E":  d = .east
                case "S":  d = .south
                case "W":  d = .west
                default: assertionFailure("unexpected character in branch: \(char)")
                }
                loc = loc.move(d)
                imap[loc] = .door
                loc = loc.move(d)
                imap[loc] = .room
            }
            for fork in branch.forks {
                branchStack.push((loc,fork))
            }
        }
        
        // Calculate size of imap
        area = Area(asBoundingBoxOf: Array(imap.grid.keys)).outset(by: (1,1))
        // Create finite grid, defaulted to walls
        map = FiniteGrid(defaultValue: .wall, area: area)
        // set each point in map from imap
        imap.forEach { (p, square) in map[p] = square }
    }
    
    func roomDistances() -> [Point:Int] {
        // length of shortest path to each room
        // length is number of doors to pass through
        let visited = FiniteGrid<Int>(defaultValue: -1, area: area)
        visited[origin] = 0
        
        var toVisit = [origin]
        var reached = [Point:Int]()
        var distance = 0
        
        while !toVisit.isEmpty {
            let thisVisit = toVisit
            var nextVisit = [Point]()
            
            for p in thisVisit {
                reached[p] = distance
                for d in [Direction.north, .south, .east, .west] {
                    let maybeDoor = p.move(d)
                    let maybeRoom = maybeDoor.move(d)
                    if map[maybeDoor] == .door && reached[maybeRoom] == nil {
                       nextVisit.append(maybeRoom)
                    }
                }
            }
            distance += 1
            toVisit = nextVisit
        }
        
        return reached
    }
    
    var description: String {
        return map.stringBy({ (square) -> Character in
            switch square {
            case .wall: return "#"
            case .room: return "."
            case .door: return "|"
            case .unknown: return "?"
            }
        })
    }
}

func day20 (_ input:String) -> Solution {
    Direction.defaultOrigin = .topLeft
    
    let base = NorthBase(pathsRegex:input)
    print(base)
    
    let minDistances = base.roomDistances()
    let farthest = minDistances.reduce((room:Point(0,0),dist:0)) { (max, roomDist) -> (room:Point,dist:Int) in
        return roomDist.dist > max.dist ? roomDist : max
    }
    
    var solution = Solution()
    solution.partOne = "\(farthest.dist)"
//    solution.partTwo = "\()"
    return solution
}
