//
//  Pokemon.swift
//  pokedex
//
//  Created by david villegas on 08/12/25.
//

import Foundation

struct Pokemon: Identifiable {
    let id: Int
    let name: String
    let imageURL: String
    let types: [String]
    let height: Int
    let weight: Int
    let stats: [PokemonStat]
    
    var heightInMeters: String {
        String(format: "%.1f m", Double(height) / 10.0)
    }
}

struct PokemonStat: Identifiable {
    let id = UUID()
    let name: String
    let value: Int
}
