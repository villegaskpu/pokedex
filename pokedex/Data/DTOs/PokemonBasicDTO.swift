//
//  PokemonBasicDTO.swift
//  pokedex
//
//  Created by david villegas on 08/12/25.
//

import Foundation

struct PokemonListResponseDTO: Codable {
    let results: [PokemonBasicDTO]
}

struct PokemonBasicDTO: Codable {
    let name: String
    let url: String
    
    var id: Int {
        let components = url.split(separator: "/")
        return Int(components[components.count - 1]) ?? 0
    }
}
