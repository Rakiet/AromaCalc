//
//  ViewController.swift
//  E-somke
//
//  Created by Piotr Żakieta on 11/03/2019.
//  Copyright © 2019 Piotr Żakieta. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadStyle()
    }



    func loadStyle(){
        navigationController?.isNavigationBarHidden = true //ukrywanie navibar
        view.backgroundColor = UIColor(red:0.85, green:0.85, blue:0.85, alpha:1.0)
    }
}

