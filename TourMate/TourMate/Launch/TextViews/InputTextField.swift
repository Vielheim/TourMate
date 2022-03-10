//
//  InputTextField.swift
//  TourMate
//
//  Created by Terence Ho on 10/3/22.
//

import SwiftUI

struct InputTextField: View {
    var title: String
    @Binding var textField: String

    var body: some View {
        TextField(title, text: $textField)
            .padding()
            .background(.thinMaterial)
            .cornerRadius(10.0)
            .autocapitalization(.none)
            .disableAutocorrection(true)
            .keyboardType(.default)
    }
}

struct InputTextField_Previews: PreviewProvider {
    static var previews: some View {
        InputTextField(title: "Username", textField: LogInView().$email)
    }
}
