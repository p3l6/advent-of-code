//
//  graph.swift
//  AoC
//
//  Created by Paul Landers on 1/10/19.
//

import Foundation

/// Cannot contain duplicate nodes!
class Graph<T> where T:Hashable {
    class Node {
        let value :T
        var completed = false
        var inputs = [Node]()
        var outputs = [Node]()
        init(value: T) { self.value = value }
    }
    
    var nodes = [T:Node]()
    
    func addNode(_ val:T) -> Node {
        let newNode = Node(value: val)
        nodes[val] = newNode
        return newNode
    }
    
    func addEdge(from:T, to:T){
        let fromNode = nodes[from] ?? addNode(from)
        let toNode = nodes[to] ?? addNode(to)
        fromNode.outputs.append(toNode)
        toNode.inputs.append(fromNode)
    }
    
    func entryNodes() -> [Node] {
        return nodes.values.filter { $0.inputs.isEmpty }
    }
}
