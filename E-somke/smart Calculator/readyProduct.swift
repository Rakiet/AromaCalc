//
//  readyProduct.swift
//  E-somke
//
//  Created by Piotr Żakieta on 13/06/2019.
//  Copyright © 2019 Piotr Żakieta. All rights reserved.
//

import UIKit
import CoreData

class readyProduct: UIViewController {

    
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

        headLabel.text = "Wystarczy że połączysz:\n\(String(describing: readyAroma!)) ml. aromatu \n\(String(describing: readyLastBase!)) ml. bazy 0 \n\(String(describing: readyNicotine!)) ml. bazy nikotynowej\nMiłego wapowania 😃.\n\n\nZapisz utworzony aromat aby w łatwy sposób go odtworzyć i ocenić. \n\nJeżeli chcesz jakoś dodatkowo opisać liquid, tutaj przygotowaliśmy dla Ciebie trochę miejsca:"
        loadStyle()
    }
    

    @IBAction func saveLiquid(_ sender: Any) {
        if descriptionTextFile.text == ""{
            saveOwnLiquid(nameC: nameCompany, nameA: nameAroma, sku: aromaSku, ownDescription: "", stars: 0, date: Date(), aroma: conAroma, nicotine: conNicotine)
        } else {
            saveOwnLiquid(nameC: nameCompany, nameA: nameAroma, sku: aromaSku, ownDescription: descriptionTextFile.text!, stars: 0, date: Date(), aroma: conAroma, nicotine: conNicotine)
        }
        //navigationController?.popToRootViewController(animated: true)
        
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
        self.saveButton.layer.backgroundColor = UIColor(red:0.11, green:0.67, blue:0.36, alpha:1.0).cgColor
        self.saveButton.setTitleColor(UIColor.white, for: .normal)
    }
    

}
