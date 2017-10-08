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
    
    func getBestScores (completion: @escaping (_ result: [Player]) -> Void) {
        sharedInstance.firebase.child(RANKING)
            .queryOrdered(byChild: SCORE)
            .queryLimited(toLast: UInt(TOP_RANKING))
            .observe(.value, with: { (snapshot: DataSnapshot) in
                
                var array:[Player] = []
                
                for rankingSnapshot in snapshot.children {
                    let ranking = rankingSnapshot as! DataSnapshot
                    let rankingPlayer = ranking.value as! [String:String]
                    
                    let player: Player = Player()
                    player.name = rankingPlayer["name"]
                    player.score = rankingPlayer["score"]
                    player.dateTime = rankingPlayer["date_time"]
                    
                    array.append(player)
                }
                
                array = array.sorted(by: { $0.score == $1.score ? ($0.dateTime < $1.dateTime)
                                                                : ($0.score > $1.score)})
                completion(array)
            })
    }
    
    func saveScore(player: Player) {
        let ranking = sharedInstance.firebase.child(RANKING)
        let position = ranking.childByAutoId()
        position.child(NAME).setValue(player.name)
        position.child(SCORE).setValue(player.score)
        position.child(DATE_TIME).setValue(String(describing: Date()))
    }

    
}
