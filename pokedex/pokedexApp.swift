//
//  pokedexApp.swift
//  pokedex
//
//  Created by david villegas on 08/12/25.
//

import SwiftUI

@main
struct pokedexApp: App {
    let container = DIContainer.shared

    var body: some Scene {
        WindowGroup {
            PokemonListView(viewModel: container.makePokemonListViewModel())
        }
    }
}
