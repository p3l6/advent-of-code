//
//  stack.swift
//  AoC
//
//  Created by Paul Landers on 1/10/19.
//

import Foundation


struct Stack<Element> {
    private var items = [Element]()
    var isEmpty :Bool { return items.count == 0 }
    var count :Int { return items.count }
    
    mutating func push(_ item: Element) {
        items.append(item)
    }
    mutating func pop() -> Element {
        return items.removeLast()
    }
    func peek() -> Element {
        return items.last!
    }
}

