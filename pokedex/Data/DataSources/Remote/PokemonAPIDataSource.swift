//
//  PokemonAPIDataSource.swift
//  pokedex
//
//  Created by david villegas on 08/12/25.
//
import Foundation

protocol PokemonRemoteDataSource {
    func fetchPokemonList(limit: Int, offset: Int) async throws -> [PokemonBasicDTO]
    func fetchPokemon(id: Int) async throws -> PokemonDTO
}

class PokemonAPIDataSource: PokemonRemoteDataSource {
    private let baseURL = "https://pokeapi.co/api/v2"

    func fetchPokemon(id: Int) async throws -> PokemonDTO {
            let urlString = "\(baseURL)/pokemon/\(id)"
            
            guard let url = URL(string: urlString) else {
                throw URLError(.badURL)
            }
            
            let (data, _) = try await URLSession.shared.data(from: url)
            
            let decoder = JSONDecoder()
            return try decoder.decode(PokemonDTO.self, from: data)
        }
    
    func fetchPokemonList(limit: Int, offset: Int) async throws -> [PokemonBasicDTO] {
        let url = URL(string: "https://pokeapi.co/api/v2/pokemon")!
        let (data, _) = try await URLSession.shared.data(from: url)
        let response = try JSONDecoder().decode(PokemonListResponseDTO.self, from: data)
        return response.results
    }
}
