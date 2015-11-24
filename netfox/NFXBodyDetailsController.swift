//
//  NFXBodyDetailsController.swift
//  netfox
//
//  Copyright © 2015 kasketis. All rights reserved.
//

import Foundation
import UIKit

class NFXBodyDetailsController : UIViewController
{
    var bodyView: UITextView = UITextView()
    var iIndex: Int = 0
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.edgesForExtendedLayout = .None
        
        self.title = "Body details"
        
        self.view.backgroundColor = UIColor.init(netHex: 0xf2f2f2)
        
        let tempObject = NFXHTTPModelManager.sharedInstance.models[self.iIndex]
        
        self.bodyView.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame))
        self.bodyView.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        self.bodyView.backgroundColor = UIColor.clearColor()
        self.bodyView.textColor = UIColor.init(netHex: 0x707070)
        self.bodyView.editable = false
        
        
        // Added by Vicente Crespo Penadés
        // vicente.crespo.penades@gmail.com - 23 Nov 2015
        let responseBody = prettyStringIfPossibleWithResponse( tempObject.getResponseBody() as String)
        
        
        self.bodyView.text = responseBody
        
        self.view.addSubview(self.bodyView)
        
    }
    
    
    //
    // MARK: Utils
    //
    
    private func prettyStringIfPossibleWithResponse(response: String?) -> String? {
        
        guard let responseBody = response
            else { return nil }
        
        do {
            if let responseBodyData = responseBody.dataUsingEncoding(NSUTF8StringEncoding) {
                
                let responseObj = try NSJSONSerialization.JSONObjectWithData(responseBodyData,
                    options: .AllowFragments)
                
                let dataResponse = try NSJSONSerialization.dataWithJSONObject(responseObj,
                    options: .PrettyPrinted)
                
                let responseBodyPretty = String(data: dataResponse,
                    encoding: NSUTF8StringEncoding)
                
                return responseBodyPretty
            }
        } catch {
            return response
        }
        
        return response
    }
    
}