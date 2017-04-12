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
import SwiftyVK




struct SongData {
    var trackName: String?
    var artistName: String?
    var trackId: String?
}

class VKDelegateExample: VKDelegate {
    let appID = "4986954"
    let scope: Set<VK.Scope> = [.messages,.offline,.friends,.wall,.photos,.audio,.video,.docs,.market,.email]
    
    
    
    init() {
        VK.config.logToConsole = true
        VK.configure(withAppId: appID, delegate: self)
    }
    
    
    
    func vkWillAuthorize() -> Set<VK.Scope> {
        return scope
    }
    
    
    
    func vkDidAuthorizeWith(parameters: Dictionary<String, String>) {
        NotificationCenter.default.post(name: Notification.Name(rawValue: "TestVkDidAuthorize"), object: nil)
    }
    
    
    
    
    func vkAutorizationFailedWith(error: AuthError) {
        print("Autorization failed with error: \n\(error)")
        NotificationCenter.default.post(name: Notification.Name(rawValue: "TestVkDidNotAuthorize"), object: nil)
    }
    
    
    
    func vkDidUnauthorize() {}
    
    
    
    func vkShouldUseTokenPath() -> String? {
        return nil
    }
    
    


    func vkWillPresentView() -> UIViewController {
        return UIApplication.shared.delegate!.window!!.rootViewController!
    }
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
    
    
    
    
    
    
    
    
    
                // Основная часть
    
    
    
    
    
    
    @IBAction func adoptAM(_ sender: UIButton) {
        //подключаем VK
        
        
        vkDelegateReference = VKDelegateExample()
        
        
        var songs = [String]()
        VK.API.Audio.get([.count : "100"]).send(
            onSuccess: {
                response in if let data = response.dictionary{
                    print("________________")
                    let countSongs = data["count"]!.number as! Int!
                    for index in 0 ..< countSongs! {
                        let songArtist = data["items"]?[index].dictionary?["artist"]
                        let songName = data["items"]?[index].dictionary?["title"]
                        if (songArtist != nil && songName != nil) {
                            let song1 = songName!.string! + "+" + songArtist!.string!
                            var song = ""
                            for character in song1.characters {
                                if (character == " ") {
                                    song += "+"
                                } else {
                                    song.append(character)
                                }
                                
                            }
                            songs.append(song)
                        }
                    }
                    print("_______________")
                    
                    
                    
                    
                    
                    
                    
                    
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
                    
                    
                    /*
                     let url = URL(string: "http://scar.su/cgi-bin/music.py?action=find&user_id=12345&vk_music_id=1")
                     
                     let task = URLSession.shared.dataTask(with: url! as URL) { data, response, error in
                     
                     guard let data = data, error == nil else { return }
                     
                     print(NSString(data: data, encoding: String.Encoding.utf8.rawValue))
                     }
                     
                     task.resume()
                     */
                    
                    
                    
                    //прошли аутентификацию, теперь ищем песни
                    
                    
                    // Подключаем Apple Music
                    var songsReal = 0
                    for song in songs{
                        Alamofire.request("https://itunes.apple.com/search?term=\(song)&entity=song&country=RU&count=1")
                            .validate()
                            .responseJSON { response in
                                if let responseData = response.result.value as? NSDictionary {
                                    print(responseData)
                                    if responseData.value(forKey: "resultCount")! as! Int != 0 {
                                        if let songResults = responseData.value(forKey: "results") as? [NSDictionary]   {
                                        //print(type(of:songResults))
                                            if let rowData: NSDictionary = songResults[0] as? NSDictionary {
                                                //print(rowData["trackId"] as! Int) // вроде, работает
                                                let id = rowData["trackId"] as! Int
                                                let library = MPMediaLibrary.default()
                                                library.addItem(withProductID: String(id))
                                                songsReal += 1
                                            }
                                        }
                                    }
                                }
                        
                        }
                    }
                    
                    


                    //let data2 = data.value(forKey: "items") as? [NSDictionary]
                    
                    //let data2 = data.value(forKey: "artist") as? [NSDictionary]
                    //let rowData: NSDictionary = (data2![0] as? NSDictionary)!
                    //print(rowData)
                    //let id = rowData["id"] as! Int
                    //print(id)
                }
        },
            onError: {error in print("SwiftyVK: audio.get fail \n \(error)")}
        )


        
    }
}
