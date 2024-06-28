//
//  AlertMessage.swift
//  firebaseAuthPractice
//
//  Created by Macbook Pro on 21/06/2024.
//

import UIKit

//for alert
struct AlertMessage {
    
    static func showAlertMessage (_ title : String, _ message : String,_ vc : UIViewController) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default))
        vc.present(alert, animated: true)
        return
    }
}
