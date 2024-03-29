//
//  HeadCollectionTable.swift
//  E-somke
//
//  Created by Piotr Żakieta on 14/06/2019.
//  Copyright © 2019 Piotr Żakieta. All rights reserved.
//

import UIKit
import CoreData

struct DataLiquids {
    var nameCompany: String
    var nameAroma: String
    var description: String
    var stars: Int16
    var sku: String
    var date: Date
    var conNicotine: Double
    var conAroma: Double
}

class HeadCollectionTable: UITableViewController {

    var liquidsData: [DataLiquids] = []
    
    
    @IBOutlet var tableViewCollection: UITableView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        loadTable()
        loadStyle()
        tableViewCollection.rowHeight = 80
        
        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return liquidsData.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "liquidCell", for: indexPath) as! HeadCollectionCell

        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "dd/MM/yyyy"
        
         cell.headLabelCell?.text = liquidsData[indexPath.row].nameCompany
        cell.dateCell?.text = dateFormat.string(from: liquidsData[indexPath.row].date)
        cell.secondLabelCell?.text = liquidsData[indexPath.row].nameAroma
        
//        cell.starsCell.textColor = UIColor.black
//        cell.starsCell.font = cell.starsCell.font.withSize(23)
            switch liquidsData[indexPath.row].stars {
            case 1:
                cell.starsCell?.text = "★☆☆☆☆"
            case 2:
                cell.starsCell?.text = "★★☆☆☆"
            case 3:
                cell.starsCell?.text = "★★★☆☆"
            case 4:
                cell.starsCell?.text = "★★★★☆"
            case 5:
                cell.starsCell?.text = "★★★★★"
            default:
                
                cell.starsCell?.text = ""
            }
        
        
        
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if (segue.identifier == "showDetail") {
            
            let dvc = segue.destination as! DetailViewCollection
            
            if let indexPath = self.tableView.indexPathForSelectedRow {
                
//                dvc.sentData1 = titleList[indexPath.row] as String
//
//                dvc.sentData2 = descriptionList[indexPath.row] as String
//
//                dvc.sentData3 = imageList[indexPath.row] as String
                
                dvc.nameCompany = liquidsData[indexPath.row].nameCompany
                dvc.nameAroma = liquidsData[indexPath.row].nameAroma
                dvc.descriptionLiquid = liquidsData[indexPath.row].description
                dvc.stars = liquidsData[indexPath.row].stars
                dvc.sku = liquidsData[indexPath.row].sku
                dvc.date = liquidsData[indexPath.row].date
                dvc.conNicotine = liquidsData[indexPath.row].conNicotine
                dvc.conAroma = liquidsData[indexPath.row].conAroma
                dvc.indexNumber = indexPath.row
                print(indexPath.row)
            }
            
        }
        
        
        
    }
    
    func loadTable(){
        liquidsData.removeAll()
        readBase()
        tableView.reloadData()
    }

    func readBase(){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "MyLiquid")
        request.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(request)
            for data in result as! [NSManagedObject] {
                let nCompany = data.value(forKey: "nameCompany") as! String
                let nAroma = data.value(forKey: "nameAroma") as! String
                let description = data.value(forKey: "owndescription") as! String
                let sku = data.value(forKey: "sku") as! String
                let stars = data.value(forKey: "stars") as! Int16
                let date = data.value(forKey: "date") as! Date
                let nico = data.value(forKey: "nicotine") as! Double
                let aroma = data.value(forKey: "aroma") as! Double
                liquidsData.append(DataLiquids(nameCompany: nCompany, nameAroma: nAroma, description: description, stars: stars, sku: sku, date: date, conNicotine: nico, conAroma: aroma))
            }
        } catch {
            print("Failed")
        }
    }
    
    func loadStyle(){
        navigationController?.isNavigationBarHidden = false //ukrywanie navibar
        self.navigationItem.title = "Moje Liquidy"
        view.backgroundColor = UIColor(red:0.85, green:0.85, blue:0.85, alpha:1.0)
    }
}
