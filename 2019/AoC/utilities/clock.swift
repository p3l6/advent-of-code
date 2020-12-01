//
//  clock.swift
//  AoC
//
//  Created by Paul Landers on 1/10/19.
//

import Foundation

class TicToc {
    var startTime :DispatchTime
    let name :String
    init(named: String) {
        startTime = DispatchTime.now()
        name = named
    }
    
    func start() {
        startTime = DispatchTime.now()
    }
    
    func end() {
        let nanoTime = DispatchTime.now().uptimeNanoseconds - startTime.uptimeNanoseconds
        let timeInterval = nanoTime / 1_000_000
        print("\(name) took \(timeInterval) ms")
    }
}
