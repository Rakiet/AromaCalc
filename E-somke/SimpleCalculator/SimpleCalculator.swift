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
    @IBOutlet weak var consistencyLabel: UILabel!
    @IBOutlet weak var firstTextField: UITextField!
    @IBOutlet weak var secondTextField: UITextField!
    @IBOutlet weak var thirdTextField: UITextField!
    @IBOutlet weak var fourTextField: UITextField!
    @IBOutlet weak var consistencyVG: UITextField!
    @IBOutlet weak var consistencyPG: UITextField!
    @IBOutlet weak var consistencyStack: UIStackView!
    @IBOutlet weak var nicoVG: UITextField!
    @IBOutlet weak var nicoPG: UITextField!
    
    
    
    @IBOutlet weak var tabBar: UITabBar!
    @IBOutlet weak var createButton: UIButton!
    
    @IBOutlet weak var simpleBaseBar: UITabBarItem!
    @IBOutlet weak var premixBar: UITabBarItem!
    
    var tabBarSelected = 1
    
    
    var readyNicotine = 0.0
    var readyAroma = 0.0
    var readyLastBase = 0.0
    
    
    var allFunction = AllFunction()
    
    var mixLiquid = 0.0
    
    var sendText = ""
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
       
        
        loadStyle()
        firstTextField.delegate = self
        secondTextField.delegate = self
        thirdTextField.delegate = self
        fourTextField.delegate = self
        tabBar.selectedItem = tabBar.items![0]
        tabBar.delegate = self
        //tabBarSelected = 1
        
    }
    
    @IBAction func prepareLiquid(_ sender: Any) {
        
        guard let product = Double(firstTextField.text!), let nicotine = Double(secondTextField.text!), let aroma = Double(thirdTextField.text!), let nicotineB = Double(fourTextField.text!) else {
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
            print(readyNicotine)
            var hmmmmError = product
            hmmmmError -= (product/100) * aroma
            
            print(hmmmmError)
            if readyNicotine > hmmmmError{ //Wyrzuca błąd jeżeli ilośc dodanej nikotyny jest większe niż wolne miejsce w butelce
                var youNeed = (nicotine/hmmmmError) * product
                if roundTo(number: youNeed, precision: 1) == nicotine{
                    youNeed += 0.1
                }
                self.allFunction.addAlert(controller: self, title: "Błąd", text: "Z posiadanej bazy nie można otrzymać oczekiwanego stężenia nikotyny.\n Twoja baza musi posiadać minimum \(roundTo(number: youNeed, precision: 1)) mg/ml nikotyny.")
                self.createButton.isEnabled = false
                self.createButton.alpha = 0.6
            } else {
                self.createButton.isEnabled = true
                self.createButton.alpha = 1
                /*
                 viewController.aroma = roundTo(number: readyAroma, precision: 1)
                 viewController.base = roundTo(number: readyLastBase, precision: 1)
                 viewController.nicotine = roundTo(number: readyNicotine, precision: 1)
                 */
                
                
                sendText = "Do utworzenia liquidu potrzebujesz:\n\n \(roundTo(number: readyAroma, precision: 1)) ml aromatu\n \(roundTo(number: readyLastBase, precision: 1)) ml bazy bez nikotyny\n \(roundTo(number: readyNicotine, precision: 1)) ml bazy nikotynowej"
            }
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
                
                let youNeed = (aroma/nicotine) * (product + nicotine)
//                if roundTo(number: youNeed, precision: 1) == aroma{
//                    youNeed += 0.1
//                }
                
                self.allFunction.addAlert(controller: self, title: "Błąd", text: "Z posiadanej bazy nie można otrzymać oczekiwanego stężenia nikotyny.\n Twoja baza musi posiadać minimum \(roundTo(number: youNeed, precision: 1)) mg/ml nikotyny.")
                self.createButton.isEnabled = false
                self.createButton.alpha = 0.6
            } else {
                self.createButton.isEnabled = true
                self.createButton.alpha = 1
                sendText = "Do utworzenia premixu potrzebujesz:\n\(roundTo(number: readyLastBase, precision: 1)) ml bazy bez nikotyny\n\(roundTo(number: readyNicotine, precision: 1) ) ml bazy nikotynowej"
            }
            
        }
        if tabBarSelected == 3 {
            self.createButton.isEnabled = true
            self.createButton.alpha = 1
            let finalProduct = ((nicotine * product) + (nicotineB * aroma)) / (product + aroma)
            
            
            print(nicotine,nicotineB,product,aroma)
            
            sendText = "Powstały liquid osiągnie stężenie\n\(finalProduct) mg/ml nikotyny."
        }
        
        if tabBarSelected == 4 {
            guard let vg = Double(consistencyVG.text!), let pg = Double(consistencyPG.text!), let npg = Double(nicoPG.text!), let nvg = Double(nicoVG.text!) else {
                print("Brak wartości PG/VG")
                return
            }
            print("PGGGGG")
            //sprawdzanie
            if (vg+pg) != 100 || (npg+nvg) != 100{
                allFunction.addAlert(controller: self, title: "Błąd", text: "Suma VG + PG musi wynosić 100")
                self.createButton.isEnabled = false
                self.createButton.alpha = 0.6
            }else {
            let howAroma: Double = (product/100) * aroma
            let howNicotine = (nicotine/nicotineB) * product
            readyLastBase = product
            readyLastBase -= howAroma
            readyLastBase -= howNicotine
            readyNicotine = howNicotine
            readyAroma = howAroma
            print(readyNicotine)
            var hmmmmError = product
            hmmmmError -= (product/100) * aroma
            
            let readypg = readyAroma + (readyLastBase * (pg/100)) + (readyNicotine * (npg/100))
            let readyvg = 100 - readypg
                
            print(hmmmmError)
            if readyNicotine > hmmmmError{ //Wyrzuca błąd jeżeli ilośc dodanej nikotyny jest większe niż wolne miejsce w butelce
                var youNeed = (nicotine/hmmmmError) * product
                if roundTo(number: youNeed, precision: 1) == nicotine{
                    youNeed += 0.1
                }
                self.allFunction.addAlert(controller: self, title: "Błąd", text: "Z posiadanej bazy nie można otrzymać oczekiwanego stężenia nikotyny.\n Twoja baza musi posiadać minimum \(roundTo(number: youNeed, precision: 1)) mg/ml nikotyny.")
                self.createButton.isEnabled = false
                self.createButton.alpha = 0.6
                } else {
                self.createButton.isEnabled = true
                self.createButton.alpha = 1
                /*
                viewController.aroma = roundTo(number: readyAroma, precision: 1)
                 viewController.base = roundTo(number: readyLastBase, precision: 1)
                viewController.nicotine = roundTo(number: readyNicotine, precision: 1)
                */
                           
                           
                sendText = "Do utworzenia liquidu potrzebujesz:\n \(roundTo(number: readyAroma, precision: 1)) ml aromatu\n \(roundTo(number: readyLastBase, precision: 1)) ml bazy bez nikotyny\n \(roundTo(number: readyNicotine, precision: 1)) ml bazy nikotynowej.\n Gęstość \(roundTo(number: readyvg, precision: 1))VG \(roundTo(number: readypg, precision: 1))PG"
            }
            }}
        
    }
    

    
    
    func roundTo(number: Double, precision: Int) -> Double {
        var power: Double = 1
        for _ in 1...precision {
            power *= 10
        }
        let rounded = Double(round(power * number)/power)
        return rounded
    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if tabBarSelected == 3{
//            allFunction.addAlert(controller: self, title: "Wynik", text: sendText)
//        } else if (segue.identifier == "createLiquid") {
//             let viewController = segue.destination as! ReadyLiquidViewController
//                viewController.text = sendText
//
//
//        }
//    
//        
//        
//        
//        
//        
//    }
    @IBAction func createAlert(_ sender: Any) {
        
        allFunction.addAlert(controller: self, title: "Wynik", text: sendText)
    }
    
    
    
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        if(item.tag == 1) {
            
            textAnimation(text1: "Ilość gotowego produktu:", text2: "Docelowa zawartość nikotyny:", text3: "Docelowe stężenie aromatu:", text4: "Baza nikotynowa jaką dysponujesz:", text5: "ml", text6: "mg/ml", text7: "%",text8: "mg/ml")
            tabBarSelected = 1
            self.createButton.isEnabled = false
            self.createButton.alpha = 0.6
            //wyłączenie wlasnej gestosci bazy
            self.consistencyLabel.isHidden = true
            self.consistencyPG.isHidden = true
            self.consistencyVG.isHidden = true
            self.consistencyStack.isHidden = true
            self.nicoPG.isHidden = true
            self.nicoVG.isHidden = true
        }
        else if(item.tag == 2) {
            
            textAnimation(text1: "Ilość premixu:", text2: "Ilość wolnego miejsca w butelce:", text3: "Docelowa zawartość nikotyny:", text4: "Baza nikotynowa jaką dysponujesz:", text5: "ml", text6: "ml", text7: "mg/ml", text8: "mg/ml")
            tabBarSelected = 2
            self.createButton.isEnabled = false
            self.createButton.alpha = 0.6
            //wyłączenie wlasnej gestosci bazy
            self.consistencyLabel.isHidden = true
            self.consistencyPG.isHidden = true
            self.consistencyVG.isHidden = true
            self.consistencyStack.isHidden = true
            self.nicoPG.isHidden = true
            self.nicoVG.isHidden = true
        }else if(item.tag == 3) {
            
            textAnimation(text1: "Ilość pierwszego liquidu:", text2: "Moc pierwszego liquidu:", text3: "Ilość drugiego liquidu:", text4: "Moc drugiego liquidu:", text5: "ml", text6: "mg/ml", text7: "ml", text8: "mg/ml")
            tabBarSelected = 3
            self.createButton.isEnabled = false
            self.createButton.alpha = 0.6
            //wyłączenie wlasnej gestosci bazy
            self.consistencyLabel.isHidden = true
            self.consistencyPG.isHidden = true
            self.consistencyVG.isHidden = true
            self.consistencyStack.isHidden = true
            self.nicoPG.isHidden = true
            self.nicoVG.isHidden = true
        }else if(item.tag == 4){
            //wlacznie wlasnej gestosci bazy
            tabBarSelected = 4
//            self.consistencyLabel.isHidden = false
//            self.consistencyPG.isHidden = false
//            self.consistencyVG.isHidden = false
//            self.consistencyStack.isHidden = false
//            self.nicoPG.isHidden = false
//            self.nicoVG.isHidden = false
            
            UIView.animate(withDuration: 1.5, animations: { () -> Void in
                self.consistencyLabel.alpha = 0
                self.consistencyPG.alpha = 0
                self.consistencyVG.alpha = 0
                self.consistencyStack.alpha = 0
                self.nicoPG.alpha = 0
                self.nicoVG.alpha = 0
                self.firstLabel.alpha = 0
                          self.secondLabel.alpha = 0
                          self.thirdLabel.alpha = 0
                          self.fourLabel.alpha = 0
                          self.firstTextField.alpha = 0
                          self.secondTextField.alpha = 0
                          self.thirdTextField.alpha = 0
                          self.fourTextField.alpha = 0
                
            }) { (isCompleted) in
                self.consistencyLabel.isHidden = false
                self.consistencyPG.isHidden = false
                self.consistencyVG.isHidden = false
                self.consistencyStack.isHidden = false
                self.nicoPG.isHidden = false
                self.nicoVG.isHidden = false
            }
            
            UIView.animate(withDuration: 1.5, delay: 0, options: .curveEaseInOut, animations: {
                self.consistencyLabel.alpha = 1
                self.consistencyPG.alpha = 1
                self.consistencyVG.alpha = 1
                self.consistencyStack.alpha = 1
                self.nicoPG.alpha = 1
                self.nicoVG.alpha = 1
                self.firstLabel.alpha = 1
                self.secondLabel.alpha = 1
                self.thirdLabel.alpha = 1
                self.fourLabel.alpha = 1
                self.firstTextField.alpha = 1
                self.secondTextField.alpha = 1
                self.thirdTextField.alpha = 1
                self.fourTextField.alpha = 1
            })
        }
    }
    
    func textAnimation(text1:String,text2:String,text3:String,text4:String,text5:String,text6:String,text7:String,text8:String){
        UIView.animate(withDuration: 1.5, animations: { () -> Void in
            self.firstLabel.alpha = 0
            self.secondLabel.alpha = 0
            self.thirdLabel.alpha = 0
            self.fourLabel.alpha = 0
            self.firstTextField.alpha = 0
            self.secondTextField.alpha = 0
            self.thirdTextField.alpha = 0
            self.fourTextField.alpha = 0
            
        }) { (isCompleted) in
            self.firstLabel.text =  text1
            self.secondLabel.text = text2
            self.thirdLabel.text = text3
            self.fourLabel.text = text4
            self.firstTextField.placeholder = text5
            self.secondTextField.placeholder = text6
            self.thirdTextField.placeholder = text7
            self.fourTextField.placeholder = text8
            
            self.firstTextField.text = ""
            self.secondTextField.text = ""
            self.thirdTextField.text = ""
            self.fourTextField.text = ""
        }
        
        UIView.animate(withDuration: 1.5, delay: 0, options: .curveEaseInOut, animations: {
            self.firstLabel.alpha = 1
            self.secondLabel.alpha = 1
            self.thirdLabel.alpha = 1
            self.fourLabel.alpha = 1
            self.firstTextField.alpha = 1
            self.secondTextField.alpha = 1
            self.thirdTextField.alpha = 1
            self.fourTextField.alpha = 1
        })
    }
    
    func loadStyle(){
        navigationController?.isNavigationBarHidden = true
        createButton.layer.cornerRadius = 12
        createButton.layer.backgroundColor = UIColor(red:0.00, green:0.60, blue:0.40, alpha:1.0).cgColor
        createButton.setTitleColor(UIColor.white, for: .normal)
        createButton.isEnabled = false
        createButton.alpha = 0.6
        
        //wyłączenie wlasnej gestosci bazy
        self.consistencyLabel.isHidden = true
        self.consistencyPG.isHidden = true
        self.consistencyVG.isHidden = true
        self.consistencyStack.isHidden = true
        self.nicoPG.isHidden = true
        self.nicoVG.isHidden = true
       
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
