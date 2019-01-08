//
//  day20.swift
//  AoC
//
//  Created by Paul Landers
//

import Foundation

let runDay20 = true

func matchFirstParen(_ s:Substring) -> String.Index {
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
    
    struct Fork {
        let loc :Point
        let start :String.Index
        let end :String.Index
        
        static func split(_ subStr:Substring, from:Point, parent:Fork) -> [Fork] {
            var forks = [Fork]()
            var parenCount = 0
            
            var start = subStr.startIndex
            var index = subStr.startIndex
            
            while index != subStr.endIndex {
                switch subStr[index] {
                case "(":
                    parenCount += 1
                case ")":
                    parenCount -= 1
                case "|":
                    if parenCount == 0 {
                        forks.append(Fork(loc: from, start: start, end: index))
                        start = subStr.index(after: index)
                    }
                default: break
                }
                index = subStr.index(after: index)
            }
            forks.append(Fork(loc: from, start: start, end: subStr.endIndex))
            return forks
        }
    }
    
    init(pathsRegex:String) {
        // create Branch object structure
        let mainBranch = Fork(loc: origin, start: pathsRegex.startIndex, end: pathsRegex.endIndex)
        
        var branchStack = Stack<Fork>()
        branchStack.push(mainBranch)
        
        // Build an infinite map of layout
        let imap = InfiniteGrid<MapSquare>(defaultValue:MapSquare.unknown)
        imap[origin] = .room
        
        while !branchStack.isEmpty {
            let fork = branchStack.pop()
            var loc = fork.loc
            var index = fork.start
            toNextFork: while index != fork.end {
                let char = pathsRegex[index]
                let nextIndex = pathsRegex.index(after: index)
                var d = Direction.north
                switch char {
                case "^": index = nextIndex; continue
                case "$", ")", "|": break toNextFork
                case "N":  d = .north
                case "E":  d = .east
                case "S":  d = .south
                case "W":  d = .west
                case "(":
                    let paren = matchFirstParen(pathsRegex[index..<pathsRegex.endIndex])
                    let afterFork = pathsRegex.index(after: paren)
                    Fork.split(pathsRegex[nextIndex..<paren], from:loc, parent:fork).forEach { branchStack.push($0) }
                    branchStack.push(Fork(loc: loc, start: afterFork, end: pathsRegex.endIndex))
                    break toNextFork
                default: assertionFailure("unexpected character in branch: \(char)")
                }
                loc = loc.move(d)
                imap[loc] = .door
                loc = loc.move(d)
                imap[loc] = .room
                index = nextIndex
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
//    print(base)
    
    let minDistances = base.roomDistances()
    let farthest = minDistances.reduce((room:Point(0,0),dist:0)) { (max, roomDist) -> (room:Point,dist:Int) in
        return roomDist.dist > max.dist ? roomDist : max
    }
    
    var solution = Solution()
    solution.partOne = "\(farthest.dist)"
    
    let count1000 = minDistances.filter({$0.value >= 1000 }).count
    
    solution.partTwo = "\(count1000)"
    return solution
}
