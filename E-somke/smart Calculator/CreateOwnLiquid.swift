//
//  CreateOwnLiquid.swift
//  E-somke
//
//  Created by Piotr Żakieta on 03/04/2019.
//  Copyright © 2019 Piotr Żakieta. All rights reserved.
//

import UIKit
import Firebase
import Network

protocol IsbnDelegate {
    func passData(isbn: String)
}

class CreateOwnLiquid: UIViewController, IsbnDelegate {
    
    let monitor = NWPathMonitor() //stała do sprawdzania połączenia z internetem
    
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var addAromaButton: UIButton!
    

    @IBOutlet weak var headLabel: UILabel!
    @IBOutlet weak var skuLabel: UITextField!
    
    
    var items: [AromaItem] = []
    
    var allFunction = AllFunction()
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.loadStyle()
        skuLabel.text = ""
        if skuLabel.text! != "" {
            findSku(isbn: skuLabel.text!)
        }
        
        checkInternet()
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
        }else if (segue.identifier == "smartCalculator") {
            let viewController = segue.destination as! SmartCalculator
            
                viewController.aromaSku = items[0].sku
                viewController.concentrationMin = items[0].concentrationMin
                viewController.concentrationMax = items[0].concentrationMax
                viewController.nameAroma = items[0].aromaName
                viewController.nameCompany = items[0].nameCompany
        }
        
        
        
    }
    
    
    
    func findSku(isbn: String?){
        let baseRef = Database.database().reference()
        if let sku = isbn {
            var newItems: [AromaItem] = []
            let strSearch = sku
            baseRef.child("aroma-items").queryOrdered(byChild:  "sku").queryStarting(atValue: strSearch).queryEnding(atValue: strSearch).observeSingleEvent(of: .value, with: { (snapshot) in
                
                
                for child in snapshot.children {
                    if let snapshot = child as? DataSnapshot,
                        let aromaItem = AromaItem(snapshot: snapshot) {
                        newItems.append(aromaItem)
                    }
                }
                
                self.items = newItems
                if self.items.isEmpty{
                    self.skuLabel.textColor = UIColor.red
                    self.headLabel.text = "Wybrany produkt nie znajduje się jeszcze w bazie danych. \nMożesz nam pomóc dodając go."
                    
                    self.addAromaButton.isHidden = false
                    self.nextButton.isEnabled = false
                    self.nextButton.alpha = 0.4
                } else {
                    let item = self.items[0]
                    self.skuLabel.textColor = UIColor.black
                    self.nextButton.isEnabled = true
                    self.nextButton.alpha = 1
                    self.headLabel.text = "\(item.nameCompany)\nSmak: \(item.aromaName)\n Zalecane stężenie: \(item.concentrationMin)% - \(item.concentrationMax)%"
                    self.nextButton.isHidden = false
                    self.addAromaButton.isHidden = true
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
        //view.backgroundColor = UIColor(red:0.85, green:0.85, blue:0.85, alpha:1.0)
        
        nextButton.layer.cornerRadius = 12
        nextButton.layer.backgroundColor = UIColor(red:0.00, green:0.60, blue:0.40, alpha:1.0).cgColor
        nextButton.setTitleColor(UIColor.white, for: .normal)
        addAromaButton.layer.cornerRadius = 12
        addAromaButton.layer.backgroundColor = UIColor(red:0.00, green:0.66, blue:0.95, alpha:1.0).cgColor
        addAromaButton.setTitleColor(UIColor.white, for: .normal)
        
        //wyłączenie przycisków
        
        nextButton.isEnabled = false
        nextButton.alpha = 0.4
        addAromaButton.isHidden = true
    }
    
    
    func checkInternet(){ // funkcja sprawdzająca połączenie z internetem
        monitor.pathUpdateHandler = { path in
            if path.status == .satisfied {
                print("Połączenie z internetem działa")
            } else {
                self.navigationController?.popViewController(animated: true)
                self.allFunction.addAlert(controller: self, title: "Alert", text: "Do obsługi tej funkcjonalności jest wymagane połącznie z internetem.\nPołącz się z siecią i spróbuj ponownie.")
                
            }
            
            //print(path.isExpensive)
        }
        let queue = DispatchQueue(label: "Monitor")
        monitor.start(queue: queue)
        //let cellMonitor = NWPathMonitor(requiredInterfaceType: .cellular)
    }
    

}
