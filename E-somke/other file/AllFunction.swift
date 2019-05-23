//
//  AllFunction.swift
//  E-somke
//
//  Created by Piotr Żakieta on 31/03/2019.
//  Copyright © 2019 Piotr Żakieta. All rights reserved.
//

import UIKit

class AllFunction: UIView {

    func addAlert(controller: UIViewController, title: String, text: String) {
        let alertController = UIAlertController(title: title, message: text, preferredStyle: .alert)
        
        let action1 = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction) in
            print("You've pressed default");
        }
        
        alertController.addAction(action1)
        controller.present(alertController, animated: true, completion: nil)
    }

}
