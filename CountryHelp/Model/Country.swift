//
//  Country.swift
//  CountryHelp
//
//  Created by Dennis Zubkoff on 25/06/2018.
//  Copyright © 2018 Dennis Zubkoff. All rights reserved.
//

import Foundation

struct Country: Codable{
    let continent: String?
    let capital: String?
    let languages: String?
    let geonameId: Int?
    let south: Double?
    let isoAlpha3: String?
    let north: Double?
    let fipsCode: String?
    let population: String?
    let east: Double?
    let isoNumeric: String?
    let areaInSqKm: String?
    let countryCode: String?
    let west: Double?
    let countryName: String?
    let continentName: String?
    let currencyCode: String?
}
