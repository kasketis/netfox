//
//  NFXPathNodeManager.swift
//  netfox_ios
//
//  Created by Ștefan Suciu on 2/5/18.
//  Copyright © 2018 kasketis. All rights reserved.
//

import Foundation

#if os(OSX)
    
final class NFXPathNodeManager {
    
    static let sharedInstance = NFXPathNodeManager()
    fileprivate var rootNode = NFXPathNode(name: "root")
    
    func add(_ arr: [NFXHTTPModel]) {
        arr.forEach{ add($0) }
    }
    
    func add(_ obj: NFXHTTPModel) {
        guard let nodes = obj.requestURL?.split(separator: "/").dropFirst().map({ NFXPathNode(name: String($0)) }) else {
            return
        }
        
        let nodesWithoutLast = nodes.dropLast()
        var previousNode = rootNode
        for node in nodesWithoutLast {
            if let foundNode = previousNode.find(node) {
                previousNode = foundNode
            } else {
                previousNode.insert(node)
                previousNode = node
            }
        }
        let resourceNode = NFXPathNode(name: nodes.last?.name ?? "-")
        resourceNode.httpModel = obj
        previousNode.insert(resourceNode)
    }
    
    func clear() {
        rootNode.children = []
    }
    
    func getHttpModels() -> [NFXHTTPModel] {
        return rootNode.findLeaves()
    }
    
    func getTableModels() -> [NFXPathNode] {
        rootNode.isExpanded = true
        var models = rootNode.toArray()
        models.remove(at: 0)
        return models
    }
}
#endif
