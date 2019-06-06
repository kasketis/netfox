//
//  UINavigationControllerExtensions.swift
//  netfox_ios
//
//  Created by Tzatzo, Marsel, Vodafone Greece on 05/06/2019.
//  Copyright © 2019 kasketis. All rights reserved.
//

#if os(iOS)

import UIKit

extension UINavigationController {
    
    convenience init(_ viewController: UIViewController) {
        self.init(rootViewController: viewController)
        self.navigationBar.isTranslucent = false
        self.navigationBar.tintColor = UIColor.NFXOrangeColor()
        self.navigationBar.barTintColor = UIColor.NFXStarkWhiteColor()
        self.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.NFXOrangeColor()]
    }
    
}

#endif
