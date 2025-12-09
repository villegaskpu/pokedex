//
//  DIContainer.swift
//  pokedex
//
//  Created by david villegas on 08/12/25.
//

@MainActor
class DIContainer {
    static let shared = DIContainer()
    private init() {}
    
    private lazy var remoteDataSource: PokemonRemoteDataSource = {
        PokemonAPIDataSource()
    }()
    
    private lazy var pokemonRepository: PokemonRepository = {
        PokemonRepositoryImpl(remoteDataSource: remoteDataSource)
    }()
    
    func makeGetPokemonListUseCase() -> GetPokemonListUseCase {
        GetPokemonListUseCaseImpl(repository: pokemonRepository)
    }
    
    func makePokemonListViewModel() -> PokemonListViewModel {
        PokemonListViewModel(getPokemonListUseCase: makeGetPokemonListUseCase())
    }
}
