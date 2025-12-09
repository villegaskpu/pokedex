//
//  PokemonRepositoryImpl.swift
//  pokedex
//
//  Created by david villegas on 08/12/25.
//

import Foundation
import Combine

class PokemonRepositoryImpl: PokemonRepository {
    private let remoteDataSource: PokemonRemoteDataSource
    
    init(remoteDataSource: PokemonRemoteDataSource) {
        self.remoteDataSource = remoteDataSource
    }
    
    func getPokemonList(limit: Int, offset: Int) async throws -> [Pokemon] {
        // 1. Obtenemos lista básica (solo nombres y URLs)
        let basicPokemons = try await remoteDataSource.fetchPokemonList(
            limit: limit,
            offset: offset
        )
        
        // 2. Para cada Pokémon básico, obtenemos detalles completos
        var pokemons: [Pokemon] = []
        for basicPokemon in basicPokemons {
            do {
                // Llamamos con el ID para obtener PokemonDTO completo
                let pokemonDTO = try await remoteDataSource.fetchPokemon(id: basicPokemon.id)
                // Ahora sí convertimos PokemonDTO -> Pokemon
                let pokemon = PokemonMapper.toDomain(dto: pokemonDTO)
                pokemons.append(pokemon)
            } catch {
                print("Error obteniendo \(basicPokemon.name): \(error)")
            }
        }
        return pokemons
    }
    
    func getPokemon(id: Int) async throws -> Pokemon {
        let dto = try await remoteDataSource.fetchPokemon(id: id)
        return PokemonMapper.toDomain(dto: dto)
    }
}
