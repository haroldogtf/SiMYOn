//
//  Firebase.swift
//  SiMYOn
//
//  Created by Haroldo Gondim on 06/10/17.
//

import UIKit
import Firebase

let sharedInstance = RankingFirebase()

class RankingFirebase: NSObject {
    
    var firebase: DatabaseReference!

    class func getInstance() -> RankingFirebase {
        if (sharedInstance.firebase == nil) {
            sharedInstance.firebase = Database.database().reference()
        }
        return sharedInstance
    }
        
}
