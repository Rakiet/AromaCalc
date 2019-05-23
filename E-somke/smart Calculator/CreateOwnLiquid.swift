//
//  CreateOwnLiquid.swift
//  E-somke
//
//  Created by Piotr Żakieta on 03/04/2019.
//  Copyright © 2019 Piotr Żakieta. All rights reserved.
//

import UIKit
import Firebase

protocol IsbnDelegate {
    func passData(isbn: String)
}

class CreateOwnLiquid: UIViewController, IsbnDelegate {
    
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var addAromaButton: UIButton!
    

    @IBOutlet weak var headLabel: UILabel!
    @IBOutlet weak var skuLabel: UITextField!
    
    let baseRef = Database.database().reference()
    var items: [AromaItem] = []
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.loadStyle()
        if skuLabel.text! != "" {
            findSku(isbn: skuLabel.text!)
        }
    }
    
    
    func passData(isbn: String) {
        
        self.skuLabel.text = isbn
        findSku(isbn: isbn)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "scaner"{
            let destVC = segue.destination as! ScannerViewController
            destVC.delegate = self
        }else if (segue.identifier == "addAroma") {
            let viewController = segue.destination as! SaveNewAroma
            viewController.sku = skuLabel.text!
        }
    }
    
    
    
    func findSku(isbn: String?){
        if let sku = isbn {
            
            let strSearch = sku
            baseRef.child("aroma-items").queryOrdered(byChild:  "sku").queryStarting(atValue: strSearch).queryEnding(atValue: strSearch).observeSingleEvent(of: .value, with: { (snapshot) in
                
                var newItems: [AromaItem] = []
                for child in snapshot.children {
                    if let snapshot = child as? DataSnapshot,
                        let aromaItem = AromaItem(snapshot: snapshot) {
                        newItems.append(aromaItem)
                    }
                }
                
                self.items = newItems
                if self.items.isEmpty{
                    self.skuLabel.textColor = UIColor.red
                    self.headLabel.text = "Wybranego produktu nie ma w bazie danych. Lecz możesz nam pomóc. Dodaj go sam. \nZ góry dziękujemy.\nZespół e-smoke oraz pozostali użytkownicy :)."
                    
                    self.addAromaButton.isHidden = false
                } else {
                    let item = self.items[0]
                    self.skuLabel.textColor = UIColor.black
                    self.headLabel.text = "\(item.nameCompany)\nO smaku: \(item.aromaName)\n Najepsze stężenie:\nOd \(item.concentrationMin)% do \(item.concentrationMax)%"
                }
                
            })
            
        }
    }
    
    @IBAction func nextStep(_ sender: Any) {
    }
    
    @IBAction func addAroma(_ sender: Any) {
    }
    

    func loadStyle(){
        navigationController?.isNavigationBarHidden = false //ukrywanie navibar
        view.backgroundColor = UIColor(red:0.85, green:0.85, blue:0.85, alpha:1.0)
        
        nextButton.layer.cornerRadius = 12
        nextButton.layer.backgroundColor = UIColor(red:0.11, green:0.67, blue:0.36, alpha:1.0).cgColor
        nextButton.setTitleColor(UIColor.white, for: .normal)
        addAromaButton.layer.cornerRadius = 12
        addAromaButton.layer.backgroundColor = UIColor(red:0.00, green:0.66, blue:0.95, alpha:1.0).cgColor
        addAromaButton.setTitleColor(UIColor.white, for: .normal)
        
        //wyłączenie przycisków
        
        nextButton.isEnabled = false
        nextButton.alpha = 0.4
        addAromaButton.isHidden = true
    }
}
