//
//  main.swift
//  AoC
//

// https://developer.apple.com/library/content/documentation/Swift/Conceptual/Swift_Programming_Language/GuidedTour.html

import Foundation
let execTime = TicToc(named:"Today's problems")

let input = puzzleInput

class Particle :Equatable{
    struct Vector :Hashable{
        let x:Int; let y:Int; let z:Int
        init(x:Int, y:Int, z:Int) { self.x = x; self.y = y; self.z = z }
        init(_ x:[Int]) { self.init(x: x[0], y: x[1], z: x[2]) }
        static func +  (a:Vector, b:Vector) -> Vector { return Vector(x:a.x+b.x, y:a.y+b.y, z:a.z+b.z) }
        static func += (a:inout Vector, b:Vector) { a = a + b }
        static func == (a:Vector, b:Vector) -> Bool { return  a.x == b.x && a.y==b.y && a.z==b.z }
        var hashValue: Int { return x.hashValue ^ y.hashValue ^ z.hashValue }
    }
    
    var number :Int = 0
    var position :Vector
    var velocity :Vector
    var acceleration: Vector
    var distance :Int {return abs(position.x)+abs(position.y)+abs(position.z)}
    
    init(p:Vector, v:Vector, a:Vector) {
        position = p
        velocity = v
        acceleration = a
    }
    
    func step(_ n:Int) {
        for _ in 0..<n {
            velocity += acceleration
            position += velocity
        }
    }
    
    static func == (a:Particle, b:Particle) -> Bool { return  a.position == b.position && a.velocity==b.velocity && a.acceleration==b.acceleration }
}

//p=<898,3116,-155>, v=<129,448,-25>, a=<-8,-30,-2>
var particles : [Particle] = input.split(separator: "\n").map {
    let vecs = $0.split(separator: " ")
    let p = String(vecs[0])[3..<(vecs[0].count-2)].integerArray(",")
    let v = String(vecs[1])[3..<(vecs[1].count-2)].integerArray(",")
    let a = String(vecs[2])[3..<(vecs[2].count-1)].integerArray(",")
    return Particle(p: Particle.Vector(p), v: Particle.Vector(v), a: Particle.Vector(a))
}

for i in 0..<particles.count { particles[i].number = i }

var destroyed = [Particle]()
var lastCollision = 0
var steps = 0
while steps - lastCollision < 1000 {
    var collisionMap  :[Particle.Vector:[Particle]] = [:]
    for p in particles {
        if collisionMap[p.position] == nil { collisionMap[p.position] = [] }
        collisionMap[p.position]!.append(p)
    }
    for (_, list) in collisionMap {
        if list.count > 1 {
            lastCollision = steps
            for p in list {
                particles.remove(at: particles.index(of:p)!)
                destroyed.append(p)
            }
        }
    }
    
    steps += 1
    particles.forEach { $0.step(1) }
    destroyed.forEach { $0.step(1) }
}

let farthest = (particles+destroyed).min { (a, b) -> Bool in a.distance < b.distance }

print("part one: \(farthest!.number)") // 344
print("part two: \(particles.count)")  // 404

execTime.end()
