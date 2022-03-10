//
//  TitleView.swift
//  TourMate
//
//  Created by Terence Ho on 10/3/22.
//

import SwiftUI

struct TitleView: View {
    let titleFontSize = 64.0  // TODO: Consider a more dynamic way for font size
    let colorPrimary = Color.blue
    let colorSecondary = Color.teal

    var body: some View {
        VStack {
            // TourMate Title
            HStack(spacing: 0.0) {
                Text("Tour")
                    .font(.system(size: titleFontSize))
                    .foregroundColor(colorPrimary)

                Text("Mate")
                    .font(.system(size: titleFontSize))
                    .foregroundColor(colorSecondary)
            }
            .padding()

            // Tagline
            Text("Planning your next trip has never been easier")
                .foregroundColor(colorPrimary)
        }
        .padding()
    }
}

struct TitleView_Previews: PreviewProvider {
    static var previews: some View {
        TitleView()
    }
}
