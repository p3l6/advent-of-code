//
//  grid.swift
//  AoC
//
//  Created by Paul Landers on 1/10/19.
//

import Foundation

// uses cartesian coordinates
class InfiniteGrid<T> {
    var grid = [Point: T]()
    let defaultValue :T
    
    init(defaultValue:T) {
        self.defaultValue = defaultValue
    }
    
    subscript (p: Point) -> T {
        get {
            if let thing = grid[p] {
                return thing
            }
            return defaultValue
        }
        set {
            grid[p] = newValue
        }
    }
    
    func forEach(_ body: (Point, T) throws -> Void ) rethrows {
        for (point, value) in grid {
            try body(point,value)
        }
    }
}

// Uses top down coodinates
class FiniteGrid<T> {
    var grid :[[T]]
    let area :Area
    
    init(defaultValue:T, area:Area) {
        self.area = area
        let repeatRow = [T](repeating:defaultValue, count:area.width)
        self.grid = [[T]](repeating: repeatRow, count: area.height)
    }
    
    subscript(_ at: Point) -> T {
        get { return grid[at.y - area.start.y][at.x - area.start.x] }
        set { grid[at.y - area.start.y][at.x - area.start.x] = newValue }
    }
    
    func stringBy(_ mapping:(T)->Character) -> String {
        var s = ""
        for y in area.start.y..<area.start.y + area.height {
            for x in area.start.x..<area.start.x + area.width {
                s.append(mapping(self[Point(x,y)]))
            }
            s += "\n"
        }
        return s
    }
}
