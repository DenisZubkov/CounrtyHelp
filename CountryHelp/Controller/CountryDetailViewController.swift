//
//  CountryDetailViewController.swift
//  CountryHelp
//
//  Created by Denis Zubkov on 26/06/2018.
//  Copyright © 2018 Dennis Zubkoff. All rights reserved.
//

import UIKit

class CountryDetailViewController: UIViewController {

    @IBOutlet weak var countryFlagImageView: UIImageView!
    @IBOutlet weak var detailTableView: UITableView!
    @IBOutlet weak var loadImageActivityIndicator: UIActivityIndicatorView!
    
    var country: Country?
    let dataProvider = DataProvider()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = country?.countryName
        detailTableView.tableFooterView = UIView()
        loadImageActivityIndicator.isHidden = false
        loadImageActivityIndicator.startAnimating()
        countryFlagImageView.image = UIImage(named: "blank")
        if let countryCode = country?.countryCode {
            let url = "http://www.geonames.org/flags/x/" + countryCode.lowercased() + ".gif"
            if let imageURL = URL(string: url) {
                self.dataProvider.downloadImage(url: imageURL) { image in
                    guard let image = image else { return }
                    self.countryFlagImageView.image = image
                    self.loadImageActivityIndicator.isHidden = true
                    self.loadImageActivityIndicator.stopAnimating()
                }
            }
        } else {
            countryFlagImageView.image = UIImage(named: "No-Photo")
            self.loadImageActivityIndicator.isHidden = true
            self.loadImageActivityIndicator.stopAnimating()
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

   
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension CountryDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! CountryDetailTableViewCell
        switch indexPath.row {
        case 0:
            cell.promptLabel.text = "Континент"
            cell.propertyLabel.text = self.country?.continentName
        case 1:
            cell.promptLabel.text = "Столица"
            cell.propertyLabel.text = self.country?.capital
        case 2:
            cell.promptLabel.text = "Площадь,\nкв.км"
            cell.propertyLabel.text = self.country?.areaInSqKm
        case 3:
            cell.promptLabel.text = "Население"
            cell.propertyLabel.text = self.country?.population
        case 4:
            cell.promptLabel.text = "Языки"
            cell.propertyLabel.text = self.country?.languages
        case 5:
            cell.promptLabel.text = "Код страны"
            cell.propertyLabel.text = self.country?.countryCode
        case 6:
            cell.promptLabel.text = "Код валюты"
            cell.propertyLabel.text = self.country?.currencyCode
        default:
            cell.promptLabel.text = "Не задано"
            cell.propertyLabel.text = "Не задано"
        }
        return cell
    }
    
    
}
