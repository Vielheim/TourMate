//
//  TripCardView.swift
//  Tourmate
//
//  Created by Rayner Lim on 7/3/22.
//

import SwiftUI

struct TripCardView: View {
    let title: String
    let subtitle: String
    let imageUrl: String

    var body: some View {
        ZStack(alignment: .bottom) {
            AsyncImage(url: URL(string: imageUrl)) { image in
                image
                    .resizable()
                    .scaledToFill()
                    .frame(height: 200, alignment: .center)
                    .clipped()
            } placeholder: {
                Color.gray
            }

            HStack {
                VStack(alignment: .leading) {
                    Text(title)
                        .font(.headline)
                    Text(subtitle)
                        .font(.subheadline)
                }
                Spacer()
            }
            .padding()
            .foregroundColor(.primary)
            .background(Color.primary
                            .colorInvert()
                            .opacity(0.75))
        }
        .clipShape(
            RoundedRectangle(cornerRadius: 16)
        )
        .padding([.horizontal])
    }
}

struct TripCardView_Previews: PreviewProvider {
    static var previews: some View {
        let view = TripCardView(title: "West Coast Summer",
                                subtitle: "Sun, 1 May - Sat, 30 May",
                                imageUrl: "https://source.unsplash.com/qxstzQ__HMk")
        ForEach(ColorScheme.allCases, id: \.self, content: view.preferredColorScheme)
    }
}
