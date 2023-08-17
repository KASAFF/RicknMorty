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
            Section {
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
                .padding()
                .foregroundColor(.white)
                .background(Color(red: 0.15, green: 0.16, blue: 0.22))
                .clipShape(RoundedRectangle(cornerRadius: 16))
            } header: {
                HStack {
                    Text("Info")
                        .font(.headline)
                        .foregroundColor(.white)
                    Spacer()
                }
            }

            Section {
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
            } header: {
                HStack {
                    Text("Origin")
                        .font(.headline)
                        .foregroundColor(.white)
                    Spacer()
                }
            }
            
        }
        .padding()
    }
}

