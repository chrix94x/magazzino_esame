//
//  ProductsTableViewController.swift
//  CMarket
//
//  Created by christian scorza on 08/04/16.
//  Copyright © 2016 christian scorza. All rights reserved.
//




//SCRITTO TUTTO DA NOI !!!!!! 





import UIKit
class ProductsTableViewController: UITableViewController {

    var products:  [Product]?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loadDataFromServer()
    }



    func loadDataFromServer_FAKE(){
        let p1 = Product(name: "banane", cost: 3)
        let p2 = Product(name: "pere", cost: 4)
        
        products = [Product]()
        
        products?.append(p1)
        products?.append(p2)
    }
    
    func loadDataFromServer(){
        loadDataFromServer_FAKE()
    }
    
    
    
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if products != nil{
            let n = products!.count
            return n
        }
        return 0
    }


    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ProductCellID", forIndexPath: indexPath)

        
        let row = indexPath.row
        // Configure the cell...
        
       // let s = "\(row)"
        let p = self.products![row]
        cell.textLabel!.text = "\(p.name!)  -- \(p.cost!)"
        return cell
    }


    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
