//
//  RegistrationView.swift
//  TourMate
//
//  Created by Terence Ho on 10/3/22.
//

import SwiftUI

struct RegisterView: View {
    var body: some View {
        GeometryReader { geometry in
            VStack {
                Spacer()

                TitleView()

                Spacer()

                Text("Content")

                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
        }
    }
}

struct RegistrationView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterView()
    }
}
