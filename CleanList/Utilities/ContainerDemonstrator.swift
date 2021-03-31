//
//  ContainerDemonstrator.swift
//  CleanList
//
//  Created by Vasiliy Fedotov on 14.03.2021.
//

import UIKit

protocol ControllerFactory {
    func create() -> UIViewController
}

class ContainerDemonstrator {
    
    private let containerView: UIView
    private let factory: ControllerFactory
    private weak var parent: UIViewController?
    
    private var child: UIViewController?
    
    init(with factory: ControllerFactory,
         container: UIView,
         parent: UIViewController) {
        self.containerView = container
        self.factory = factory
        self.parent = parent
    }
    
    func insert() {
        guard let parent = parent else { return }
        
        child?.remove()
        
        let child = factory.create()
        self.child = child
        
        parent.add(child: child, container: containerView)
        containerView.isHidden = false
    }
    
    func remove() {
        containerView.isHidden = true
        child?.remove()
    }
}
