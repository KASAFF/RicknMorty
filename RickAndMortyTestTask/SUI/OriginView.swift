//
//  OriginView.swift
//  RickAndMortyTestTask
//
//  Created by Aleksey Kosov on 17.08.2023.
//

import SwiftUI

struct OriginView: View {
    
    let character: Character
    
    var body: some View {
        HStack {
            ZStack {
                Rectangle()
                    .frame(width: 64, height: 64)
                    .background(Color(red: 0.1, green: 0.11, blue: 0.16))
                    .cornerRadius(10)
                
                Image("planet")
            }
            VStack(alignment: .leading, spacing: 8) {
                Text(character.origin.name)
                Text("Planet")
                    .foregroundColor(.green)
            }
            .foregroundColor(.white)
            
            Spacer()
        }
        .padding()
        .background(Color(red: 0.15, green: 0.16, blue: 0.22))
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}
