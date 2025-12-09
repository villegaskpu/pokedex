//
//  PokemonRowView.swift
//  pokedex
//
//  Created by david villegas on 08/12/25.
//

import SwiftUI

struct PokemonRowView: View {
    let pokemon: Pokemon
    
    var body: some View {
        HStack(spacing: 16) {
            // Imagen del Pokémon
            AsyncImage(url: URL(string: pokemon.imageURL)) { phase in
                switch phase {
                case .empty:
                    ProgressView()
                        .frame(width: 60, height: 60)
                case .success(let image):
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 60, height: 60)
                case .failure:
                    Image(systemName: "photo")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 60, height: 60)
                        .foregroundColor(.gray)
                @unknown default:
                    EmptyView()
                }
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text("#\(String(format: "%03d", pokemon.id))")
                    .font(.caption)
                    .foregroundColor(.gray)
                
                Text(pokemon.name)
                    .font(.headline)
                
                HStack(spacing: 8) {
                    ForEach(pokemon.types, id: \.self) { type in
                        Text(type)
                            .font(.caption)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(typeColor(for: type).opacity(0.2))
                            .foregroundColor(typeColor(for: type))
                            .cornerRadius(8)
                    }
                }
            }
            
            Spacer()
        }
        .padding(.vertical, 8)
    }
    
    func typeColor(for type: String) -> Color {
        switch type.lowercased() {
        case "fire": return .red
        case "water": return .blue
        case "grass": return .green
        case "electric": return .yellow
        case "psychic": return .purple
        case "ice": return .cyan
        case "dragon": return .indigo
        case "dark": return .black
        case "fairy": return .pink
        case "normal": return .gray
        case "fighting": return .orange
        case "flying": return .teal
        case "poison": return .purple
        case "ground": return .brown
        case "rock": return .brown
        case "bug": return .green
        case "ghost": return .purple
        case "steel": return .gray
        default: return .gray
        }
    }
}
