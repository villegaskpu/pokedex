# 📱 Pokédex iOS - Clean Architecture + MVVM

Una aplicación de Pokédex para iOS construida con **SwiftUI**, siguiendo los principios de **Clean Architecture** y el patrón **MVVM** (Model-View-ViewModel).

<p align="center">
  <img src="https://img.shields.io/badge/Swift-5.9-orange.svg" />
  <img src="https://img.shields.io/badge/iOS-16.0+-blue.svg" />
  <img src="https://img.shields.io/badge/SwiftUI-Latest-green.svg" />
  <img src="https://img.shields.io/badge/Architecture-Clean%20Architecture-yellow.svg" />
  <img src="https://img.shields.io/badge/Pattern-MVVM-red.svg" />
</p>

## 📋 Tabla de Contenidos

- [Características](#-características)
- [Arquitectura](#-arquitectura)
- [Estructura del Proyecto](#-estructura-del-proyecto)
- [Capas de la Aplicación](#-capas-de-la-aplicación)
- [Instalación](#-instalación)
- [Uso](#-uso)
- [Tecnologías](#-tecnologías)
- [API](#-api)
- [Flujo de Datos](#-flujo-de-datos)
- [Testing](#-testing)
- [Contribuir](#-contribuir)
- [Licencia](#-licencia)

## ✨ Características

- ✅ Listado de Pokémon con scroll infinito
- ✅ Búsqueda de Pokémon por nombre o número
- ✅ Vista detallada con estadísticas
- ✅ Tipos de Pokémon con colores
- ✅ Información de altura y peso
- ✅ Estadísticas base con barras de progreso
- ✅ Carga asíncrona de imágenes
- ✅ Manejo de errores
- ✅ Estados de carga

## 🏗️ Arquitectura

Este proyecto implementa **Clean Architecture** con el patrón **MVVM**, dividiendo la aplicación en tres capas principales:

```
┌─────────────────────────────────────────┐
│       Presentation Layer (MVVM)         │
│  Views + ViewModels + UI Components     │
└─────────────────┬───────────────────────┘
                  │
                  ▼
┌─────────────────────────────────────────┐
│          Domain Layer (Core)            │
│   Entities + Use Cases + Protocols      │
└─────────────────┬───────────────────────┘
                  │
                  ▼
┌─────────────────────────────────────────┐
│           Data Layer (API)              │
│  DTOs + DataSources + Repositories      │
└─────────────────────────────────────────┘
```

### Principios Aplicados

- **Separación de responsabilidades**: Cada capa tiene una función específica
- **Regla de dependencia**: Las dependencias apuntan hacia adentro (Domain es independiente)
- **Inversión de dependencias**: Domain define interfaces, Data las implementa
- **Single Responsibility**: Cada clase tiene una única razón para cambiar
- **Testeable**: Cada capa puede ser testeada independientemente

## 📁 Estructura del Proyecto

```
Pokedex/
├── App/
│   ├── PokedexApp.swift              # Punto de entrada
│   └── DIContainer.swift             # Inyección de dependencias
│
├── Data/                             # 🔵 DATA LAYER
│   ├── DataSources/
│   │   └── Remote/
│   │       └── PokemonAPIDataSource.swift
│   ├── DTOs/
│   │   └── PokemonDTO.swift          # Modelos JSON
│   ├── Mappers/
│   │   └── PokemonMapper.swift       # DTO → Entity
│   └── Repositories/
│       └── PokemonRepositoryImpl.swift
│
├── Domain/                           # 🟢 DOMAIN LAYER
│   ├── Entities/
│   │   └── Pokemon.swift             # Modelos de negocio
│   ├── Repositories/
│   │   └── PokemonRepository.swift   # Protocols
│   └── UseCases/
│       ├── GetPokemonListUseCase.swift
│       └── GetPokemonDetailUseCase.swift
│
└── Presentation/                     # 🟣 PRESENTATION LAYER
    ├── PokemonList/
    │   ├── PokemonListView.swift
    │   ├── PokemonListViewModel.swift
    │   └── Components/
    │       └── PokemonRowView.swift
    └── PokemonDetail/
        └── PokemonDetailView.swift
```

## 🎯 Capas de la Aplicación

### 🟢 Domain Layer (Núcleo de la Aplicación)

**Responsabilidad**: Contiene la lógica de negocio pura, independiente de frameworks.

**Componentes**:
- **Entities**: Modelos de negocio (`Pokemon`, `PokemonStat`)
- **Repository Protocols**: Contratos que define el Domain
- **Use Cases**: Casos de uso específicos de la aplicación

**Características**:
- ✅ NO depende de ninguna otra capa
- ✅ Contiene solo lógica de negocio
- ✅ No conoce SwiftUI, UIKit, ni APIs

**Ejemplo**:
```swift
struct Pokemon: Identifiable, Equatable {
    let id: Int
    let name: String
    let imageURL: String
    let types: [String]
    let height: Int
    let weight: Int
    let stats: [PokemonStat]
}

protocol PokemonRepository {
    func getPokemonList(limit: Int, offset: Int) async throws -> [Pokemon]
    func getPokemon(id: Int) async throws -> Pokemon
}
```

### 🔵 Data Layer (Manejo de Datos)

**Responsabilidad**: Obtiene y almacena datos desde fuentes externas (API, Base de datos).

**Componentes**:
- **DTOs**: Data Transfer Objects para parsear JSON
- **DataSources**: Remote (API) y Local (Cache/DB)
- **Mappers**: Convierte DTOs en Entities
- **Repository Implementation**: Implementa los protocolos del Domain

**Características**:
- ✅ Depende del Domain (implementa sus protocolos)
- ✅ Maneja detalles de implementación (URLs, JSON, etc.)
- ✅ Responsable de la persistencia y networking

**Ejemplo**:
```swift
class PokemonAPIDataSource: PokemonRemoteDataSource {
    func fetchPokemon(id: Int) async throws -> PokemonDTO {
        let url = URL(string: "https://pokeapi.co/api/v2/pokemon/\(id)")!
        let (data, _) = try await URLSession.shared.data(from: url)
        return try JSONDecoder().decode(PokemonDTO.self, from: data)
    }
}

class PokemonMapper {
    static func toDomain(dto: PokemonDTO) -> Pokemon {
        // Convierte PokemonDTO → Pokemon
    }
}
```

### 🟣 Presentation Layer (UI + MVVM)

**Responsabilidad**: Muestra información al usuario y captura sus interacciones.

**Componentes**:
- **Views (SwiftUI)**: Interfaz de usuario
- **ViewModels**: Lógica de presentación y estado
- **Components**: Componentes reutilizables de UI

**Características**:
- ✅ Depende del Domain (usa Use Cases)
- ✅ Implementa patrón MVVM
- ✅ ViewModels con `@Published` para reactividad
- ✅ Views observan cambios del ViewModel

**Ejemplo**:
```swift
@MainActor
class PokemonListViewModel: ObservableObject {
    @Published var pokemons: [Pokemon] = []
    @Published var isLoading = false
    
    private let getPokemonListUseCase: GetPokemonListUseCase
    
    func loadPokemons() async {
        isLoading = true
        pokemons = try await getPokemonListUseCase.execute(limit: 20, offset: 0)
        isLoading = false
    }
}
```

## 🚀 Instalación

### Requisitos

- Xcode 15.0+
- iOS 16.0+
- Swift 5.9+

### Pasos

1. **Clonar el repositorio**
```bash
git clone https://github.com/tu-usuario/pokedex-ios.git
cd pokedex-ios
```

2. **Abrir el proyecto en Xcode**
```bash
open Pokedex.xcodeproj
```

3. **Compilar y ejecutar**
- Selecciona un simulador o dispositivo
- Presiona `Cmd + R` o haz clic en el botón Run

¡No se requieren dependencias externas! Todo usa frameworks nativos de iOS.

## 💻 Uso

### Navegación Básica

1. **Lista de Pokémon**: Al abrir la app, verás una lista con los primeros 20 Pokémon
2. **Scroll Infinito**: Al hacer scroll hacia abajo, se cargarán más Pokémon automáticamente
3. **Búsqueda**: Usa la barra de búsqueda para filtrar por nombre o número
4. **Detalle**: Toca cualquier Pokémon para ver sus estadísticas completas

### Búsqueda de Pokémon

```swift
// Buscar por nombre
"Pikachu"

// Buscar por número
"25"

// Búsqueda parcial
"Char" // Encuentra Charmander, Charmeleon, Charizard
```

## 🛠️ Tecnologías

### Frameworks y Herramientas

- **SwiftUI**: Framework de UI declarativo
- **Async/Await**: Para operaciones asíncronas
- **Combine**: `@Published` para reactividad
- **URLSession**: Networking nativo
- **Codable**: Parseo de JSON

### Patrones de Diseño

- **Clean Architecture**: Separación en capas
- **MVVM**: Model-View-ViewModel
- **Repository Pattern**: Abstracción de fuentes de datos
- **Use Case Pattern**: Casos de uso específicos
- **Dependency Injection**: DIContainer

## 🌐 API

Este proyecto consume la [PokéAPI](https://pokeapi.co/), una API RESTful gratuita con información de Pokémon.

### Endpoints Utilizados

```
GET https://pokeapi.co/api/v2/pokemon?limit=20&offset=0
GET https://pokeapi.co/api/v2/pokemon/{id}
```

### Ejemplo de Respuesta

```json
{
  "id": 25,
  "name": "pikachu",
  "height": 4,
  "weight": 60,
  "types": [
    {
      "type": {
        "name": "electric"
      }
    }
  ],
  "stats": [
    {
      "base_stat": 35,
      "stat": {
        "name": "hp"
      }
    }
  ]
}
```

## 🔄 Flujo de Datos

```
┌──────────────────────────────────────────────────────────┐
│ 1. Usuario toca un botón en la View                     │
└───────────────────────┬──────────────────────────────────┘
                        │
                        ▼
┌──────────────────────────────────────────────────────────┐
│ 2. View llama un método del ViewModel                   │
│    viewModel.loadPokemons()                              │
└───────────────────────┬──────────────────────────────────┘
                        │
                        ▼
┌──────────────────────────────────────────────────────────┐
│ 3. ViewModel llama al Use Case                          │
│    getPokemonListUseCase.execute()                       │
└───────────────────────┬──────────────────────────────────┘
                        │
                        ▼
┌──────────────────────────────────────────────────────────┐
│ 4. Use Case llama al Repository (protocolo)             │
│    repository.getPokemonList()                           │
└───────────────────────┬──────────────────────────────────┘
                        │
                        ▼
┌──────────────────────────────────────────────────────────┐
│ 5. Repository Implementation llama al DataSource         │
│    remoteDataSource.fetchPokemonList()                   │
└───────────────────────┬──────────────────────────────────┘
                        │
                        ▼
┌──────────────────────────────────────────────────────────┐
│ 6. DataSource hace petición HTTP a PokéAPI              │
│    URLSession.shared.data(from: url)                     │
└───────────────────────┬──────────────────────────────────┘
                        │
                        ▼
┌──────────────────────────────────────────────────────────┐
│ 7. DataSource retorna PokemonDTO (JSON parseado)        │
└───────────────────────┬──────────────────────────────────┘
                        │
                        ▼
┌──────────────────────────────────────────────────────────┐
│ 8. Mapper convierte DTO → Entity                        │
│    PokemonMapper.toDomain(dto: pokemonDTO)               │
└───────────────────────┬──────────────────────────────────┘
                        │
                        ▼
┌──────────────────────────────────────────────────────────┐
│ 9. Entity (Pokemon) viaja de regreso por todas las capas│
└───────────────────────┬──────────────────────────────────┘
                        │
                        ▼
┌──────────────────────────────────────────────────────────┐
│ 10. ViewModel actualiza @Published var pokemons         │
└───────────────────────┬──────────────────────────────────┘
                        │
                        ▼
┌──────────────────────────────────────────────────────────┐
│ 11. View se redibuja automáticamente (SwiftUI)          │
└──────────────────────────────────────────────────────────┘
```

## 🧪 Testing

### Estructura de Tests

```
PokedexTests/
├── DomainTests/
│   └── UseCases/
│       └── GetPokemonListUseCaseTests.swift
├── DataTests/
│   └── Repositories/
│       └── PokemonRepositoryImplTests.swift
└── PresentationTests/
    └── ViewModels/
        └── PokemonListViewModelTests.swift
```

### Ejemplo de Test

```swift
class GetPokemonListUseCaseTests: XCTestCase {
    func testExecuteReturnsPokemons() async throws {
        // Given
        let mockRepository = MockPokemonRepository()
        let useCase = GetPokemonListUseCaseImpl(repository: mockRepository)
        
        // When
        let pokemons = try await useCase.execute(limit: 10, offset: 0)
        
        // Then
        XCTAssertEqual(pokemons.count, 10)
    }
}
```

### Ejecutar Tests

```bash
# En Xcode
Cmd + U

# Desde terminal
xcodebuild test -scheme Pokedex -destination 'platform=iOS Simulator,name=iPhone 15'
```

## 📝 Ventajas de esta Arquitectura

### ✅ Testeable
- Cada capa se puede testear de forma aislada
- Fácil crear mocks de Repository, DataSource, etc.
- Use Cases son funciones puras fáciles de testear

### ✅ Mantenible
- Cambios en la API no afectan la lógica de negocio
- Cambios en la UI no afectan el Domain
- Código organizado y fácil de entender

### ✅ Escalable
- Fácil agregar nuevas features siguiendo el mismo patrón
- Agregar nuevas fuentes de datos (Firebase, CoreData)
- Implementar caché sin tocar el Domain

### ✅ Reusable
- Use Cases se pueden reutilizar en diferentes vistas
- Entities son independientes de la UI
- Repository puede cambiar de implementación sin afectar Use Cases

### ✅ Independiente de Frameworks
- Domain no depende de SwiftUI, UIKit, ni URLSession
- Fácil migrar a otras tecnologías
- Lógica de negocio protegida de cambios externos

## 🤝 Contribuir

¡Las contribuciones son bienvenidas! Si quieres mejorar este proyecto:

1. **Fork** el repositorio
2. Crea una **rama** para tu feature (`git checkout -b feature/amazing-feature`)
3. **Commit** tus cambios (`git commit -m 'Add some amazing feature'`)
4. **Push** a la rama (`git push origin feature/amazing-feature`)
5. Abre un **Pull Request**

### Guías de Contribución

- Sigue los principios de Clean Architecture
- Mantén el patrón MVVM en Presentation
- Agrega tests para nuevas features
- Documenta funciones complejas
- Usa nombres descriptivos en variables y funciones

## 📄 Licencia

Este proyecto está bajo la Licencia MIT. Ver el archivo [LICENSE](LICENSE) para más detalles.

```
MIT License

Copyright (c) 2024

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction...
```

## 🙏 Agradecimientos

- [PokéAPI](https://pokeapi.co/) por proporcionar la API gratuita
- Comunidad de Swift y SwiftUI
- Uncle Bob por Clean Architecture
- Todos los contribuidores del proyecto

---

⭐️ Si te gusta este proyecto, ¡dale una estrella en GitHub!

**Hecho con ❤️ y SwiftUI
