//
//  CatView.swift
//  network-image
//
//  Created by Sahas Punchihewa on 2024-10-25.
//

import SwiftUI

struct CatView: View {
    var cat: Cat
    
    var body: some View {
        VStack (alignment: .center) {
            
            Text("\(cat.name)")
                .font(.largeTitle)
                .padding()
            
            AsyncImage(url: URL(string: "https://cdn2.thecatapi.com/images/\(cat.referenceImageID ?? "").jpg")) { parse in
                if let image = parse.image {
                    image.resizable()
                        .scaledToFill()
                } else if (parse.error != nil) {
                    ProgressView()
                        .scaleEffect(2.0)
                } else {
                    Image(systemName: "cat.fill")
                        .frame(width: 256, height: 256)
                        .clipShape(.rect(cornerRadius: 10))
                }
            }
            .frame(width: 256, height: 256)
            .clipShape(.rect(cornerRadius: 10))
            
            VStack(alignment: .leading) {
                
                Text("Origin: \(cat.origin)")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                Text("Life Span: \(cat.lifeSpan)")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                Text("Weight: \(cat.weight.metric)")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            .padding(.top)
            .padding(.horizontal)
            
            Text("\(cat.description)")
                .padding()
                .font(.subheadline)
            
            Text("Temperament: \(cat.temperament)")
                .font(.footnote)
                .foregroundStyle(.blue)
            
            
        }
    }
}
