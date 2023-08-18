//
//  LoadingView.swift
//  RickAndMortyTestTask
//
//  Created by Aleksey Kosov on 18.08.2023.
//

import SwiftUI

struct LoadingView: View {
    var body: some View {
        ZStack {
            Color(.gray)
                .ignoresSafeArea()
                .clipShape(RoundedRectangle(cornerRadius: 6))
                .opacity(0.6)
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle())
                .scaleEffect(2)
        }
        .frame(width: 110, height: 110)
    }
}
