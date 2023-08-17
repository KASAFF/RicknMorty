//
//  DetailsView.swift
//  RickAndMortyTestTask
//
//  Created by Aleksey Kosov on 17.08.2023.
//

import SwiftUI

struct DetailsView: View {

    let character: Character

    var body: some View {
        VStack {
            VStack(alignment: .center) {
                Image(uiImage: UIImage(named: "rick")!)
                Text(character.name)
                    .foregroundColor(.white)
                switch character.status {
                case .alive: Text("Alive")
                        .foregroundColor(.green)
                case .dead: Text("Dead")
                        .foregroundColor(.red)
                case .unknown: Text("Unknown")
                        .foregroundColor(.gray)
                }
            }

            VStack {
                HStack {
                    Text("Species:")
                    Spacer()
                    Text(character.species)
                }

                HStack {
                    Text("Type:")
                    Spacer()
                    Text(!character.type.isEmpty ? character.type : "Unknown")
                }
                .padding(.vertical)

                HStack {
                    Text("Gender: ")
                    Spacer()
                    Text(character.gender)
                }
            }
            .foregroundColor(.white)
            .padding()
            .background(Color(red: 0.15, green: 0.16, blue: 0.22))
            .clipShape(RoundedRectangle(cornerRadius: 16))
        }
        .padding()
    }
}

