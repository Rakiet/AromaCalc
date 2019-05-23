//
//  SaveNewAroma.swift
//  E-somke
//
//  Created by Piotr Żakieta on 01/05/2019.
//  Copyright © 2019 Piotr Żakieta. All rights reserved.
//

import UIKit
import Firebase

class SaveNewAroma: UIViewController, UITextFieldDelegate, UITabBarDelegate {

    
    var sku:String!
    @IBOutlet weak var skuTextLabel: UILabel!
    
    @IBOutlet weak var companyNameTextField: UITextField!
    @IBOutlet weak var aromaNameTextField: UITextField!
    @IBOutlet weak var minConcentrationOfAromaTextField: UITextField!
    @IBOutlet weak var maxConcentrationOfAromaTextField: UITextField!
    
    let ref = Database.database().reference(withPath: "aroma-items")
    let baseRef = Database.database().reference()
    var items: [AromaItem] = []
    
    var allFunction = AllFunction()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.skuTextLabel.text = sku

        // Do any additional setup after loading the view.
        self.companyNameTextField.delegate = self
        self.aromaNameTextField.delegate = self
        self.minConcentrationOfAromaTextField.delegate = self
        self.maxConcentrationOfAromaTextField.delegate = self
    }
    

  
    @IBAction func saveButton(_ sender: Any) {
        guard let minConce = Int(minConcentrationOfAromaTextField.text!), let maxConce = Int(maxConcentrationOfAromaTextField.text!), let aromaName =  aromaNameTextField.text, let companyName = companyNameTextField.text else{
            allFunction.addAlert(controller: self, title: "Błąd", text: "Proszę uzupełnić wszystie pola. \nDziękuje :)")
            return
        }
        defer{
            navigationController?.popViewController(animated: true)
        }
        if minConce >= maxConce {
            allFunction.addAlert(controller: self, title: "Błąd", text: "Maksymalna stężenie musi być większe niż minimalne.")
        } else {
            //let minConce = Int(minConcentrationOfAromaTextField.text!)
            //let maxConce = Int(maxConcentrationOfAromaTextField.text!)
            let groceryItem = AromaItem(nameCompany: companyName,
                                        aromaName: aromaName, sku: sku, conMin: minConce, conMax: maxConce)
        
            let text = "\(companyNameTextField.text!) \(aromaNameTextField.text!)"
            
            let groceryItemRef = self.ref.child(text.lowercased())
        
            groceryItemRef.setValue(groceryItem.toAnyObject())
        }}
    
    func fail(){
        
        
        
    }
//    @IBAction func readData(_ sender: Any) {
//        let strSearch = concentrationOfAromaTextField.text!
//        baseRef.child("aroma-items").queryOrdered(byChild:  "aromaName").queryStarting(atValue: strSearch).queryEnding(atValue: strSearch).observeSingleEvent(of: .value, with: { (snapshot) in
//
//            var newItems: [AromaItem] = []
//            for child in snapshot.children {
//                if let snapshot = child as? DataSnapshot,
//                    let aromaItem = AromaItem(snapshot: snapshot) {
//                    newItems.append(aromaItem)
//                }
//            }
//
//            self.items = newItems
//            if self.items.isEmpty{
//                print("Błąd")
//            } else {
//            let item = self.items[0]
//            print(item.aromaName)
//            print(item.name)
//            }
//
//        })
//    }
    
    //ukrywanie ekranu po nacisnieciu przycisku "return" na klawiaturze
    func textFieldShouldReturn(_ scoreText: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    //ukrywanie klawiatury po kliknieciu w dowolne miejsce na ekranie
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
}
