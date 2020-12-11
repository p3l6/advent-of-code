//
//  geometry.swift
//  AoC
//
//  Created by Paul Landers on 1/10/19.
//

import Foundation

enum Direction :Int {
    static var defaultOrigin = Direction.Origin.bottomLeft
    
    enum Origin {
        case bottomLeft
        case topLeft
    }
    
    // Order matters now, so that they sort by "reading order"
    case north
    case west
    case east
    case south
    
    var right :Direction {
        switch self {
        case .north: return .east
        case .south: return .west
        case .east: return .south
        case .west: return .north
        }
    }
    
    var left :Direction {
        switch self {
        case .north: return .west
        case .south: return .east
        case .east: return .north
        case .west: return .south
        }
    }
    
    var back :Direction {
        switch self {
        case .north: return .south
        case .south: return .north
        case .east: return .west
        case .west: return .east
        }
    }
    
    static func all() -> [Direction] {
        return [.north, .south, .east, .west]
    }
}

struct Point :Hashable , CustomStringConvertible, CustomDebugStringConvertible{
    let x :Int
    let y :Int
    
    static func ==(a:Point, b:Point) -> Bool { return a.x==b.x && a.y==b.y }
    static func readingOrder (_ a:Point, _ b:Point) -> Bool { return a.y == b.y ? a.x < b.x : a.y < b.y }
    
    func move(_ d:Direction, origin:Direction.Origin = Direction.defaultOrigin) -> Point {
        switch d {
        case .north: return self + (origin == .bottomLeft ? (0, 1) : (0,-1))
        case .south: return self + (origin == .bottomLeft ? (0,-1) : (0, 1))
        case .east: return Point(x:x+1, y:y)
        case .west: return Point(x:x-1, y:y)
        }
    }
    
    /// Returns the 4 adjancent orthagonal points
    func adjacents() -> [Point] {
        return [Point(x:x+1, y:y),Point(x:x-1, y:y),Point(x:x, y:y+1),Point(x:x, y:y-1)]
    }
    
    /// Returns the 8 adjancent points, including diagonals
    func adjacent8() -> [Point] {
        return [Point(x:x+1, y:y),Point(x:x-1, y:y),Point(x:x, y:y+1),Point(x:x, y:y-1),
                Point(x:x+1, y:y+1),Point(x:x-1, y:y-1),Point(x:x-1, y:y+1),Point(x:x+1, y:y-1)]
    }
    
    init(_ x:Int, _ y:Int) {
        self.x = x
        self.y = y
    }
    init( x:Int,  y:Int) {
        self.x = x
        self.y = y
    }
    static func +(_ point:Point, _ additional:(x:Int,y:Int)) -> Point {
        return Point(point.x+additional.x,point.y+additional.y)
    }
    static func -(_ point:Point, _ additional:(x:Int,y:Int)) -> Point {
        return Point(point.x-additional.x,point.y-additional.y)
    }
    func taxi(to other:Point) -> Int {
        return abs(x-other.x) + abs(y-other.y)
    }
    var description: String { return "x:\(x), y:\(y)"}
    var debugDescription: String { return description }
}

/// Like Point, but in 3d space
struct SpacePoint :Hashable, CustomStringConvertible, CustomDebugStringConvertible{
    let x :Int
    let y :Int
    let z :Int
    
    static func ==(a:SpacePoint, b:SpacePoint) -> Bool { return a.x==b.x && a.y==b.y && a.z == b.z}
    
    init(_ x:Int, _ y:Int, _ z:Int) {
        self.x = x
        self.y = y
        self.z = z
    }
    
    static func +(_ point:SpacePoint, _ additional:(x:Int,y:Int,z:Int)) -> SpacePoint {
        return SpacePoint(point.x+additional.x,point.y+additional.y,point.z+additional.z)
    }
    static func -(_ point:SpacePoint, _ additional:(x:Int,y:Int,z:Int)) -> SpacePoint {
        return SpacePoint(point.x-additional.x,point.y-additional.y,point.z-additional.z)
    }
    func taxi(to other:SpacePoint) -> Int {
        return abs(x-other.x) + abs(y-other.y) + abs(z-other.z)
    }
    
    var description: String { return "x:\(x), y:\(y), z:\(z)"}
    var debugDescription: String { return description }
}

/// Like Point, but in 4d space
struct TimeSpacePoint :Hashable, CustomStringConvertible, CustomDebugStringConvertible{
    let x :Int
    let y :Int
    let z :Int
    let t :Int
    
    static func ==(a:TimeSpacePoint, b:TimeSpacePoint) -> Bool { return a.x==b.x && a.y==b.y && a.z == b.z && a.t == b.t}
    
    init(_ x:Int, _ y:Int, _ z:Int, _ t:Int) {
        self.x = x
        self.y = y
        self.z = z
        self.t = t
    }
    
    func taxi(to other:TimeSpacePoint) -> Int {
        var tax :Int = abs(x-other.x) + abs(y-other.y)
        tax += abs(z-other.z) + abs(t-other.t)
        return tax
    }
    
    var description: String { return "x:\(x), y:\(y), z:\(z), t:\(t)"}
    var debugDescription: String { return description }
}

struct Area :Sequence {
    let start :Point
    let width :Int
    let height :Int
    init(at:Point, w:Int, h:Int) {
        start = at
        width = w
        height = h
    }
    init(asBoundingBoxOf points:[Point]) {
        var min = (x:points.first!.x, y:points.first!.y)
        var max = min
        for p in points {
            if p.x < min.x { min.x = p.x }
            if p.x > max.x { max.x = p.x }
            if p.y < min.y { min.y = p.y }
            if p.y > max.y { max.y = p.y }
        }
        start = Point(min.x,min.y)
        width = max.x - min.x + 1
        height = max.y - min.y + 1
    }
    
    func outset(by: Int) -> Area {
        return self.outset(by: (by,by))
    }
    
    func outset(by: (w:Int,h:Int)) -> Area {
        return Area(at: start - (by.w,by.h), w: width + 2*by.w, h: height + 2*by.h)
    }
    
    // was called contains, but that is overriden by protocol "Sequence"
    func interior(_ point:Point) -> Bool {
        return start.x <= point.x && point.x < start.x + width &&
            start.y <= point.y && point.y < start.y + height
    }
    var area :Int {
        return height * width
    }
    
    func makeIterator() -> Area.Iterator {
        return Area.Iterator(self)
    }
    struct Iterator :IteratorProtocol{
        let area: Area
        var times = 0
        init(_ area: Area) {
            self.area = area
        }
        mutating func next() -> Point? {
            let yOffset = times / area.width
            guard yOffset < area.height
                else { return nil }
            let xOffset = times % area.width
            times += 1
            return area.start + (xOffset,yOffset)
        }
    }
}
