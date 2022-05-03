//
//  SmartCalculator.swift
//  E-somke
//
//  Created by Piotr Żakieta on 06/05/2019.
//  Copyright © 2019 Piotr Żakieta. All rights reserved.
//

import UIKit

class SmartCalculator: UIViewController, UITextFieldDelegate {

    var allFunction = AllFunction()
    
    //zmienne odpowiedzialne za widok
    
    @IBOutlet weak var headLabel: UILabel!
    @IBOutlet weak var sliderLabel: UILabel!
    @IBOutlet weak var ownAroma: UISwitch!
    @IBOutlet weak var stackSlider: UIStackView!
    @IBOutlet weak var nextButton: UIButton!
    
    //zmienne pobierne z widoku
    @IBOutlet weak var readyProductTextField: UITextField!
    @IBOutlet weak var nicotine: UITextField!
    @IBOutlet weak var manualAroma: UITextField!
    @IBOutlet weak var aromaSlider: UISlider!
    @IBOutlet weak var nicotineBase: UITextField!
    @IBOutlet weak var marginSize: NSLayoutConstraint!
    
    //zmienne otrzymane z poprzedniego ekranu
    var nameCompany: String?
    var nameAroma: String?
    var concentrationMin: Int?
    var concentrationMax: Int?
    var aromaSku: String?
    
    // zmienna dodatkowe potrzebne do ponownego przygotowania
    
    var createAgain: Bool? = false
    var readyNicotinCon: Double?
    var readyAromaCon: Double?
    
    // zmienne  pomocnicze
    
    var ownConAroma = false
    
    var readyNicotine = 0.0
    var readyAroma = 0.0
    var readyLastBase = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        startSettings()
        createAgainFunc()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        
        
        
    }
    
    @IBAction func onOffOwnAroma(_ sender: UISwitch) {
        
        UIView.animate(withDuration: 0.5, animations: { () -> Void in
                self.stackSlider.alpha = 0
                self.manualAroma.alpha = 0
        })
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut, animations: {
            if sender.isOn {
                self.manualAroma.text = ""
                self.stackSlider.alpha = 0
                self.manualAroma.alpha = 1
                self.stackSlider.isHidden = true
                self.manualAroma.isHidden = false
                self.ownConAroma = true
                self.nextButton.isEnabled = false
                self.nextButton.alpha = 0.4
            } else {
                self.stackSlider.alpha = 1
                self.manualAroma.alpha = 0
                self.stackSlider.isHidden = false
                self.manualAroma.isHidden = true
                self.ownConAroma = false
            }
        })
    }
    
    @IBAction func concentrationSlider(_ sender: UISlider) {
        
        aromaSlider.value = roundTo(number: aromaSlider.value, precision: 1)
        self.sliderLabel.text = "\(aromaSlider.value)%"
    }
    
    

    
    
    
    @IBAction func liquidComponents() {
        changeToDot()
        
        var aromaC = 0.0
        guard let readyP = Double(readyProductTextField.text!) else {return}//ilosc gotowego produktu
        guard let nico = Double(nicotine.text!) else {return}// nikotyna w gotowym liquidzie
        guard let nicoB = Double(nicotineBase.text!) else {return}// baza nikotynowa
        if ownAroma.isOn {
            guard let aroma = Double(manualAroma.text!) else {
                nextButton.isEnabled = false
                nextButton.alpha = 0.4
                return}
            aromaC = aroma
        } else {
            aromaC = Double(aromaSlider.value)
        }
        
        let howAroma: Double = (readyP/100) * aromaC
        let howNicotine = (nico/nicoB) * readyP
        readyLastBase = readyP
        readyLastBase -= howAroma
        readyLastBase -= howNicotine
        readyNicotine = howNicotine
        readyAroma = howAroma
        print(readyNicotine)
        var hmmmmError = readyP
        hmmmmError -= (readyP/100) * aromaC
        
        print(hmmmmError)
        if readyNicotine > hmmmmError{ //Wyrzuca błąd jeżeli ilośc dodanej nikotyny jest większe niż wolne miejsce w butelce
            var youNeed = (nico/hmmmmError) * readyP
            if roundToDouble(number: youNeed, precision: 1) == nico{
                youNeed += 0.1
            }
            if youNeed < 0 {
                self.allFunction.addAlert(controller: self, title: "Błąd", text: "Dane są nieprawidłowe.")
            } else{
            self.allFunction.addAlert(controller: self, title: "Błąd", text: "Z podanej bazy nikotynowej nie można otrzymać oczekiwanego stężenia nikotyny. Twoja baza musi posiadać min \(roundToDouble(number: youNeed, precision: 1))mg/ml nikotyny ")
            }
//            self.createButton.isEnabled = false
//            self.createButton.alpha = 0.6
        } else {
//            self.createButton.isEnabled = true
//            self.createButton.alpha = 1
            
            
            nextButton.isEnabled = true
            nextButton.alpha = 1
           print("\(roundToDouble(number: readyAroma, precision: 1)) aromatu\n\n\(roundToDouble(number: readyLastBase, precision: 1)) bazy bez nikotyny\n\n\(roundToDouble(number: readyNicotine, precision: 1)) bazy nikotynowej")
        }
    }
    
    
    //przekazywanie danych na kolejny ekran
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "saveSmartLiquid"{
            let viewController = segue.destination as! readyProduct
            viewController.nameCompany = self.nameCompany
            viewController.nameAroma = self.nameAroma
            if ownAroma.isOn {
                guard let aroma = Double(manualAroma.text!) else {return}
                viewController.conAroma = aroma
            } else {
                viewController.conAroma = Double(aromaSlider.value)
            }
            guard let nico = Double(nicotine.text!) else {return}
            viewController.conNicotine = nico
            viewController.aromaSku = self.aromaSku
            
            viewController.readyAroma = roundToDouble(number: self.readyAroma, precision: 1)
            viewController.readyLastBase = roundToDouble(number: self.readyLastBase, precision: 1)
            viewController.readyNicotine = roundToDouble(number: self.readyNicotine, precision: 1)
        }
    }
    
    
    func roundTo(number: Float, precision: Int) -> Float {
        var power: Float = 1
        for _ in 1...precision {
            power *= 10
        }
        let rounded = Float(round(power * number)/power)
        return rounded
    }
    
    func roundToDouble(number: Double, precision: Int) -> Double {
        var power: Double = 1
        for _ in 1...precision {
            power *= 10
        }
        let rounded = Double(round(power * number)/power)
        return rounded
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
    
    @IBAction func nextView(_ sender: UIButton) {
    }
    
    
    
    func startSettings(){
        stackSlider.isHidden = false
        manualAroma.isHidden = true
        ownAroma.isOn = false
        guard let conMin = concentrationMin else {return}
        guard let conMax = concentrationMax else {return}
        aromaSlider.minimumValue = Float(conMin)
        aromaSlider.maximumValue = Float(conMax)
        let startValue = (conMin + conMax) / 2
        aromaSlider.value = Float(startValue)
        sliderLabel.text = "\(startValue)%"
        
        guard let nCompany = nameCompany else {return}
        guard let nAroma = nameAroma else {return}
        headLabel.text = "\(nCompany)\n\(nAroma)"
        
        
        self.readyProductTextField.delegate = self
        self.nicotine.delegate = self
        self.nicotineBase.delegate = self
        self.manualAroma.delegate = self
        
        nextButton.isEnabled = false
        nextButton.alpha = 0.4
        
        //loading style
        navigationController?.isNavigationBarHidden = false
        nextButton.layer.cornerRadius = 12
        nextButton.layer.backgroundColor = UIColor(red:0.00, green:0.60, blue:0.40, alpha:1.0).cgColor
        nextButton.setTitleColor(UIColor.white, for: .normal)
    }
    
    
    //pokazywanie i ukrywanie klawiatury
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                
                let aaa = keyboardSize.height + marginSize.constant.distance(to: view.frame.minY)
                print(marginSize.constant.distance(to: view.frame.minY))
                self.view.frame.origin.y -= aaa
                
                
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
    
    func changeToDot() {
        var ready = ""
        for i in readyProductTextField.text!{
            if i == ","{
                ready += "."
            }else{
            ready += "\(i)"
        
            }
        
        }
        readyProductTextField.text = ready
        ready = ""
        for i in nicotine.text!{
            if i == ","{
                ready += "."
            }else{
                ready += "\(i)"
                
            }
            
        }
        nicotine.text = ready
        ready = ""
        
        for i in manualAroma.text!{
            if i == ","{
                ready += "."
            }else{
                ready += "\(i)"
                
            }
            
        }
        manualAroma.text = ready
        ready = ""
        
        for i in nicotineBase.text!{
            if i == ","{
                ready += "."
            }else{
                ready += "\(i)"
                
            }
            
        }
        nicotineBase.text = ready
        ready = ""
    }
    
    func createAgainFunc() {
        if createAgain!{
            ownAroma.isOn = true
            onOffOwnAroma(ownAroma)
            nicotine.text = String(readyNicotinCon!)
            manualAroma.text = String(readyAromaCon!)
        }
    }
    

    
}
