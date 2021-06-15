//
//  ViewController.swift
//  FinartzWeatherApp
//
//  Created by Emin Çelikkan on 11.06.2021.
//

import UIKit
import CoreData
class ListViewController: UIViewController,UITableViewDelegate, UITableViewDataSource{
    var exList = [""]
    var tempCity = ""
   
    
    var nameArray = [String]()
    var tempArray = [String]()
    var descArray = [String]()
    var tempMinArray = [String]()
    var tempMaxArray = [String]()
    var selectedCity = [String]()
    
    
//    var nameArr = [String]()
//    var tempArr = [String]()
    
    let addCityVC = addCityViewController.self
    @IBOutlet weak var cityListTableView: UITableView!
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return nameArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cityListCell") as! ListTableViewCell
        cell.nameLBL.text = nameArray[indexPath.row]
        cell.tempLBL.text = tempArray[indexPath.row] + "°C"
        
        
        return cell
    }
    
    
    @objc func getData(){
        //To avoid duplicate cells, we are cleaning all printing arrays.
        nameArray.removeAll(keepingCapacity: false)
        tempArray.removeAll(keepingCapacity: false)
        
        //Taking Data from the CoreData that we saved before on AddCityViewController
        let appdelegate = UIApplication.shared.delegate as! AppDelegate
        
        let context = appdelegate.persistentContainer.viewContext
        let fetchrequest = NSFetchRequest<NSFetchRequestResult>(entityName: "City")
        
        fetchrequest.returnsObjectsAsFaults = false
        do{
               let results =  try context.fetch(fetchrequest)
            
            for result in results as! [NSManagedObject]{
                if let name = result.value(forKey: "name") as? String{
                    self.nameArray.append(name)
                }
                if let temp = result.value(forKey: "temp") as? String{
                    self.tempArray.append(temp)
                }
                if let tempmax = result.value(forKey: "temp_max") as? String{
                    self.tempMaxArray.append(tempmax)
                }
                if let tempmin = result.value(forKey: "temp_min") as? String{
                    self.tempMinArray.append(tempmin) 
                }
                //Array creating to send keyword that we search in city search textfield in addcityviewcontroller
                if let selectedcity = result.value(forKey: "searchedtext") as? String{
                    self.selectedCity.append(selectedcity)
                }
                
                self.cityListTableView.reloadData()
            }
        }
        catch{
            print("error")
        }
        self.cityListTableView.reloadData()

    }
  
  
    @objc func addCityToList(){
        
        
        tempCity = ""
        let addCity = self.storyboard?.instantiateViewController(withIdentifier: "addCityVC") as! addCityViewController
        self.navigationController?.pushViewController(addCity, animated: true)
        print("Add City Screen Presented.")
    }
    override func viewDidLoad() {
        
        
        
        cityListTableView.dataSource = self
        cityListTableView.delegate = self
        navigationController?.navigationBar.topItem?.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addCityToList))
        super.viewDidLoad()
        getData()
       
        

    }
    

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            //Deleting part from the coredata.
            let appdelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appdelegate.persistentContainer.viewContext
            let fetchrequest = NSFetchRequest<NSFetchRequestResult>(entityName: "City")
            
            fetchrequest.returnsObjectsAsFaults = false
            
            do{
                let results = try context.fetch(fetchrequest)
                
                
                if results.count > 0 {
                    for result in results as! [NSManagedObject]{
                        if let name = result.value(forKey: "name") as? String{
                            if name == nameArray[indexPath.row]{
                                context.delete(result)
                                nameArray.remove(at: indexPath.row)
                                tempArray.remove(at: indexPath.row)
                                self.cityListTableView.deleteRows(at: [indexPath], with: .fade)

                                self.cityListTableView.reloadData()
                                do{
                                try context.save()
                                }catch{
                                    print("error saving")
                                }
                                break
                            }
                        }
                    }
                }
            }catch{
                print("error")
            }
           
            
            self.cityListTableView.reloadData()
            
        }
    }
    override func viewWillAppear(_ animated: Bool) {
       //Checking the notification for call getData() Function after we add any city from addcity view controller, addcity page sends newData notification and when listViewController will appear, it checks the notification and call getData() function again to reload tableView Array again.
        NotificationCenter.default.addObserver(self, selector: #selector(getData), name: NSNotification.Name("newData"), object: nil)
       
    }
    
    //For data transferring form ListViewController to DetailsViewController to know which keyword is going to be searched in json request
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detailsSegue"{
            let destinationVC = segue.destination as! DetailsViewController
            destinationVC.selectedCity = tempCity
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tempCity = selectedCity[indexPath.row]
        print("Selected City is: \(tempCity)")
        performSegue(withIdentifier: "detailsSegue", sender: nil)
    }
    
  
    
    
}

