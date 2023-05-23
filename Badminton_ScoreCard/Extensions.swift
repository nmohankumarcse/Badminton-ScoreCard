//
//  Extensions.swift
//  Badminton_ScoreCard
//
//  Created by Mohankumar on 17/05/23.
//  Copyright © 2023 Mohankumar. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController{
    func showAlert(message : String){
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(alert, animated: true)
    }
}
