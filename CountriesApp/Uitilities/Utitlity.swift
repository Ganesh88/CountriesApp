//
//  Utitlity.swift
//  CountriesApp
//
//  Created by ganesh Pathe on 26/11/19.
//  Copyright © 2019 Ganesh Pathe. All rights reserved.
//

import Foundation
import UIKit
import MBProgressHUD

class Utility {
    
    weak var appDelegate: AppDelegate!
    var progressHUD: MBProgressHUD!
    var hudCount = 0
    
    // MARK: - Singleton
    class var instance: Utility {
        struct Static {
            static let instance: Utility = Utility()
        }
        return Static.instance
    }
    
    // MARK: - Initialise
    func initialise() {
        
        self.appDelegate = UIApplication.shared.delegate as? AppDelegate
    }
    
    // MARK: - HUD
    func createHud(_ label: String) {
        progressHUD = MBProgressHUD(view: (self.appDelegate.window)!)
        self.appDelegate.window!.addSubview(progressHUD)
        progressHUD.label.text = label as String
        progressHUD.removeFromSuperViewOnHide = true
        progressHUD.bezelView.color = UIColor.black.withAlphaComponent(0.85)
        progressHUD.bezelView.style = .solidColor
        progressHUD.contentColor = UIColor.white
        progressHUD.button.addTarget(self, action:#selector(Utility.hudButtonTouchUpInside(_:)), for: .touchUpInside)
        progressHUD.button.setTitle("Cancel", for: .normal)
        
        progressHUD.show(animated: true)
    }
    
    @objc func hudButtonTouchUpInside(_ sender: UIButton) {
        Utility.instance.hideHUD()
    }
    
    func destroyHud() {
        if let _ = self.progressHUD {
            self.progressHUD.isHidden = true
            self.progressHUD.removeFromSuperview()
            self.progressHUD = nil
        }
    }
    
    func showHUDWithText(_ text: String) {
        
        if self.hudCount == 0 {
            
            self.destroyHud()
            self.createHud(text)
        }
        
        self.hudCount += 1
    }
    
    func hideHUD() {
        
        self.hudCount -= 1
        
        if self.hudCount < 0 {
            self.hudCount = 0
        }
        
        if self.hudCount == 0 {
            self.destroyHud()
        }
    }
}
