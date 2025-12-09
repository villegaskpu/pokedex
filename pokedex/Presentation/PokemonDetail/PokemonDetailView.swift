//
//  PokemonDetailView.swift
//  pokedex
//
//  Created by david villegas on 08/12/25.
//

import SwiftUI

struct PokemonDetailView: View {
    let pokemon: Pokemon
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                pokemonImageView
                pokemonInfoView
                pokemonMeasurementsView
                pokemonStatsView
            }
            .padding()
        }
        .navigationBarTitleDisplayMode(.inline)
    }
    
    // MARK: - Sub Views
    private var pokemonImageView: some View {
        AsyncImage(url: URL(string: pokemon.imageURL)) { phase in
            switch phase {
            case .empty:
                ProgressView()
                    .frame(height: 200)
            case .success(let image):
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 200)
            case .failure:
                Image(systemName: "photo")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 200)
                    .foregroundColor(.gray)
            @unknown default:
                EmptyView()
            }
        }
    }
    
    private var pokemonInfoView: some View {
        VStack(spacing: 8) {
            Text("#\(String(format: "%03d", pokemon.id))")
                .font(.title2)
                .foregroundColor(.gray)
            
            Text(pokemon.name)
                .font(.largeTitle)
                .fontWeight(.bold)
            
            pokemonTypesView
        }
    }
    
    private var pokemonTypesView: some View {
        HStack(spacing: 12) {
            ForEach(pokemon.types, id: \.self) { type in
                Text(type)
                    .font(.headline)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .background(typeColor(for: type).opacity(0.2))
                    .foregroundColor(typeColor(for: type))
                    .cornerRadius(12)
            }
        }
    }
    
    private var pokemonMeasurementsView: some View {
        HStack(spacing: 40) {
            VStack {
                Text(pokemon.heightInMeters)
                    .font(.title2)
                    .fontWeight(.bold)
                Text("Altura")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            
            VStack {
//                Text(pokemon.weightInKg)
                Text("10")
                    .font(.title2)
                    .fontWeight(.bold)
                Text("Peso")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
        }
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(12)
    }
    
    private var pokemonStatsView: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Estadísticas Base")
                .font(.title2)
                .fontWeight(.bold)
            
            ForEach(pokemon.stats) { stat in
                StatRowView(stat: stat)
            }
        }
        .padding()
        .background(Color.gray.opacity(0.05))
        .cornerRadius(12)
    }
    
    // MARK: - Helper Functions
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
        default: return .gray
        }
    }
}

// MARK: - StatRowView Component
struct StatRowView: View {
    let stat: PokemonStat
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
//                Text(stat.displayName)
                Text("displayName")
                    .font(.subheadline)
                    .frame(width: 100, alignment: .leading)
                
                Text("\(stat.value)")
                    .font(.subheadline)
                    .fontWeight(.bold)
                    .frame(width: 40, alignment: .trailing)
                
                statProgressBar
            }
        }
    }
    
    private var statProgressBar: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                Rectangle()
                    .fill(Color.gray.opacity(0.2))
                    .frame(height: 8)
                    .cornerRadius(4)
                
                Rectangle()
                    .fill(statColor)
                    .frame(width: progressWidth(geometry: geometry), height: 8)
                    .cornerRadius(4)
            }
        }
        .frame(height: 8)
    }
    
    private func progressWidth(geometry: GeometryProxy) -> CGFloat {
        CGFloat(stat.value) / 255 * geometry.size.width
    }
    
    private var statColor: Color {
        switch stat.value {
        case 0..<50: return .red
        case 50..<100: return .orange
        case 100..<150: return .yellow
        default: return .green
        }
    }
}
