//
//  readyProduct.swift
//  E-somke
//
//  Created by Piotr Żakieta on 13/06/2019.
//  Copyright © 2019 Piotr Żakieta. All rights reserved.
//

import UIKit
import CoreData

class readyProduct: UIViewController, UITextViewDelegate {

    
    var nameCompany: String!
    var nameAroma: String!
    var conAroma: Double!
    var conNicotine: Double!
    var aromaSku: String!
    
    var readyAroma: Double!
    var readyLastBase: Double!
    var readyNicotine: Double!
    
    
    
    @IBOutlet weak var headLabel: UILabel!
    
    @IBOutlet weak var saveButton: UIButton!
    
    @IBOutlet weak var descriptionTextFile: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.descriptionTextFile.delegate = self
        
        headLabel.text = "Przepis:\n\(String(describing: readyAroma!)) ml aromatu \n\(String(describing: readyLastBase!)) ml bazy 0 \n\(String(describing: readyNicotine!)) ml bazy nikotynowej\nMiłego wapowania 😃\n\nZapisz utworzony aromat, aby móc go odtworzyć i ocenić. \n\nMiejsce na notatki:"
        loadStyle()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    

    @IBAction func saveLiquid(_ sender: Any) {
        if descriptionTextFile.text == ""{
            saveOwnLiquid(nameC: nameCompany, nameA: nameAroma, sku: aromaSku, ownDescription: "brak", stars: 0, date: Date(), aroma: conAroma, nicotine: conNicotine)
        } else {
            saveOwnLiquid(nameC: nameCompany, nameA: nameAroma, sku: aromaSku, ownDescription: descriptionTextFile.text!, stars: 0, date: Date(), aroma: conAroma, nicotine: conNicotine)
        }
        navigationController?.popToRootViewController(animated: true)
        
    }
    
    func saveOwnLiquid(nameC: String, nameA: String, sku: String, ownDescription: String, stars: Int16, date: Date, aroma: Double, nicotine: Double) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "MyLiquid", in: context)
        let create = NSManagedObject(entity: entity!, insertInto: context)
        create.setValue(nameC, forKey: "nameCompany")
        create.setValue(nameA, forKey: "nameAroma")
        create.setValue(sku, forKey: "sku")
        create.setValue(stars, forKey: "stars")
        create.setValue(ownDescription, forKey: "owndescription")
        create.setValue(date, forKey: "date")
        create.setValue(aroma, forKey: "aroma")
        create.setValue(nicotine, forKey: "nicotine")
        do {
            try context.save()
        } catch {
            print("Failed saving")
        }
    }
    
    func loadStyle() {
        self.saveButton.layer.cornerRadius = 12
        self.saveButton.layer.backgroundColor = UIColor(red:0.00, green:0.60, blue:0.40, alpha:1.0).cgColor
        self.saveButton.setTitleColor(UIColor.white, for: .normal)
    }
    

    //podnoszenie ekranu o wielkosc klawiatury
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                
                let aaa = keyboardSize.height
                self.view.frame.origin.y -= aaa
                
                
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
    
    //ukrywanie ekranu po nacisnieciu przycisku "return" na klawiaturze
    func textViewShouldReturn(_ scoreText: UITextView) -> Bool {
        self.view.endEditing(true)
        return true
    }
    //ukrywanie klawiatury po kliknieciu w dowolne miejsce na ekranie
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}
