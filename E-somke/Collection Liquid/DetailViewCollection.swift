//
//  DetailViewCollection.swift
//  E-somke
//
//  Created by Piotr Żakieta on 20/06/2019.
//  Copyright © 2019 Piotr Żakieta. All rights reserved.
//

import UIKit
import CoreData

class DetailViewCollection: UIViewController, UITextViewDelegate, UITabBarDelegate {

    var allFunction = AllFunction()
    
    //zmienne pobrane
    var nameCompany: String!
    var nameAroma: String!
    var stars: Int16!
    var sku: String!
    var date: Date!
    var conNicotine: Double!
    var conAroma: Double!
    var descriptionLiquid: String!
    var indexNumber: Int!

    //zmienne odpowiedzialne za widok
    @IBOutlet weak var headLabel: UILabel!
    @IBOutlet weak var secondHeadLabel: UILabel!
    @IBOutlet weak var nicotineLabel: UILabel!
    @IBOutlet weak var aromaLabel: UILabel!
    @IBOutlet weak var descriptionText: UITextView!
    
    @IBOutlet weak var firstStar: UIButton!
    @IBOutlet weak var secondStar: UIButton!
    @IBOutlet weak var thirdStar: UIButton!
    @IBOutlet weak var fourthStar: UIButton!
    @IBOutlet weak var fifthStar: UIButton!
    
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var createAgainButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.descriptionText.delegate = self
        readData()
        loadStyle()
    }
    
    
    
    func readData() {
        guard nameCompany != nil, nameAroma != nil,stars != nil,sku != nil,date != nil,conNicotine != nil,conAroma != nil,descriptionLiquid != nil else {
            
            self.navigationController?.popViewController(animated: true)
            self.allFunction.addAlert(controller: self, title: "Błąd", text: "Coś poszło nie tak.\nKod błędu #001")
            
            return
        }
        headLabel.text = nameCompany!
        secondHeadLabel.text = nameAroma!
        nicotineLabel.text = "🚬 \(conNicotine!)%"
        aromaLabel.text = "🍒 \(conAroma!)%"
        descriptionText.text = descriptionLiquid!
        howStars()
        
        
    }
    
    func howStars(){
        switch stars {
        case 1:
            firstStar.setTitle("★", for: .normal)
            secondStar.setTitle("☆", for: .normal)
            thirdStar.setTitle("☆", for: .normal)
            fourthStar.setTitle("☆", for: .normal)
            fifthStar.setTitle("☆", for: .normal)
        case 2:
            firstStar.setTitle("★", for: .normal)
            secondStar.setTitle("★", for: .normal)
            thirdStar.setTitle("☆", for: .normal)
            fourthStar.setTitle("☆", for: .normal)
            fifthStar.setTitle("☆", for: .normal)
        case 3:
            firstStar.setTitle("★", for: .normal)
            secondStar.setTitle("★", for: .normal)
            thirdStar.setTitle("★", for: .normal)
            fourthStar.setTitle("☆", for: .normal)
            fifthStar.setTitle("☆", for: .normal)
        case 4:
            firstStar.setTitle("★", for: .normal)
            secondStar.setTitle("★", for: .normal)
            thirdStar.setTitle("★", for: .normal)
            fourthStar.setTitle("★", for: .normal)
            fifthStar.setTitle("☆", for: .normal)
        case 5:
            firstStar.setTitle("★", for: .normal)
            secondStar.setTitle("★", for: .normal)
            thirdStar.setTitle("★", for: .normal)
            fourthStar.setTitle("★", for: .normal)
            fifthStar.setTitle("★", for: .normal)
            
        default:
            firstStar.setTitle("☆", for: .normal)
            secondStar.setTitle("☆", for: .normal)
            thirdStar.setTitle("☆", for: .normal)
            fourthStar.setTitle("☆", for: .normal)
            fifthStar.setTitle("☆", for: .normal)
        }
    }
    
    
    @IBAction func setStars(_ sender: UIButton) {
        stars = Int16(sender.tag)
        howStars()
    }
    
    
    
    @IBAction func updateLiquid(_ sender: Any) {
        
        if descriptionText.text == "" {
            descriptionText.text = "brak"
        }
        guard stars > -1 && stars < 6 else {
            print("inny zakres")
            return
        }
        updateData(ownDescription: descriptionText.text!, howStars: stars!)
        //allFunction.addAlert(controller: self, title: "Sukces", text: "Udało nam się zapisać, Twoje zmiany.")
        navigationController?.popViewController(animated: true)
        allFunction.addAlert(controller: self, title: "Sukces", text: "Udało nam się zapisać, Twoje zmiany.")
    }
    
    
    func updateData(ownDescription: String, howStars: Int16){
        
        if let index = indexNumber {
        //As we know that container is set up in the AppDelegates so we need to refer that container.
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        //We need to create a context from this container
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest.init(entityName: "MyLiquid")
        do
        {
            let fetch = try managedContext.fetch(fetchRequest)
            
            let objectUpdate = fetch[index] as! NSManagedObject
            objectUpdate.setValue(ownDescription, forKey: "owndescription")
            objectUpdate.setValue(howStars, forKey: "stars")
            
            do{
                try managedContext.save()
            }
            catch
            {
                print(error)
            }
        }
        catch
        {
            print(error)
        }
        }else{
            navigationController?.popViewController(animated: true)

            allFunction.addAlert(controller: self, title: "Błąd", text: "Coś poszło nie tak, spróbuj ponownie za chwile.\nKod błędu #002")
            
        }
        
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "createAgain"{
                let sm = segue.destination as! SmartCalculator
            
                sm.aromaSku = self.sku
                sm.nameAroma = self.nameAroma
                sm.concentrationMin = Int(self.conAroma!) - 2
                sm.concentrationMax = Int(self.conAroma!) + 2
                sm.nameCompany = self.nameCompany
                sm.createAgain = true
                sm.readyNicotinCon = conNicotine
                sm.readyAromaCon = conAroma
        }
    }
    
    
    
    func loadStyle() {
        saveButton.layer.cornerRadius = 12
        saveButton.layer.backgroundColor = UIColor(red:0.00, green:0.60, blue:0.40, alpha:1.0).cgColor
        saveButton.setTitleColor(UIColor.white, for: .normal)
        createAgainButton.layer.cornerRadius = 12
        createAgainButton.layer.backgroundColor = UIColor(red:0.00, green:0.66, blue:0.95, alpha:1.0).cgColor
        createAgainButton.setTitleColor(UIColor.white, for: .normal)
        navigationController?.isNavigationBarHidden = false
    }
    
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
