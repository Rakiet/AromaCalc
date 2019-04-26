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
    @IBOutlet weak var firstTextField: UITextField!
    @IBOutlet weak var secondTextField: UITextField!
    @IBOutlet weak var thirdTextField: UITextField!
    @IBOutlet weak var fourTextField: UITextField!
    
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
    override func viewDidLoad() {
        super.viewDidLoad()
        
        firstTextField.delegate = self
        secondTextField.delegate = self
        thirdTextField.delegate = self
        fourTextField.delegate = self
        tabBar.selectedItem = tabBar.items![0]
        tabBar.delegate = self
        tabBarSelected = 1
        loadStyle()
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
                self.allFunction.addAlert(controller: self, title: "Błąd", text: "Z podanej bazy nikotynowej nie można otrzymać oczekiwanego stężnia nikotyny. Twoja baza musi posiadać min \(roundTo(number: youNeed, precision: 1)) nikotyny ")
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
                
                
                sendText = "\(roundTo(number: readyAroma, precision: 1)) aromatu\n\n\(roundTo(number: readyLastBase, precision: 1)) bazy bez nikotyny\n\n\(roundTo(number: readyNicotine, precision: 1)) bazy nikotynowej"
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
                
                self.allFunction.addAlert(controller: self, title: "Błąd", text: "Z podanej bazy nie można otrzymać oczekiwanego stężnia nikotyny. Musisz użyć bazy nikotynowej o stężeniu \(youNeed)")
                self.createButton.isEnabled = false
                self.createButton.alpha = 0.6
            } else {
                self.createButton.isEnabled = true
                self.createButton.alpha = 1
                sendText = "\(roundTo(number: readyLastBase, precision: 1)) bazy bez nikotyny\n\n\(roundTo(number: readyNicotine, precision: 1)) bazy nikotynowej"
            }
            
        }
        if tabBarSelected == 3 {
            
            let finalProduct = (nicotine + nicotineB) / (product + aroma)
            
            sendText = "Twoje liquidy po zmieszaniu będą miały \(finalProduct)"
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
        if tabBarSelected == 3{
            allFunction.addAlert(controller: self, title: "Wynik", text: "Po połączeniu otrzymasz \(mixLiquid) mocy.")
        } else if (segue.identifier == "createLiquid") {
             let viewController = segue.destination as! ReadyLiquidViewController
                viewController.text = sendText
            
        
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
            
            textAnimation(text1: "Ilość gotowego produktu:", text2: "Zawartość nikotyny:", text3: "Stężenie aromatu:", text4: "Baza nikotynowa jaką dyskonujesz:", text5: "ml", text6: "mg/ml", text7: "%",text8: "mg/ml")
            tabBarSelected = 1
            self.createButton.isEnabled = true
            self.createButton.alpha = 1
        }
        else if(item.tag == 2) {
            
            textAnimation(text1: "Ilość premixu:", text2: "Ilość wolnego miejsca w butelce:", text3: "Ilość nikotyny w gotywym produkcje:", text4: "Baza nikotynowa jaką dyskonujesz:", text5: "ml", text6: "ml", text7: "mg/ml", text8: "mg/ml")
            tabBarSelected = 2
            self.createButton.isEnabled = true
            self.createButton.alpha = 1
        }else if(item.tag == 3) {
            
            textAnimation(text1: "Ilość pierwszego liquidu:", text2: "Moc pierwszego liquidu:", text3: "Ilość drugiego liquidu:", text4: "Moc drugiego liquidu:", text5: "ml", text6: "mg/ml", text7: "ml", text8: "mg/ml")
            tabBarSelected = 3
            self.createButton.isEnabled = true
            self.createButton.alpha = 1
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
        createButton.layer.cornerRadius = 12
        createButton.layer.backgroundColor = UIColor(red:0.11, green:0.67, blue:0.36, alpha:1.0).cgColor
        createButton.setTitleColor(UIColor.white, for: .normal)
        navigationController?.isNavigationBarHidden = false
    }
}
