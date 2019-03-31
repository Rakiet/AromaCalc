//
//  SimpleCalculator.swift
//  E-somke
//
//  Created by Piotr Żakieta on 15/03/2019.
//  Copyright © 2019 Piotr Żakieta. All rights reserved.
//

import UIKit

class SimpleCalculator: UIViewController, UITextFieldDelegate, UITabBarDelegate {

    @IBOutlet weak var firstLabel: UILabel!
    @IBOutlet weak var secondLabel: UILabel!
    @IBOutlet weak var thirdLabel: UILabel!
    @IBOutlet weak var fourLabel: UILabel!
    @IBOutlet weak var howProduct: UITextField!
    @IBOutlet weak var nicotineContent: UITextField!
    @IBOutlet weak var cocentrationOfAroma: UITextField!
    @IBOutlet weak var nicotineBase: UITextField!
    
    @IBOutlet weak var tabBar: UITabBar!
    @IBOutlet weak var createButton: UIButton!
    
    @IBOutlet weak var simpleBaseBar: UITabBarItem!
    @IBOutlet weak var premixBar: UITabBarItem!
    
    var tabBarSelected = 1
    
    
    var readyNicotine = 0.0
    var readyAroma = 0.0
    var readyLastBase = 0.0
    
    
    var allFunction = AllFunction()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        howProduct.delegate = self
        nicotineContent.delegate = self
        cocentrationOfAroma.delegate = self
        nicotineBase.delegate = self
        tabBar.selectedItem = tabBar.items![0]
        tabBar.delegate = self
        tabBarSelected = 1
        loadStyle()
    }
    
    @IBAction func prepareLiquid(_ sender: Any) {
        
        guard let product = Double(howProduct.text!), let nicotine = Double(nicotineContent.text!), let aroma = Double(cocentrationOfAroma.text!), let nicotineB = Double(nicotineBase.text!) else {
            print("nie")
            return
        }
        if tabBarSelected == 1 { //przygotowanie własnego liquidu
            let howAroma: Double = (product/100) * aroma
            let howNicotine = (nicotine/nicotineB) * product
            readyLastBase = product
            readyLastBase -= howAroma
            readyLastBase -= howNicotine
            readyNicotine = howNicotine
            readyAroma = howAroma
        }
        if tabBarSelected == 2 { //obliczaniePremixu
            //product = ilosc premixu
            //nicotine = ilosc wolnego miejsca w butelce
            //aroma = nikotyna w wyjsciowym produkcje
            //nicotineB = jaką nikotyną dysponujesz
            readyNicotine = (aroma/nicotineB) * (product+nicotine)//ilość bazy nikotynowej do doadania
            readyLastBase = nicotine - readyNicotine // dodatkowo baza 0
            readyAroma = product // ilość premixu
            
            if nicotine < readyNicotine{ //Wyrzuca błąd jeżeli ilośc dodanej nikotyny jest większe niż wolne miejsce w butelce
                self.allFunction.addAlert(controller: self, title: "Błąd", text: "Z podanej bazy nie można otrzymać oczekiwanego stężnia nikotyny")
                self.createButton.isEnabled = false
                self.createButton.alpha = 0.6
            } else {
                self.createButton.isEnabled = true
                self.createButton.alpha = 1
            }
            
        }
        
        
    }
    

    
    
    func roundTo(number: Double, precision: Int) -> Double {
        var power: Double = 1
        for _ in 1...precision {
            power *= 10
        }
        let rounded = Double(round(power * number)/power)
        return rounded
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "createLiquid") {
             let viewController = segue.destination as! ReadyLiquidViewController
                viewController.aroma = roundTo(number: readyAroma, precision: 1)
                viewController.base = roundTo(number: readyLastBase, precision: 1)
                viewController.nicotine = roundTo(number: readyNicotine, precision: 1)
                viewController.tabBarChoose = tabBarSelected
            
        
        }
        
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
    
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        if(item.tag == 1) {
            
            textAnimation(text1: "Ilość gotowego produktu:", text2: "Zawartość nikotyny:", text3: "Stężenie aromatu:", text4: "mg/ml", text5: "%")
            tabBarSelected = 1
            self.createButton.isEnabled = true
            self.createButton.alpha = 1
        }
        else if(item.tag == 2) {
            
            textAnimation(text1: "Ilość premixu:", text2: "Ilość wolnego miejsca w butelce:", text3: "Ilość nikotyny w gotywym produkcje:", text4: "ml", text5: "mg/ml")
            tabBarSelected = 2
        }
    }
    
    func textAnimation(text1:String,text2:String,text3:String,text4:String,text5:String){
        UIView.animate(withDuration: 1.5, animations: { () -> Void in
            self.firstLabel.alpha = 0
            self.secondLabel.alpha = 0
            self.thirdLabel.alpha = 0
            self.nicotineContent.alpha = 0
            self.cocentrationOfAroma.alpha = 0
            
        }) { (isCompleted) in
            self.firstLabel.text =  text1
            self.secondLabel.text = text2
            self.thirdLabel.text = text3
            self.nicotineContent.placeholder = text4
            self.cocentrationOfAroma.placeholder = text5
        }
        
        UIView.animate(withDuration: 1.5, delay: 0, options: .curveEaseInOut, animations: {
            self.firstLabel.alpha = 1
            self.secondLabel.alpha = 1
            self.thirdLabel.alpha = 1
            self.nicotineContent.alpha = 1
            self.cocentrationOfAroma.alpha = 1
        })
    }
    
    func loadStyle(){
        createButton.layer.cornerRadius = 12
        createButton.layer.backgroundColor = UIColor(red:0.11, green:0.67, blue:0.36, alpha:1.0).cgColor
        createButton.setTitleColor(UIColor.white, for: .normal)
    }
}
