//
//  NFXPathNode.swift
//  netfox_ios
//
//  Created by Ștefan Suciu on 2/5/18.
//  Copyright © 2018 kasketis. All rights reserved.
//

import Foundation

#if os(OSX)
    
class NFXPathNode {
    
    var name: String
    var children: [NFXPathNode]
    weak var parent: NFXPathNode?
    var httpModel: NFXHTTPModel?
    var isExpanded: Bool
    
    init(name: String) {
        self.name = name
        self.children = []
        self.isExpanded = true
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
    
    func depth() -> Int {
        if parent == nil {
            return 0
        }
        
        return parent!.depth() + 1
    }
    
    func findLeaves() -> [NFXHTTPModel] {
        if children.isEmpty {
            return httpModel != nil ? [httpModel!] : []
        }
        
        return children.map{ $0.findLeaves() }.reduce([], +)
    }
    
    func toArray() -> [NFXPathNode] {
        if !isExpanded {
            return [self]
        }
        
        return [self] + children.map{ $0.toArray() }.reduce([], +)
    }
    
    func printTree(_ level: Int = 0) {
        print(String(repeating: " ", count: level) + "\(name) -> \(httpModel?.requestURL ?? "")")
        for child in children {
            child.printTree(level + 4)
        }
    }
}

#endif
