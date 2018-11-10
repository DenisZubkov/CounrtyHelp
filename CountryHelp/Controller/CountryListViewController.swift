//
//  ViewController.swift
//  CountryHelp
//
//  Created by Dennis Zubkoff on 25/06/2018.
//  Copyright © 2018 Dennis Zubkoff. All rights reserved.
//

import UIKit

class CountryListViewController: UIViewController {
    
    let dataProvider = DataProvider()
    
    @IBOutlet weak var loadButton: UIBarButtonItem!
    @IBOutlet weak var countryTableView: UITableView!
    @IBOutlet weak var loadActivityIndicator: UIActivityIndicatorView!
    
    var countries: [Country] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadActivityIndicator.isHidden = true
        countryTableView.tableFooterView = UIView()
        if let data = UserDefaults.standard.value(forKey: "URLSession")  as? NSData {
            appendToCountries(from: data as Data)
        } else {
            if !loadCoutryFromNet() {
                showErrorMessage(title: "Ошибка", message: "Ресурс недоступен")
                showLoadResult()
            }
        }
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func addErrorMessageString() {
        countries.removeAll()
        countries.append(Country(continent: "", capital: "Ресурс недоступен 🙁", languages: "", geonameId: nil, south: nil, isoAlpha3: nil, north: nil, fipsCode: nil, population: nil, east: nil, isoNumeric: nil, areaInSqKm: nil, countryCode: nil, west: nil, countryName: "Была попытка загрузить...", continentName: nil, currencyCode: nil))
    }
    
    
    func showErrorMessage(title: String, message: String) {
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
    
    func showLoadResult() {
        DispatchQueue.main.async {
            self.countryTableView.reloadData()
            self.loadActivityIndicator.stopAnimating()
            self.loadActivityIndicator.hidesWhenStopped = true
            self.loadButton.isEnabled = true
        }
    }
    
    
    func appendToCountries(from data: Data) {
        do {
            let geoname = try JSONDecoder().decode(Geoname.self, from: data)
            if geoname.geonames != nil {
                self.countries = []
                for info in geoname.geonames! {
                    if let _ = info.countryName {
                        self.countries.append(info)
                    }
                }
                self.countries = self.countries.sorted(by: {$0.countryName! < $1.countryName!})
            }
            self.showLoadResult()
        } catch let jsonError {
            self.showErrorMessage(title: "Ошибка при разборе данных", message: "Невозможно разобрать JSON")
            self.showLoadResult()
            print("Error", jsonError)
        }
    }
    
    func loadViaURLSession(from url: URL) {
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data else {
                self.showErrorMessage(title: "Ошибка при запросе данных", message: (error?.localizedDescription)!)
                self.showLoadResult()
                //UserDefaults.standard.removeObject(forKey: "URLSession")
                return
            }
            let nsData = data as NSData
            UserDefaults.standard.set(nsData, forKey: "URLSession")
            self.appendToCountries(from: data)
            }.resume()
        
    }
    
    func loadCoutryFromNet() -> Bool {
        let jsonURL = "http://api.geonames.org/countryInfoJSON?&lang=ru&username=DenZu69"
        guard let url = URL(string: jsonURL) else { return false }
        loadActivityIndicator.isHidden = false
        loadActivityIndicator.startAnimating()
        loadViaURLSession(from: url)
        return true
    }

  
    @IBAction func loadCountry(_ sender: UIBarButtonItem) {
        loadButton.isEnabled = false
        if !loadCoutryFromNet() {
            addErrorMessageString()
            countryTableView.reloadData()
        }
        
        
        
    }

}

extension CountryListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return countries.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let country = countries[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! CountryTableViewCell
        cell.loadImageActivityIndicator.isHidden = true
        cell.selectionStyle = .none
        cell.countryLabel.text = country.countryName
        cell.capitalLabel.text = country.capital
        cell.flagImageView.image = UIImage(named: "blank")
        cell.loadImageActivityIndicator.isHidden = false
        cell.loadImageActivityIndicator.startAnimating()
        if let countryCode = country.countryCode {
            let url = "http://www.geonames.org/flags/x/" + countryCode.lowercased() + ".gif"
            if let imageURL = URL(string: url) {
                self.dataProvider.downloadImage(url: imageURL) { image in
                    guard let image = image else { return }
                    cell.flagImageView.image = image
                    cell.loadImageActivityIndicator.isHidden = true
                    cell.loadImageActivityIndicator.stopAnimating()
                }
                cell.loadImageActivityIndicator.isHidden = true
                cell.loadImageActivityIndicator.stopAnimating()
            }
        } else {
            cell.loadImageActivityIndicator.isHidden = true
            cell.loadImageActivityIndicator.stopAnimating()
        }

        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "countryDetailSegue" {
            if let indexPath = countryTableView.indexPathForSelectedRow {
                let dvc = segue.destination as! CountryDetailViewController
                dvc.country = countries[indexPath.row]

                
            }
        }
    }
}


