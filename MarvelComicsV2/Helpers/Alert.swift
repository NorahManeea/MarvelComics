//
//  Alert.swift
//  MarvelComicsV2
//
//  Created by Norah Almaneea on 20/05/2021.
//

import Foundation
import UIKit

struct Alert {
    
     static func showBasicAlert(on vc: UIViewController, with title: String, message: String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
        DispatchQueue.main.async {
            vc.present(alert, animated: true, completion: nil)
        }
    }
}

