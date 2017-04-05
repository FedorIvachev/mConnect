//
//  AppDelegate.swift
//  AMadopter
//
//  Created by Fedor Ivachev on 29.03.17.
//  Copyright © 2017 MSU CMC. All rights reserved.
//

import UIKit
import PubNub


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, PNObjectEventListener {
    var window: UIWindow?
    lazy var client: PubNub = {
        let config = PNConfiguration(publishKey: "demo", subscribeKey: "demo")
        let pub = PubNub.clientWithConfiguration(config)
        return pub
    }()
}
