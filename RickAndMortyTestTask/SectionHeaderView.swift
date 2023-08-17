//
//  SectionHeaderView.swift
//  RickAndMortyTestTask
//
//  Created by Aleksey Kosov on 18.08.2023.
//

import SwiftUI

struct SectionHeaderView: View {
    let text: String

    var body: some View {
        HStack {
            Text(text)
                .font(.headline)
                .foregroundColor(.white)
            Spacer()
        }
    }
}
