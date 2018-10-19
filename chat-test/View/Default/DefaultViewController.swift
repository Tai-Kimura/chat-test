//
//  DefaultViewController.swift
//  chat-test
//
//  Created by 木村太一朗 on 2018/10/18.
//  Copyright © 2018年 TANOSYS, LLC. All rights reserved.
//

import UIKit
import SwiftJsonUI

class DefaultViewController: SJUIViewController {
    
    var layoutFilePath: String {
        get {
            return ""
        }
    }
    
    var binding: Binding {
        get {
            return Binding(viewHolder: self)
        }
    }
    
    var safeAreaInsets: UIEdgeInsets {
        get {
            if #available(iOS 11.0, *) {
                return getAppDelegate()?.window?.safeAreaInsets ?? UIEdgeInsets.zero
            } else {
                return UIEdgeInsets.zero
            }
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let nc = NotificationCenter.default
        nc.addObserver(self, selector: #selector(keyboardWillChangeFrame(_:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        nc.addObserver(self, selector: #selector(applicationWillEnterForeground), name: NSNotification.Name(rawValue: "applicationWillEnterForeground"), object: nil)
        nc.addObserver(self, selector: #selector(applicationDidBecomeActive), name: NSNotification.Name(rawValue: "applicationDidBecomeActive"), object: nil)
        initializeView()
    }
    
    func applicationWillEnterForeground() {
        
    }
    
    func applicationDidBecomeActive() {
    }
    
    func getAppDelegate() -> AppDelegate? {
        return UIApplication.shared.delegate as? AppDelegate
    }
    
    func initializeView() {
        SJUIViewCreator.createView(layoutFilePath, target: self)
        binding.bindView()
    }
    
    func keyboardWillChangeFrame(_ notification: Foundation.Notification){
    }
}
