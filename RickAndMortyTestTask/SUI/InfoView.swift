//
//  InfoView.swift
//  RickAndMortyTestTask
//
//  Created by Aleksey Kosov on 17.08.2023.
//

import SwiftUI

struct InfoView: View {

    let character: Character

    var body: some View {
            VStack {
                HStack {
                    Text("Species:")
                    Spacer()
                    Text(character.species)
                }

                HStack {
                    Text("Type:")
                    Spacer()
                    Text(!character.type.isEmpty ? character.type : "None")
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
    }
}
