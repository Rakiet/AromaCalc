//
//  ReadyLiquidViewController.swift
//  E-somke
//
//  Created by Piotr Żakieta on 19/03/2019.
//  Copyright © 2019 Piotr Żakieta. All rights reserved.
//

import UIKit

class ReadyLiquidViewController: UIViewController {

    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet weak var nextOrReturnButton: UIButton!
    @IBOutlet weak var doneButton: UIButton!
    
    var action = 1
    var aroma:Double!
    var nicotine:Double!
    var base:Double!
    var tabBarChoose:Int!
    override func viewDidLoad() {
        super.viewDidLoad()
        if tabBarChoose == 1{
        textLabel.text = "Przygotuj niezbedne bazy oraz aromaty/esencje. Pamiętaj też o środkach ostrożności i próbówkach lub szczykawkach do odmierzania."
        } else if tabBarChoose == 2{
            textLabel.text = "Przygotuj premix oraz bazy. Pamiętaj też o środkach ostrożności i próbówkach lub szczykawkach do odmierzania."
        }
        loadnigStyle()
    }
    
    @IBAction func nextAction(_ sender: Any) {
        if tabBarChoose == 1 {
        if aroma > 0 && base > 0{
        switch action {
        case 1:
            textLabel.text = "Dodaj \(aroma!) ml aromatu"
        case 2:
            textLabel.text = "Dodaj \(nicotine!)ml bazy nikotynowej"
        case 3:
            textLabel.text = "Dodaj \(base!)ml bazy 0"
        default:
            textLabel.text = "Gotowe, potrząśnij porządnie buteleczką i odłóż na kilka dni."
            nextOrReturnButton.setTitle("Jeszcze raz", for: .normal)
            action = 0
        }
            action += 1
        }
        } else if tabBarChoose == 2 {
            if aroma > 0 && base > 0{
                switch action {
                case 1:
                    textLabel.text = "Otwórz buteleczkę z \(aroma!) ml premixu"
                case 2:
                    textLabel.text = "Dodaj \(nicotine!)ml bazy nikotynowej"
                case 3:
                    textLabel.text = "Dodaj \(base!)ml bazy 0"
                default:
                    textLabel.text = "Gotowe, potrząśnij porządnie buteleczką, miłego palenia."
                    nextOrReturnButton.setTitle("Jeszcze raz", for: .normal)
                    action = 0
                }
                action += 1
            }
        }
    }
    
    @IBAction func doneAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
        
    }
    
    func loadnigStyle(){
        nextOrReturnButton.layer.cornerRadius = 12
        nextOrReturnButton.layer.backgroundColor = UIColor(red:0.11, green:0.67, blue:0.36, alpha:1.0).cgColor
        nextOrReturnButton.setTitleColor(UIColor.white, for: .normal)
        doneButton.layer.cornerRadius = 12
        doneButton.layer.backgroundColor = UIColor(red:0.00, green:0.66, blue:0.95, alpha:1.0).cgColor
        doneButton.setTitleColor(UIColor.white, for: .normal)
        nextOrReturnButton.setTitle("Następny Krok", for: .normal)
        doneButton.setTitle("Koniec", for: .normal)
        navigationController?.isToolbarHidden = true
        
        
    
    }

}
