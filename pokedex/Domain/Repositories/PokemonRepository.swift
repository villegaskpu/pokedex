//
//  PokemonRepository.swift
//  pokedex
//
//  Created by david villegas on 08/12/25.
//

// Repository Protocol
protocol PokemonRepository {
    func getPokemonList(limit: Int, offset: Int) async throws -> [Pokemon]
    func getPokemon(id: Int) async throws -> Pokemon
}
