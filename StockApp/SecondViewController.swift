//
//  SecondViewController.swift
//  StockApp
//
//  Created by Arthur Cheung on 2018-11-28.
//  Copyright © 2018 Arthur Cheung. All rights reserved.
//

import UIKit
import CoreData

protocol secToOne{
    func entryCallBack()
}

class SecondViewController: UIViewController,UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate,YahooSearchDelegate {
    
    
    @IBOutlet weak var stockTable: UITableView!
    @IBOutlet weak var stockSearchBar: UISearchBar!
    @IBOutlet weak var stockEntry: UITableViewCell!
    var myContext =  (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var yahoosearch : YahooSearchAPI?
    var myResult : NSArray?
    lazy var allStock : [Stock]? = [Stock]()
    lazy var stockCount : [Stock]? = [Stock]()
    var delegate: ViewController!
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //if let count = allPersons?.count {
        //    return count
        //}
        return myResult?.count ?? 0
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        //var thisPerson = allPersons?[indexPath.row]
        
        let itemFromArrayFromAPI = myResult?.object(at:indexPath.row) as! NSMutableDictionary
        let marketName = itemFromArrayFromAPI.value(forKey: "name")
        let marketSymbol = itemFromArrayFromAPI.value(forKey: "symbol")
        
        cell?.textLabel?.text = marketSymbol as? String;
        cell?.detailTextLabel?.text = marketName as? String;
        
        //cell?.textLabel?.text = thisPerson?.first_name
        //cell?.detailTextLabel?.text = thisPerson?.last_name
        
        
        return cell!
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        yahoosearch = YahooSearchAPI()
        yahoosearch?.delegate = self as YahooSearchDelegate

        // Do any additional setup after loading the view.
    }
    
    func searchBar(_ searchBar: UISearchBar,
                   textDidChange searchText: String){
        
        if !searchText.isEmpty {
            yahoosearch?.searchYahooAPIwithText(searchText)
        }
        
            //print("\(String(describing: myResult?.lastObject))")
    }
    func yahooDidFinish(with results: [Any]!) {
        myResult = results! as NSArray
        stockTable.reloadData()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        let itemFromArrayFromAPI = myResult?.object(at:indexPath.row) as! NSMutableDictionary
        let marketName = itemFromArrayFromAPI.value(forKey: "name")
        let marketSymbol = itemFromArrayFromAPI.value(forKey: "symbol")
        
        //check symbol
        
        let myFetchRequest : NSFetchRequest<Stock> = Stock.fetchRequest()
        
        myFetchRequest.predicate = NSPredicate(format: "symbol = %@", marketSymbol as? String ?? "")
        
        do {
            stockCount =  try  myContext.fetch(myFetchRequest)
            
        }catch{
            
            print("fetch throw an error")
        }
        
        
        
        if(stockCount?.count==0){
            let stockToSave = NSEntityDescription.insertNewObject(forEntityName: "Stock", into: myContext) as! Stock
            
            stockToSave.name = marketName as? String
            stockToSave.symbol = marketSymbol as? String

            allStock?.append(stockToSave)
            
            (UIApplication.shared.delegate as! AppDelegate).saveContext()
            print("saved")
        }
        //print("row: \(indexPath.row)")
        //navigationController?.popViewController(animated: true)
        
        self.dismiss(animated: true) {
            self.delegate?.entryCallBack()
        }
        
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
