//
//  ViewController.swift
//  E-somke
//
//  Created by Piotr Żakieta on 11/03/2019.
//  Copyright © 2019 Piotr Żakieta. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var stack: UIStackView!
    @IBOutlet weak var createButton: UIButton!
    @IBOutlet weak var myLiquid: UIButton!
    @IBOutlet weak var simpleCalc: UIButton!
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadStyle()

        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
    }



    func loadStyle(){


        createButton.layer.cornerRadius = createButton.frame.height / 4
        myLiquid.layer.cornerRadius = myLiquid.frame.height / 4
        simpleCalc.layer.cornerRadius = simpleCalc.frame.height / 4
        //simpleCalc.transform = CGAffineTransform(rotationAngle: -CGFloat.pi / 2) obracanie przycisku
        simpleCalc.layer.borderWidth = 1
        simpleCalc.layer.borderColor = UIColor.black.cgColor
//        myLiquid.layer.borderWidth = 1
//        myLiquid.layer.borderColor = UIColor.black.cgColor
//        createButton.layer.borderWidth = 1
//        createButton.layer.borderColor = UIColor.white.cgColor
        //view.backgroundColor = UIColor(red:0.85, green:0.85, blue:0.85, alpha:1.0)
    }
}

