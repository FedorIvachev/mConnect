//
//  AppDelegate.swift
//  AMadopter
//
//  Created by Fedor Ivachev on 29.03.17.
//  Copyright © 2017 MSU CMC. All rights reserved.
//

import UIKit
import SwiftyVK

import PubNub


var vkDelegateReference : VKDelegate?


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, PNObjectEventListener {
    var window: UIWindow?
    lazy var client: PubNub = {
        let config = PNConfiguration(publishKey: "demo", subscribeKey: "demo")
        let pub = PubNub.clientWithConfiguration(config)
        return pub
    }()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey : Any]? = nil) -> Bool {
        vkDelegateReference = VKDelegateExample()
        return true
    }
    
    
    
    
    @available(iOS 9.0, *)
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        let app = options[.sourceApplication] as? String
        VK.process(url: url, sourceApplication: app)
        return true
    }
    
    
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        VK.process(url: url, sourceApplication: sourceApplication)
        return true
    }
}
