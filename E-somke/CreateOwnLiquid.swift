//
//  CreateOwnLiquid.swift
//  E-somke
//
//  Created by Piotr Żakieta on 03/04/2019.
//  Copyright © 2019 Piotr Żakieta. All rights reserved.
//

import UIKit

protocol IsbnDelegate {
    func passData(isbn: String)
}

class CreateOwnLiquid: UIViewController, IsbnDelegate {
    
    

    @IBOutlet weak var skuLabel: UITextField!
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.loadStyle()
    }
    
    
    func passData(isbn: String) {
        
        self.skuLabel.text = isbn
        
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destVC = segue.destination as! ScannerViewController
        destVC.delegate = self
    }
    
    func loadStyle(){
        navigationController?.isNavigationBarHidden = false //ukrywanie navibar
        view.backgroundColor = UIColor(red:0.85, green:0.85, blue:0.85, alpha:1.0)
    }

}
