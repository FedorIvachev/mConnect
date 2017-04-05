//
//  ViewController.swift
//  AMadopter
//
//  Created by Fedor Ivachev on 29.03.17.
//  Copyright © 2017 MSU CMC. All rights reserved.
//

import UIKit
import StoreKit
import SwiftyJSON
import MediaPlayer
import PubNub
import Alamofire



struct SongData {
    var trackName: String?
    var artistName: String?
    var trackId: String?
}



class ViewController: UIViewController {
    //MARK: Properties
    @IBOutlet weak var AMbutton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //MARK: Actions
    
    @IBAction func adoptAM(_ sender: UIButton) {
        
        SKCloudServiceController.requestAuthorization({
            (status: SKCloudServiceAuthorizationStatus) in
            switch(status)
            {
            case .authorized: print("Access granted.")
            case .denied, .restricted: print("Access denied or restricted.")
            case .notDetermined: print("Access cannot be determined.")
            }
        })
        
        
        if (SKCloudServiceController.authorizationStatus() == .authorized) {
            print ("Fedya cool maaan. Мы авторизовались")
        }
        
        let controller = SKCloudServiceController()
        //Check if user is a Apple Music member
        controller.requestCapabilities(completionHandler: { (capabilities, error) in
            if error != nil {
                print(":( not an AM member")
            }
            else {
                print("okok")
            }
        })
        //прошли аутентификацию, теперь ищем песни
        Alamofire.request("https://itunes.apple.com/search?term=PARTYMAKER&entity=song&country=RU&count=3")
            .validate()
            .responseJSON { response in
                if let responseData = response.result.value as? NSDictionary {
                    if let songResults = responseData.value(forKey: "results") as? [NSDictionary] {
                        print(songResults)
                        if let rowData: NSDictionary = songResults[1] as? NSDictionary {
                            print(rowData["trackId"] as! Int) // вроде, работает
                            let id = rowData["trackId"] as! Int
                            let library = MPMediaLibrary.default()
                            library.addItem(withProductID: String(id))
                        }
                    }
                }
        }
        
    }
}
