//
//  ViewController.swift
//  StockApp
//
//  Created by Arthur Cheung on 2018-11-27.
//  Copyright © 2018 Arthur Cheung. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController,UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate,secToOne {
    
    @IBOutlet weak var stockSearchBar: UISearchBar!
    
    @IBOutlet weak var stockTable: UITableView!
    var myContext =  (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    lazy var allStocks : [Stock]? = [Stock]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //self.navigationItem.rightBarButtonItem = self.addButton
        fetch()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print ("add segue")
        let vc = (segue.destination as! SecondViewController)
        vc.delegate = self
    }
    
    func entryCallBack(){
        /*if let viewController = self.storyboard?.instantiateViewController(withIdentifier:"SecondViewController"){
            self.present(viewController, animated: true, completion: nil)
        }*/
        //print("hello there")
        fetch()
    }
    
    func fetch()  {
        let myFetchRequest : NSFetchRequest<Stock> = Stock.fetchRequest()
        let sorter1 = NSSortDescriptor(key: "name", ascending: true)
        let sorter2 = NSSortDescriptor(key: "symbol", ascending: true)
        
        myFetchRequest.sortDescriptors = [sorter1, sorter2]
        
        do {
            allStocks =  try  myContext.fetch(myFetchRequest)
            stockTable.reloadData()
            
        }catch{
            
            print("fetch throw an error")
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let count = allStocks?.count {
            return count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        //var thisPerson = allPersons?[indexPath.row]
        
        let itemFromArrayFromAPI = allStocks?[indexPath.row]
        let marketName = itemFromArrayFromAPI?.name
        let marketSymbol = itemFromArrayFromAPI?.symbol
        
        cell?.textLabel?.text = marketSymbol;
        cell?.detailTextLabel?.text = marketName;
        
        //cell?.textLabel?.text = thisPerson?.first_name
        //cell?.detailTextLabel?.text = thisPerson?.last_name
        
        
        return cell!
    }
    
    func searchBar(_ searchBar: UISearchBar,
                   textDidChange searchText: String){
        
        if !searchText.isEmpty {
            
            let myFetchRequest : NSFetchRequest<Stock> = Stock.fetchRequest()
            let sorter1 = NSSortDescriptor(key: "name", ascending: true)
            let sorter2 = NSSortDescriptor(key: "symbol", ascending: true)
            
            myFetchRequest.sortDescriptors = [sorter1, sorter2]
            
            myFetchRequest.predicate = NSPredicate(format: "symbol contains[cd] %@ or name contains[cd] %@", searchText,searchText)
            
            do {
                allStocks =  try  myContext.fetch(myFetchRequest)
                stockTable.reloadData()
                
            }catch{
                
                print("fetch throw an error")
            }
            
        }
        else{
            fetch()
        }
        //print("\(String(describing: myResult?.lastObject))")
    }
    
}

