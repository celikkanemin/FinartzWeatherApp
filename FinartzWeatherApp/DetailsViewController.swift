//
//  DetailsViewController.swift
//  FinartzWeatherApp
//
//  Created by Emin Çelikkan on 14.06.2021.
//

import UIKit
import CoreData

class DetailsViewController: UIViewController {
    //Outlets
    @IBOutlet weak var countryLBL: UILabel!
    @IBOutlet weak var pressureLBL: UILabel!
    @IBOutlet weak var sunsetLBL: UILabel!
    @IBOutlet weak var sunriseLBL: UILabel!
    @IBOutlet weak var windDegLBL: UILabel!
    @IBOutlet weak var windSpeedLBL: UILabel!
    @IBOutlet weak var tempMaxLBL: UILabel!
    @IBOutlet weak var tempMinLBL: UILabel!
    @IBOutlet weak var cityNameLBL: UILabel!
    @IBOutlet weak var descLBL: UILabel!
    @IBOutlet weak var tempLBL: UILabel!
    @IBOutlet weak var feelsLikeLBL: UILabel!
    
    //variable for printing the selected city's informations from JSON
    var selectedCity = ""
    
    
    override func viewWillAppear(_ animated: Bool) {
        print(selectedCity)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Part for avoiding optional value error on json, for example with spaces and not english letters.
        selectedCity = selectedCity.lowercased()
        selectedCity = selectedCity.trimmingCharacters(in: .whitespaces)
        print("edited string is : \(selectedCity)")
       print("Listing City is: ")
        print(selectedCity)
        let url = URL(string: "http://api.openweathermap.org/data/2.5/weather?q=\(selectedCity)&appid=9a0f65b1ef4654d77544577e7e571493")
        let session = URLSession.shared
        let task = session.dataTask(with: url!) { (data, response, error) in
            if error != nil {
                let alertController = UIAlertController(title: "Error Occured.", message: error?.localizedDescription , preferredStyle: .alert)
                let alerAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                alertController.addAction(alerAction)
                self.present(alertController, animated: true, completion: nil)
            }else{
                if data != nil {
                    do{
                        
                    let jsonResponse = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as! Dictionary<String , Any>
                        
                       // print("asdadasd \(String(describing: jsonResponse["weather"]))")
                        DispatchQueue.main.async {
                            if let weather = jsonResponse["weather"] as? [String : Any]{
                                print("weather result is \(weather)")
                                //Value of type 'Any' has no subscripts error while trying to get weather["description"] value from JSON Data. because of that i can't assing DescriptionLabel in detailsViewController.
                                //print(String(describing:weather["0"]!))
                               // print(String(describing:weather{"description"}))
                              //  self.descLBL.text = String(describing:weather["description"])
                            }
                            if let name = jsonResponse["name"]{
                                self.cityNameLBL.text = String(describing:name)
      
                            }

                            if let main = jsonResponse["main"] as? [String : Double]{

                                print("Temperature is : \(main["temp"]!)")

                                self.tempLBL.text = String(describing:(Double(floor((main["temp"]!-273.15)*10)/10))) + "°C"
                                
                                self.tempMaxLBL.text = String(describing: (Double(floor((main["temp_max"]!-273.15)*10)/10))) + "°C"
                                self.tempMinLBL.text = String(describing:(Double(floor((main["temp_min"]!-273.15)*10)/10))) + "°C"
                                self.feelsLikeLBL.text = "Feels Like:" + String(describing:(Double(floor((main["feels_like"]!-273.15)*10)/10))) + "°C"
                                self.pressureLBL.text = String(describing:main["pressure"]!) + "ATM"
                            }
                            if let sys = jsonResponse["sys"] as? [String : Any]{
                                self.sunriseLBL.text = String(describing:sys["sunrise"]!)
                                self.sunsetLBL.text = String(describing: sys["sunset"]!)
                                self.countryLBL.text = String(describing: sys["country"]!)
                            }
                            if let wind = jsonResponse["wind"] as? [String : Double]{
                                self.windDegLBL.text = String(describing:wind["deg"]!)
                                self.windSpeedLBL.text = String(describing:wind["speed"]!)
                            }
                        }
                            
                            
                            
                        
                    }catch{
                        print(error.localizedDescription)
                    }
                }
            }
        }
        task.resume()
    }
}


