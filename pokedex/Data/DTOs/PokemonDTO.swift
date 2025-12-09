//
//  PokemonDTO.swift
//  pokedex
//
//  Created by david villegas on 08/12/25.
//

struct PokemonDTO: Codable {
    let id: Int
    let name: String
    let sprites: SpritesDTO
    let types: [TypeSlotDTO]
    let height: Int
    let weight: Int
    let stats: [StatDTO]
}

struct SpritesDTO: Codable {
    let frontDefault: String?
    let other: OtherSpritesDTO?
    
    enum CodingKeys: String, CodingKey {
        case frontDefault = "front_default"
        case other
    }
}

struct OtherSpritesDTO: Codable {
    let officialArtwork: OfficialArtworkDTO?
    
    enum CodingKeys: String, CodingKey {
        case officialArtwork = "official-artwork"
    }
}

struct OfficialArtworkDTO: Codable {
    let frontDefault: String?
    
    enum CodingKeys: String, CodingKey {
        case frontDefault = "front_default"
    }
}

struct TypeSlotDTO: Codable {
    let type: TypeDTO
}

struct TypeDTO: Codable {
    let name: String
}

struct StatDTO: Codable {
    let baseStat: Int
    let stat: StatNameDTO
    
    enum CodingKeys: String, CodingKey {
        case baseStat = "base_stat"
        case stat
    }
}

struct StatNameDTO: Codable {
    let name: String
}
