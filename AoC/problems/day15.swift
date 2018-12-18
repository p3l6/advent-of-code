//
//  day15.swift
//  AoC
//
//  Created by Paul Landers
//

import Foundation

let runDay15 = true

protocol CavernPlaceable {
    var passable :Bool {get}
    var mapIcon :Character {get}
}

struct Empty : CavernPlaceable { var passable :Bool {return true}; var mapIcon: Character {return "."}}
struct Wall : CavernPlaceable { var passable :Bool {return false}; var mapIcon: Character {return "#"} }

enum Team {
    case Elf
    case Goblin
    var opponent :Team { return self == .Elf ? .Goblin : .Elf }
}

class Unit : CavernPlaceable {
    var passable :Bool {return false}
    var mapIcon: Character {return team == .Elf ? "E" : "G"}
    var hp :Int = 200
    var attackPower :Int = 3
    var location :Point
    let cavern :Cavern
    var alive = true
    let team : Team
    
    init(_ team: Team, in _cavern:Cavern, at:Point ) {
        self.team = team
        self.cavern = _cavern
        self.location = at
    }
    
    static func readingOrder(_ a:Unit, _ b:Unit) -> Bool { return Point.readingOrder(a.location, b.location)}
    
    /// returns false if no turn was taken, ie there are no targets
    func takeTurn() -> Bool {
        let targets = cavern.targets(team.opponent)
        guard !targets.isEmpty else { return false }
        
        var inRangeTargets = cavern.targets(team.opponent, inRangeOf:self.location)
        if inRangeTargets.isEmpty { //  MOVE
            
            var possibleDests = [Point]()
            for t in targets {
                possibleDests.append(contentsOf:t.location.adjacents())
            }
            possibleDests = possibleDests.filter({ cavern.grid[$0].passable })
            
            if let (direction, _, _) = cavern.closestPoint(from:self.location, to: possibleDests) {
                cavern.move(self, dir:direction)
                // recaculate targets
                inRangeTargets = cavern.targets(team.opponent, inRangeOf:self.location)
            }
        }
        
        if !inRangeTargets.isEmpty { // ATTACK
            let target = inRangeTargets.sorted(by: {$0.hp == $1.hp ? Point.readingOrder($0.location, $1.location) : $0.hp < $1.hp} ).first!
            target.damage(attackPower)
        }
        return true
    }
    
    func damage(_ damage:Int) {
        assert(alive)
        hp -= damage
        if hp <= 0 {
            alive = false
            cavern.grid[location] = Empty()
            let i = cavern.aliveUnits.firstIndex(where: {$0 === self} )!
            cavern.aliveUnits.remove(at: i)
        }
    }
}


class Cavern :CustomStringConvertible {
    var grid :FiniteGrid<CavernPlaceable>
    var roundsCompleted = 0
    var aliveUnits = [Unit]()
    var moveTriggeredPrint = false
    let area :Area
    
    init(_ area:Area) {
        self.area = area
        grid = FiniteGrid(defaultValue: Empty(), area: area)
    }
    
    /// returns true of combat should continue
    func combat() -> Bool {
        moveTriggeredPrint = false
        let orderedUnits = aliveUnits.sorted(by: Unit.readingOrder )
        for unit in orderedUnits {
            if !unit.alive {
                continue
            }
            if !unit.takeTurn() {
                return false // no targets
            }
        }
//        if moveTriggeredPrint { print(self) }
        roundsCompleted += 1
        return true
    }
    
    func targets(_ ofKind: Team) -> [Unit] {
        return aliveUnits.filter{$0.team == ofKind}
    }
    
    func targets(_ ofKind: Team, inRangeOf: Point) -> [Unit] {
        return aliveUnits.filter{
            $0.team == ofKind && (
                $0.location == inRangeOf + (0,1) ||
                $0.location == inRangeOf + (1,0) ||
                $0.location == inRangeOf + (0,-1) ||
                $0.location == inRangeOf + (-1,0)
        )}
    }
    
    func move(_ unit:Unit, dir: Direction) {
        let newPos = unit.location.move(dir)
        grid[unit.location] = Empty()
        grid[newPos] = unit
        unit.location = newPos
        moveTriggeredPrint = true
    }
    
    func closestPoint(from:Point, to:[Point]) -> (dir:Direction, dist:Int, pt:Point)? {
        let visited = FiniteGrid<(dir:Direction,dist:Int)>(defaultValue: (.north, -1), area: area)
        var toVisit = from.adjacents().filter { grid[$0].passable }
        var reached = [Point]()
        let p1 = from.move(.north) ; if  grid[p1].passable { visited[p1] = (.north, 1) }
        let p2 = from.move(.south) ; if  grid[p2].passable { visited[p2] = (.south, 1) }
        let p3 = from.move(.east) ; if  grid[p3].passable { visited[p3] = (.east, 1) }
        let p4 = from.move(.west) ; if  grid[p4].passable { visited[p4] = (.west, 1) }
        
        while !toVisit.isEmpty && reached.isEmpty {
            let thisVisit = toVisit.sorted(by: {visited[$0].dir.rawValue < visited[$1].dir.rawValue } )
            var nextVisit = [Point]()
            for p in thisVisit {
                let (dir, dist) = visited[p]
                assert( dist != -1 )
                if to.contains(p) {
                    reached.append(p)
                }
                for n in p.adjacents() {
                    if visited[n].dist != -1 || !grid[n].passable { continue }
                    visited[n] = (dir, dist+1)
                    nextVisit.append(n)
                }
            }
            toVisit = nextVisit
        }
        
        if !reached.isEmpty {
            let point = reached.sorted(by: Point.readingOrder ).first!
            let (dir, dist) = visited[point]
            return (dir,dist,point)
        }
        
        return nil
    }
    
    func hpSum() -> Int {
        return aliveUnits.reduce(0) { $0 + $1.hp }
    }
    
    func countTeam(_ t:Team) -> Int {
        return aliveUnits.reduce(0) { $1.team == t ? $0 + 1 : $0 }
    }
    
    var description: String {
        var s = ""
        for y in 0..<area.height {
            for x in 0..<area.width {
                s.append(grid[Point(x,y)].mapIcon)
            }
            s += "\n"
        }
        return s
    }
}

func day15 (_ input:String) -> Solution {
    Direction.defaultOrigin = .topLeft
    
    func loadInput(lines:[String], elfPower:Int = 3) -> Cavern {
        let area = Area(at: Point(0,0), w: lines.first!.count, h: lines.count)
        let cavern = Cavern(area)
    
        for point in area {
            switch lines[point.y][point.x] {
            case "#":
                cavern.grid[point] = Wall()
            case "G":
                let unit = Unit(.Goblin, in:cavern, at:point)
                cavern.aliveUnits.append(unit)
                cavern.grid[point] = unit
            case "E":
                let unit = Unit(.Elf, in:cavern, at:point)
                unit.attackPower = elfPower
                cavern.aliveUnits.append(unit)
                cavern.grid[point] = unit
            case ".":
                continue
            default:
                assertionFailure("Unexpected character: '\(lines[point.y][point.x])'")
            }
        }
        return cavern
    }
        
    let lines = input.lines()
    var cavern = loadInput(lines: lines)
    let initialElves = cavern.countTeam(.Elf)
    
//    print(cavern)
    while cavern.combat() {}
    var solution = Solution()
    solution.partOne = "\(cavern.roundsCompleted * cavern.hpSum())"
    
    var bisectLow = 3
    var bisectHigh = 200 // One hit K/O
    while bisectLow + 1 != bisectHigh {
        let elfAttack = (bisectHigh + bisectLow) / 2
        var elvesLost = false
        cavern = loadInput(lines: lines, elfPower: elfAttack)
        while cavern.combat() {
            if cavern.countTeam(.Elf) != initialElves {
                elvesLost = true
                break
            }
        }
        if elvesLost {
            bisectLow = elfAttack
        } else {
            bisectHigh = elfAttack
        }
    }
    print("elf attack power: \(bisectHigh)")
    cavern = loadInput(lines: lines, elfPower: bisectHigh)
    while cavern.combat() {}
    solution.partTwo = "\(cavern.roundsCompleted * cavern.hpSum())"
    return solution
}
