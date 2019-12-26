//
//  day23.swift
//  AoC
//
//  Created by Paul Landers
//

import Foundation

let runDay23 = false

class Network {
    var computers = [Intcode]()
    var inputQueues = [[(x:Int,y:Int)]](repeating: [(x: Int, y: Int)](), count: 50)
    var nat :(x: Int, y: Int)?
    var natDeliveriesY = Set<Int>()
    var natDoubleY :Int?
    
    init(nic: String) {
        for i in 0..<50 {
            let prog = Intcode(string: nic)
            prog.addInput(i)
            let _ = prog.run() // proccess the network address
            computers.append(prog)
        }
    }
    
    func runOnce() {
        for compIndex in 0..<50 {
            let comp = computers[compIndex]
            if inputQueues[compIndex].isEmpty {
                comp.addInput(-1)
            } else {
                for (x,y) in inputQueues[compIndex] {
                    comp.addInput(x)
                    comp.addInput(y)
                }
                inputQueues[compIndex].removeAll(keepingCapacity: true)
            }
            
            let _ = comp.run()
            let output = comp.output
            for i in stride(from: 0, to: output.count, by: 3) {
                let addr = output[i]
                let x = output[i+1]
                let y = output[i+2]
                if addr == 255 {
                    nat = (x,y)
                } else {
                    inputQueues[addr].append((x,y))
                }
            }
            
            comp.clearOutput()
        }
    }
    
    func runNat() {
        if 0 == inputQueues.count(where: {!$0.isEmpty}) {
            inputQueues[0].append(nat!)
            let natY = nat!.y
            if (natDeliveriesY.contains(natY)) {
                natDoubleY = natY
            }
            natDeliveriesY.insert(natY)
        }
    }
}

func day23 (_ input:String) -> Solution {
    var solution = Solution()
    
    let net = Network(nic: input)
    
    while net.nat == nil {
        net.runOnce()
    }
    
    solution.partOne = "\(net.nat!.y)"
    
    while net.natDoubleY == nil {
        net.runOnce()
        net.runNat()
    }
    
    solution.partTwo = "\(net.natDoubleY!)"
    return solution
}
