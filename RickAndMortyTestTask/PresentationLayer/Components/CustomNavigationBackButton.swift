//
//  CustomNavigationBackButton.swift
//  RickAndMortyTestTask
//
//  Created by Aleksey Kosov on 18.08.2023.
//

import SwiftUI

struct CustomNavigationBackButton: View {

    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        Button {
            presentationMode.wrappedValue.dismiss()
        } label: {
            Image(systemName: "chevron.backward")
                .resizable()
                .bold()
                .scaledToFit()
                .frame(width: 10, height: 16)
                .foregroundColor(.white)
                .padding(.leading, 16)
        }
    }
}
