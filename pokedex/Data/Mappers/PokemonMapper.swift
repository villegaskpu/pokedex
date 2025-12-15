//
//  PokemonMapper.swift
//  pokedex
//
//  Created by david villegas on 08/12/25.
//


class PokemonMapper {
    //hola
    
    static func toDomain(dto: PokemonDTO) -> Pokemon {
        let imageURL = dto.sprites.other?.officialArtwork?.frontDefault
            ?? dto.sprites.frontDefault
            ?? ""
        //un cambio
        return Pokemon(
            id: dto.id,
            name: dto.name.capitalized,
            imageURL: imageURL,
            types: dto.types.map { $0.type.name.capitalized },
            height: dto.height,
            weight: dto.weight,
            stats: dto.stats.map {
                PokemonStat(name: $0.stat.name, value: $0.baseStat)
            }
        )
    }
}
