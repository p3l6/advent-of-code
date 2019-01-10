//
//  day23.swift
//  AoC
//
//  Created by Paul Landers
//

import Foundation

let runDay23 = false

struct Cube {
    let min :SpacePoint
    let side :Int
    let originDistance :Int
    
    static var bots = [Nanobot]()
    let botCache :Int
    
    init(min:SpacePoint, side:Int) {
        self.min = min
        self.side = side
        self.originDistance = min.taxi(to: SpacePoint(0,0,0))
        self.botCache = Cube.bots.count(where: { $0.inRangeCubeComponents(min, side) })
    }
    
    func split() -> [Cube] {
        let half = side/2
        return [Cube(min: min, side: half),
                Cube(min: min+(0,half,0), side: half),
                Cube(min: min+(0,0,half), side: half),
                Cube(min: min+(half,0,0), side: half),
                Cube(min: min+(0,half,half), side: half),
                Cube(min: min+(half,half,0), side: half),
                Cube(min: min+(half,0,half), side: half),
                Cube(min: min+(half,half,half), side: half)]
    }
    
    func botsInRange(_ bots:[Nanobot]) -> Int {
        return bots.reduce(0) { $1.inRange(self) ? $0 + 1 : $0 }
    }
}

func cubeBounding(_ points:[SpacePoint]) -> Cube {
    var lowest = (x:points.first!.x, y:points.first!.y ,z:points.first!.z)
    var highest = lowest
    for p in points {
        if p.x < lowest.x  { lowest.x  = p.x }
        if p.x > highest.x { highest.x = p.x }
        if p.y < lowest.y  { lowest.y  = p.y }
        if p.y > highest.y { highest.y = p.y }
        if p.z < lowest.z  { lowest.z  = p.z }
        if p.z > highest.z { highest.z = p.z }
    }
    let maxDiff = max(highest.x-lowest.x, highest.y-lowest.y, highest.z-lowest.z)
    var size = 2
    while size < maxDiff { size *= 2 }
    let origin = SpacePoint(lowest.x,lowest.y,lowest.z)
    return Cube(min: origin, side: size)
}

struct Nanobot {
    let pos: SpacePoint
    let radius :Int
    func inRange(_ loc:SpacePoint) -> Bool {
        return pos.taxi(to: loc) <= radius
    }
    
    func inRange(_ cube:Cube) -> Bool {
        return self.inRangeCubeComponents(cube.min, cube.side)
    }
    
    func inRangeCubeComponents(_ min:SpacePoint, _ side: Int) -> Bool {
        let clamped = SpacePoint(pos.x < min.x ? min.x : pos.x > min.x + side - 1 ? min.x + side - 1 : pos.x,
                                 pos.y < min.y ? min.y : pos.y > min.y + side - 1 ? min.y + side - 1 : pos.y,
                                 pos.z < min.z ? min.z : pos.z > min.z + side - 1 ? min.z + side - 1 : pos.z)
        return self.inRange(clamped)
    }
}

func day23 (_ input:String) -> Solution {
    var solution = Solution()
    
    let bots : [Nanobot] = input.lines().map {
        let x = $0.extract(format: "pos=<%,%,%>, r=%")!
        return Nanobot(pos:SpacePoint(x[0],x[1],x[2]), radius:x[3])
    }
    
    let maxBot :Nanobot = bots.reduce(bots.first!, {$0.radius < $1.radius ? $1 : $0} )
    let count = bots.count(where: { maxBot.inRange($0.pos) })
    
    solution.partOne = "\(count)"

    // Got a hint:
    // Create a cube surrounding all bots
    // Repeatedly
    //   divide cube into eight (half in each direction)
    //   continue with the cube that has the most bots in range.
    // When the cube is 1x1x1, return that point.
    // Next hint:
    //   Use a heap (ie heapsort)
    //     first sorted by boxes with the most bots, ties broken on smallest, ties broken on closest to origin
    //   Just add all the subcubes to that heap
    let origin = SpacePoint(0,0,0)
    Cube.bots = bots
  
    var cube = cubeBounding(bots.map({$0.pos}))
    var cubes = Heap<Cube>() { (a, b) -> Bool in
        if a.botCache != b.botCache { return a.botCache > b.botCache }
        if a.side != b.side {  return a.side < b.side }
        return  a.originDistance < b.originDistance
    }
    cubes.enqueue(cube)
    
    while !cubes.isEmpty {
        cube = cubes.dequeue()!
        if cube.side == 1 {
            break
        }
        cube.split().forEach { cubes.enqueue($0) }
    }
    
//    print(cube.min, cube.botsInRange(bots))
    solution.partTwo = "\(cube.min.taxi(to: origin))"
    return solution
}
