//
//  ContentView.swift
//  network-image
//
//  Created by Sahas Punchihewa on 2024-10-25.
//

import SwiftUI

struct Cat: Codable, Hashable {
    let weight: Weight
    let id, name: String
    let cfaURL: String?
    let vetstreetURL: String?
    let vcahospitalsURL: String?
    let temperament, origin, countryCodes, countryCode: String
    let description, lifeSpan: String
    let indoor: Int
    let lap: Int?
    let altNames: String?
    let adaptability, affectionLevel, childFriendly, dogFriendly: Int
    let energyLevel, grooming, healthIssues, intelligence: Int
    let sheddingLevel, socialNeeds, strangerFriendly, vocalisation: Int
    let experimental, hairless, natural, rare: Int
    let rex, suppressedTail, shortLegs: Int
    let wikipediaURL: String?
    let hypoallergenic: Int
    let referenceImageID: String?
    let catFriendly, bidability: Int?

    enum CodingKeys: String, CodingKey {
        case weight, id, name
        case cfaURL = "cfa_url"
        case vetstreetURL = "vetstreet_url"
        case vcahospitalsURL = "vcahospitals_url"
        case temperament, origin
        case countryCodes = "country_codes"
        case countryCode = "country_code"
        case description
        case lifeSpan = "life_span"
        case indoor, lap
        case altNames = "alt_names"
        case adaptability
        case affectionLevel = "affection_level"
        case childFriendly = "child_friendly"
        case dogFriendly = "dog_friendly"
        case energyLevel = "energy_level"
        case grooming
        case healthIssues = "health_issues"
        case intelligence
        case sheddingLevel = "shedding_level"
        case socialNeeds = "social_needs"
        case strangerFriendly = "stranger_friendly"
        case vocalisation, experimental, hairless, natural, rare, rex
        case suppressedTail = "suppressed_tail"
        case shortLegs = "short_legs"
        case wikipediaURL = "wikipedia_url"
        case hypoallergenic
        case referenceImageID = "reference_image_id"
        case catFriendly = "cat_friendly"
        case bidability
    }
}

struct Weight: Codable, Hashable {
    let imperial, metric: String
}

class PostViewModel: ObservableObject {
    @Published private(set) var cats: [Cat] = []
    @Published private(set) var isLoading: Bool = false
    
    func fetchCats() async {
        isLoading = true
        let url = URL(string: "https://api.thecatapi.com/v1/breeds")
        
        guard let unwrappedURL = url else {
            print("Invalid URL")
            return
        }
        
        do {
            let (fetchData, response) = try await URLSession.shared.data(from: unwrappedURL)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                print("Invalid Response")
                return
            }
            
            switch httpResponse.statusCode {
            case 200...300:
                print(fetchData)
                let decodedData = try JSONDecoder().decode([Cat].self, from: fetchData)
                
                
                cats = decodedData
                
                isLoading = false
                
            case 400...500:
                print("Server is not responding")
            default:
                print("Something went wrong")
            }
        } catch {
            print("Something went wrong: \(error.localizedDescription)")
        }
    }
}

struct ContentView: View {
    @StateObject var viewModel = PostViewModel()
    
    var body: some View {
        VStack(alignment: .center) {
            if viewModel.isLoading {
                ProgressView()
                    .scaleEffect(2.0)
            } else {
                NavigationStack {
                    List(viewModel.cats, id: \.id) { cat in
                        NavigationLink {
                            CatView(cat: cat)
                        } label: {
                            HStack(alignment: .center) {
                                AsyncImage(url: URL(string: "https://cdn2.thecatapi.com/images/\(cat.referenceImageID ?? "").jpg")) { parse in
                                    if let image = parse.image {
                                        image.resizable()
                                            .scaledToFill()
                                    } else if (parse.error != nil) {
                                        ProgressView()
                                            .scaleEffect(2.0)
                                    } else {
                                        Image(systemName: "cat.fill")
                                            .frame(width: 75, height: 75)
                                            .clipShape(.rect(cornerRadius: 10))
                                    }
                                }
                                .frame(width: 75, height: 75)
                                .clipShape(.rect(cornerRadius: 5))
                                .padding(.trailing)
                                
                                VStack (alignment: .leading) {
                                    Text("\(cat.name)")
                                        .font(.title2)
                                    
                                    Text("\(cat.origin)")
                                        .font(.subheadline)
                                        .foregroundColor(.secondary)
                                }
                                
                            }
                        }
                        
                    }
                }
            }
        }
        .padding()
        .onAppear {
            Task {
                await viewModel.fetchCats()
            }
        }
    }
}

#Preview {
    ContentView()
}
