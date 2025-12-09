//
//  PokemonListView.swift
//  pokedex
//
//  Created by david villegas on 08/12/25.
//

import SwiftUI
import Combine
//probar plantilla
struct PokemonListView: View {
    @StateObject var viewModel: PokemonListViewModel
    
    var body: some View {
        NavigationView {
            ZStack {
                if viewModel.isLoading {
                    ProgressView("Cargando...")
                } else if let error = viewModel.errorMessage {
                    VStack {
                        Text("Error").font(.title)
                        Text(error)
                        Button("Reintentar") {
                            Task { await viewModel.loadPokemons() }
                        }
                    }
                } else {
                    List(viewModel.pokemons) { pokemon in
                        NavigationLink(destination: PokemonDetailView(pokemon: pokemon)) {
                            PokemonRowView(pokemon: pokemon)
                        }
                    }
                }
            }
            .navigationTitle("Pokédex")
            .task { await viewModel.loadPokemons() }
        }
    }
}
