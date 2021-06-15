//
//  addCityViewController.swift
//  FinartzWeatherApp
//
//  Created by Emin Çelikkan on 14.06.2021.
//

import UIKit
import CoreData

class addCityViewController: UIViewController {
    var tempCityText  = ""
    
    
    
    var name1 = String()
    var temp1 = Double()
    var temp_max1 = Double()
    var temp_min1 = Double()
    var descr1 = String()
    
   
    @IBOutlet weak var addCityBTN: UIButton!
    @IBOutlet weak var addCityTF: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        
       
    }
    
    ////Function for  editing temperature
//    func tempToCelcius(temp: Double){
//        var temp = temp - 273.15
//        var floored = (Double(floor(temp*10)/10))
//
//
//
//
//        print(String(format: "%.2f" , temp))
//
//
//    }
    

    @IBAction func addCityButtonClicked(_ sender: Any) {
        print("Add City Button Clicked")
        
        //API KEY FOR CURRENT WEATHER DATA SERVICE = 9a0f65b1ef4654d77544577e7e571493
        let searchedCity = addCityTF.text!
        let url = URL(string: "http://api.openweathermap.org/data/2.5/weather?q=\(searchedCity)&appid=9a0f65b1ef4654d77544577e7e571493")
        let session = URLSession.shared
        let task = session.dataTask(with: url!) { (data, response, error) in
            if error != nil {
                //Error alert
                let alertController = UIAlertController(title: "Error Occured.", message: error?.localizedDescription , preferredStyle: .alert)
                let alerAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                alertController.addAction(alerAction)
                self.present(alertController, animated: true, completion: nil)
            }else{
                if data != nil {
                    do{
                        
                    let jsonResponse = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as! Dictionary<String , Any>
                        
                       
                        DispatchQueue.main.async {
                            //Saving Json results to the coredata to show in tableview with it's only name and temperature.
                            let appdelegate = UIApplication.shared.delegate as! AppDelegate
                            let context = appdelegate.persistentContainer.viewContext
                            let newCity = NSEntityDescription.insertNewObject(forEntityName: "City", into: context)
                            
                            
                            
 
                            if let name = jsonResponse["name"]{
                                self.name1 = name as! String
                                print(self.name1)
                                
                                

                                
                                
                            }
                            
 
                            if let main = jsonResponse["main"] as? [String : Double]{

                                print("Temprature is : \(main["temp"]!)")
//                                print("Maximum Temprature is : \(main["temp_max"]!)")
//                                print("Minimum Temprature is : \(main["temp_min"]!)")
//
//
//                                let tempinCelcius = main["temp"]! - 273.15
//                                print(tempinCelcius)
//
//                                self.tempToCelcius(temp: main["temp_min"]!)
                                self.temp1 = (Double(floor((main["temp"]!-273.15)*10)/10))
                                
                                self.temp_max1 = (Double(floor((main["temp_max"]!-273.15)*10)/10))
                                self.temp_min1 = (Double(floor((main["temp_min"]!-273.15)*10)/10))
                                


                            }
                            print("saved name is\(self.name1)")
                            newCity.setValue(self.name1, forKey: "name")
                            newCity.setValue(String(self.temp1), forKey: "temp")
                            newCity.setValue(String(self.temp_min1), forKey: "temp_min")
                            newCity.setValue(String(self.temp_max1), forKey: "temp_max")
                            
                            //For avoiding json error, saving the exact text that we searched for in addcity screen.
                            newCity.setValue(self.addCityTF.text, forKey: "searchedtext")
                            do{
                                try context.save()
                            }catch{
                                print("error while saving name")
                            }
    
                            
                           


                        }
                            
                       
                        
                        
                    }catch{
                        print(error.localizedDescription)
                    }
                    
                }
            }
        }
        task.resume()
        //Notification Part for reloading data after add city to the array and go back to the tableview.
        NotificationCenter.default.post(name: NSNotification.Name("newData"), object: nil)
        self.navigationController?.popViewController(animated: true)

      
        
    }

}
