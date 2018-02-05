//
//  NFXPathNode.swift
//  netfox_ios
//
//  Created by Ștefan Suciu on 2/5/18.
//  Copyright © 2018 kasketis. All rights reserved.
//

import Foundation

class NFXPathNode {
    
    var name: String
    var children: [NFXPathNode]
    weak var parent: NFXPathNode?
    
    init(name: String) {
        self.name = name
        self.children = []
    }
    
    func insert(_ node: NFXPathNode) {
        children.append(node)
        node.parent = self
    }
    
    func find(_ node: NFXPathNode) -> NFXPathNode? {
        if name == node.name {
            return self
        }
        
        return children.flatMap{ $0.find(node) }.first
    }
    
    func printTree(_ level: Int = 0) {
        print(String(repeating: " ", count: level) + name)
        for child in children {
            child.printTree(level + 4)
        }
    }
}
