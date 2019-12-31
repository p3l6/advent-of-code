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
        return found.contains(char.lowercased())
    }
    
    var isComplete :Bool {
        return found == required
    }
    
    var description :String {
        return found.sorted().joined()
    }
}

class Vault {
    enum VaultTile {
        case entrance
        case key
        case door
        case wall
        case empty
    }
    typealias Graph = [(primary: String, next: String, length:Int)]
    
    let map :FiniteGrid<VaultTile>
    let keys :[Point:String]
    let doors :[Point:String]
    let entrance :Point
    let baseKeyState :KeyState
    
    init(map inputMap: String) {
        let lines = inputMap.lines()
        
        let area = Area(at: Point(0,0), w: lines.first!.count, h: lines.count)
        map = FiniteGrid(defaultValue: VaultTile.wall, area: area)

        var baseKeyState = KeyState()
        var keys = [Point:String]()
        var doors = [Point:String]()
        var entrance = Point(0,0)
        
        for p in area {
            let char = lines[p.y][p.x]
            switch char {
            case "#":
                map[p] = .wall
            case ".":
                map[p] = .empty
            case "@":
                map[p] = .entrance
                entrance = p
            case "a"..."z":
                map[p] = .key
                keys[p] = char
                baseKeyState = baseKeyState.requiring(char)
            case "A"..."Z":
                map[p] = .door
                doors[p] = char //.lowercased()
            default:
                assertionFailure("Unexpected map character")
            }
        }
        
        self.entrance = entrance
        self.keys = keys
        self.doors = doors
        self.baseKeyState = baseKeyState
    }
    
    func vaultSearch(start: Point, id: String) -> Graph {
        var graph = Graph()
        let visited = FiniteGrid(defaultValue: false, area: map.area)
        var toVisit = [Point]()
        toVisit.append(start)
        var depth = 0
        while !toVisit.isEmpty {
            var nextVisit = [Point]()
            let nDepth = depth+1
            for v in toVisit {
                visited[v] = true
                for n in v.adjacents() {
                    if visited[n] { continue }
                    switch map[n] {
                    case .entrance: graph.append((id, "@", nDepth))
                    case .door: graph.append((id, doors[n]!, nDepth))
                    case .key: graph.append((id, keys[n]!, nDepth))
                    case .empty: nextVisit.append(n)
                    case .wall: break
                    }
                }
            }
            depth = nDepth
            toVisit = nextVisit
        }
        return graph
    }

    func graph() -> Graph {
        var graph = Graph()
        for (loc, key) in keys {
            graph.append(contentsOf: vaultSearch(start: loc, id: key))
        }
        for (loc, door) in doors {
            graph.append(contentsOf: vaultSearch(start: loc, id: door))
        }
        graph.append(contentsOf: vaultSearch(start: entrance, id: "@"))
        return graph
    }
}

func day18 (_ input:String) -> Solution {
    var solution = Solution()
    
    let vault = Vault(map: input)
    
    let graph = vault.graph()
    var filteredGraph = [String:Vault.Graph]()
    for primary in vault.keys.values { filteredGraph[primary] = graph.filter({ $0.primary == primary }) }
    for primary in vault.doors.values { filteredGraph[primary] = graph.filter({ $0.primary == primary }) }
    filteredGraph["@"] = graph.filter({ $0.primary == "@" })
    
    var toVisit = [(String, Int, String?, KeyState)]()
    toVisit.append(("@", 0, nil, vault.baseKeyState))
    
    var minDist = Int.max
    var visited = Set<String>()
    
    while !toVisit.isEmpty {
        var nextVisit = [(String, Int, String?, KeyState)]()
        for (node, visitDist, prevNode, state) in toVisit {
        
            let unique = "\(node),\(state)"
            if visited.contains(unique) { continue }
            visited.insert(unique)
        
            for (_, nextNode, separation) in filteredGraph[node]! {
                if let p = prevNode, nextNode == p {
                    continue
                }
                
                let nextDist = visitDist + separation
                if nextDist >= minDist {
                    continue
                }
            
                switch nextNode {
                case "@":
                    nextVisit.append((nextNode, nextDist, node, state))
                case "a"..."z":
                    let newState = state.finding(nextNode)
                    if newState.isComplete {
                        minDist = min(nextDist, minDist)
                    } else {
                        nextVisit.append((nextNode, nextDist, state.has(nextNode) ? node : nil, newState))
                    }
                case "A"..."Z":
                    if state.has(nextNode) {
                        nextVisit.append((nextNode, nextDist, node, state))
                    }
                default: assertionFailure("Unexpected node")
                }
            }
        }
        toVisit = nextVisit
    }
    
    solution.partOne = "\(minDist)"
//    solution.partTwo = "\()"
    return solution
}
