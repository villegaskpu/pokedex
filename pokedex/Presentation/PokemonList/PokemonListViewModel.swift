//
//  PokemonListViewModel.swift
//  pokedex
//
//  Created by david villegas on 08/12/25.
//

import Combine

@MainActor
class PokemonListViewModel: ObservableObject {
    @Published var pokemons: [Pokemon] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let getPokemonListUseCase: GetPokemonListUseCase
    
    init(getPokemonListUseCase: GetPokemonListUseCase) {
        self.getPokemonListUseCase = getPokemonListUseCase
    }
    
    func loadPokemons() async {
        isLoading = true
        errorMessage = nil
        
        do {
            pokemons = try await getPokemonListUseCase.execute(limit: 20, offset: 0)
        } catch {
            errorMessage = "Error: \(error.localizedDescription)"
        }
        
        isLoading = false
    }
}
