//
//  day13.swift
//  AoC
//
//  Created by Paul Landers
//

import Foundation

let runDay13 = false

class Railway :CustomStringConvertible {
    class Track {
        enum TrackType {
            case NorthSouth
            case EastWest
            case Curve
            case Intersection
            case None
        }
        func goesInDirectionPerpendicular(to dir:Direction) -> Bool {
            switch type {
            case .EastWest: return dir == .north || dir == .south
            case .NorthSouth: return dir == .east || dir == .west
            case .Intersection: return true
            case .None, .Curve: return false
            }
        }
        init(type: TrackType) {
            self.type = type
        }
        let type: TrackType
        var occupied = false
    }
    class Cart {
        var position :Point
        var direction :Direction
        var turns = 0
        var crashed = false
        init(pos:Point, dir:Direction) {
            position = pos
            direction = dir
        }
        func turnAtIntersection() {
            switch turns % 3 {
            case 0:
                direction = direction.left
            case 2:
                direction = direction.right
            default: break
            }
            turns += 1
        }
    }
    
    var tracks :FiniteGrid<Track>
    var carts = [Cart]()
    let area :Area
    var ticks = 0
    
    init(_ area:Area) {
        tracks = FiniteGrid(defaultValue: Track(type:.None), area: area)
        self.area = area
    }
    
    func addCart(at: Point, dir: Direction) {
        carts.append(Railway.Cart(pos:at, dir:dir))
        let type = dir == .north || dir == .south ? Track.TrackType.NorthSouth : Track.TrackType.EastWest
        let newTrack = Railway.Track(type:type)
        newTrack.occupied = true
        tracks[at] = newTrack
    }
    
    func tick() {
//        print(self)
        carts.sort(by: {$0.position.y == $1.position.y ? $0.position.x < $1.position.x : $0.position.y < $1.position.y})
        for cart in carts {
            if cart.crashed { continue }
            let nextPos = cart.position.move(cart.direction)
            let nextTrack = tracks[nextPos]
            let thisTrack = tracks[cart.position]
            switch nextTrack.type {
            case .Intersection:
                cart.turnAtIntersection()
            case .Curve :
                let rightPoint = nextPos.move(cart.direction.right)
                let leftPoint = nextPos.move(cart.direction.left)
                let canGoRight = area.contains(rightPoint) && tracks[rightPoint].goesInDirectionPerpendicular(to:cart.direction)
                let canGoLeft = area.contains(leftPoint) && tracks[leftPoint].goesInDirectionPerpendicular(to:cart.direction)
                assert(!(canGoLeft && canGoRight))
                if canGoRight {
                    cart.direction = cart.direction.right
                } else if canGoLeft {
                    cart.direction = cart.direction.left
                } else {
                    assertionFailure("Nowhere to turn")
                }
            case .None:
                assertionFailure("Algorithm is off the rails")
            default: break
            }
            cart.position = nextPos
            
            if nextTrack.occupied {
                cart.crashed = true
                let otherCart = carts.first(where: { $0.position == nextPos && !$0.crashed })!
                otherCart.crashed = true
                thisTrack.occupied = false
                nextTrack.occupied = false
            } else {
                thisTrack.occupied = false
                nextTrack.occupied = true
            }
        }

        ticks += 1
    }
    
    func crashSites() -> [Point] {
        return carts.filter({$0.crashed}).map({$0.position}).removeDuplicates()
    }
    
    func remainingCarts() -> [Cart] {
        return carts.filter({!$0.crashed})
    }
    
    var description: String {
        var s = ""
        for y in 0..<area.height {
            for x in 0..<area.width {
                let p = Point(x,y)
                if let cart = carts.first(where:{$0.position==p}) {
                    switch cart.direction {
                    case .north: s += "^"
                    case .south: s += "v"
                    case .east: s += ">"
                    case .west: s += "<"
                    }
                }else {
                    switch tracks[p].type {
                    case .NorthSouth: s += "|"
                    case .EastWest: s += "-"
                    case .Curve: s += "/"
                    case .Intersection: s += "+"
                    default: s += " "
                    }
                }
            }
            s += "\n"
        }
        return s
    }
}

func day13 (_ input:String) -> Solution {
    var solution = Solution()
    Direction.defaultOrigin = .topLeft
    
    let lines = input.split(separator:"\n").map { String($0) } // my default splitter strips the leading whitespace
    let height = lines.count
    let width = lines.map({$0.count}).max()!
    let area = Area(at: Point(0,0), w: width, h: height)
    let rail = Railway(area)
    
    for point in area {
        switch lines[point.y][point.x] {
        case "|":
            rail.tracks[point] = Railway.Track(type:.NorthSouth)
        case "-":
            rail.tracks[point] = Railway.Track(type:.EastWest)
        case "+":
            rail.tracks[point] = Railway.Track(type:.Intersection)
        case "\\","/":
            rail.tracks[point] = Railway.Track(type:.Curve)
        case "v":
            rail.addCart(at: point, dir:.south)
        case "<":
            rail.addCart(at: point, dir:.west)
        case ">":
            rail.addCart(at: point, dir:.east)
        case "^":
            rail.addCart(at: point, dir:.north)
        case " ", "":
            continue
        default:
            assertionFailure("unknown character: '\(lines[point.y][point.x])'")
        }
    }
    
    while rail.crashSites().count == 0 {
        rail.tick()
    }
    
    let firstCrash = rail.crashSites().first!
    solution.partOne = "\(firstCrash.x),\(firstCrash.y)"
    
    while rail.remainingCarts().count > 1 {
        rail.tick()
    }
    
    if let lastCart = rail.remainingCarts().first {
        solution.partTwo = "\(lastCart.position.x),\(lastCart.position.y)"
    }
    
    return solution
}
