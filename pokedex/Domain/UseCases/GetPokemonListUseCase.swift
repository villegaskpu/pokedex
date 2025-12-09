//
//  GetPokemonListUseCase.swift
//  pokedex
//
//  Created by david villegas on 08/12/25.
//

protocol GetPokemonListUseCase {
    func execute(limit: Int, offset: Int) async throws -> [Pokemon]
}

class GetPokemonListUseCaseImpl: GetPokemonListUseCase {
    private let repository: PokemonRepository
    
    init(repository: PokemonRepository) {
        self.repository = repository
    }
    
    func execute(limit: Int, offset: Int) async throws -> [Pokemon] {
        return try await repository.getPokemonList(limit: limit, offset: offset)
    }
}
