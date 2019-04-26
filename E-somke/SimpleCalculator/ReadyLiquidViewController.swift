//
//  ReadyLiquidViewController.swift
//  E-somke
//
//  Created by Piotr Żakieta on 19/03/2019.
//  Copyright © 2019 Piotr Żakieta. All rights reserved.
//

import UIKit

class ReadyLiquidViewController: UIViewController {

    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet weak var nextOrReturnButton: UIButton!
    @IBOutlet weak var doneButton: UIButton!
    
 
    var text:String!
   
    override func viewDidLoad() {
        super.viewDidLoad()
        textLabel.text = text
        loadnigStyle()
        
    }
    
    @IBAction func nextAction(_ sender: Any) {
        
    }
    
    @IBAction func doneAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
        
    }
    
    func loadnigStyle(){
        nextOrReturnButton.layer.cornerRadius = 12
        nextOrReturnButton.layer.backgroundColor = UIColor(red:0.11, green:0.67, blue:0.36, alpha:1.0).cgColor
        nextOrReturnButton.setTitleColor(UIColor.white, for: .normal)
        doneButton.layer.cornerRadius = 12
        doneButton.layer.backgroundColor = UIColor(red:0.00, green:0.66, blue:0.95, alpha:1.0).cgColor
        doneButton.setTitleColor(UIColor.white, for: .normal)
        nextOrReturnButton.setTitle("Następny Krok", for: .normal)
        doneButton.setTitle("Koniec", for: .normal)
        navigationController?.isToolbarHidden = true
        
        
    
    }

}
