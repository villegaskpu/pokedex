//
//  GetPokemonDetailUseCase.swift
//  pokedex
//
//  Created by david villegas on 08/12/25.
//

protocol GetPokemonDetailUseCase {
    func execute(id: Int) async throws -> Pokemon
}

class GetPokemonDetailUseCaseImpl: GetPokemonDetailUseCase {
    private let repository: PokemonRepository
    
    init(repository: PokemonRepository) {
        self.repository = repository
    }
    
    func execute(id: Int) async throws -> Pokemon {
        return try await repository.getPokemon(id: id)
    }
}
