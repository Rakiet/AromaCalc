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
}

class HeadCollectionTable: UITableViewController {

    var liquidsData: [DataLiquids] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        readBase()
        loadStyle()
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "liquidCell", for: indexPath)

         cell.textLabel?.text = liquidsData[indexPath.row].nameCompany

        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

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
                liquidsData.append(DataLiquids(nameCompany: nCompany, nameAroma: nAroma, description: description, stars: stars, sku: sku))
            }
        } catch {
            print("Failed")
        }
    }
    
    func loadStyle(){
        navigationController?.isNavigationBarHidden = false //ukrywanie navibar
        view.backgroundColor = UIColor(red:0.85, green:0.85, blue:0.85, alpha:1.0)
    }
}
