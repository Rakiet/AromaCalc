//
//  DetailViewCollection.swift
//  E-somke
//
//  Created by Piotr Żakieta on 20/06/2019.
//  Copyright © 2019 Piotr Żakieta. All rights reserved.
//

import UIKit

class DetailViewCollection: UIViewController {

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
        readData()
    }
    
    func readData() {
        guard nameCompany != nil, nameAroma != nil,stars != nil,sku != nil,date != nil,conNicotine != nil,conAroma != nil,descriptionLiquid != nil else {
            
            self.navigationController?.popViewController(animated: true)
            self.allFunction.addAlert(controller: self, title: "Błąd", text: "Coś poszło nie tak.\nKod błędu #001")
            
            return
        }
        headLabel.text = nameCompany!
        secondHeadLabel.text = nameAroma!
        nicotineLabel.text = "🚬 \(conNicotine!)"
        aromaLabel.text = "🍒 \(conAroma!)"
        descriptionText.text = descriptionLiquid!
        
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
        readData()
    }
    
    func loadStyle() {
        saveButton.layer.cornerRadius = 12
        saveButton.layer.backgroundColor = UIColor(red:0.11, green:0.67, blue:0.36, alpha:1.0).cgColor
        saveButton.setTitleColor(UIColor.white, for: .normal)
        createAgainButton.layer.cornerRadius = 12
        createAgainButton.layer.backgroundColor = UIColor(red:0.00, green:0.66, blue:0.95, alpha:1.0).cgColor
        createAgainButton.setTitleColor(UIColor.white, for: .normal)
    }
    

}
