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
                    .cornerRadius(10)
                    .foregroundColor(.black)
                Image("planet")
                    .foregroundColor(.white)
            }
            VStack(alignment: .leading, spacing: 8) {
                Text(character.origin.name)
                Text("Planet")
                    .foregroundColor(CustomColor.textGreen)
            }
            .foregroundColor(.white)
            
            Spacer()
        }
        .padding()
        .background(CustomColor.cellBackgroundColor)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}
