//
//  RoundedButton.swift
//  zonaly
//
//  Created by Trevor Pope on 3/22/25.
//

//
//  RoundedButton.swift
//  zonaly
//
//  Created by Trevor Pope on 3/22/25.
//

import SwiftUI

struct RoundedButton: View {
    var title: String
    var color: Color
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(alignment: .leading) {
                Text(title)
                    .fontWeight(.bold)
                    .foregroundColor(.black)
                    .frame(maxWidth: .infinity, alignment: .topLeading)
                Spacer()
            }
            .padding()
            .frame(height: 80) // Adjust the height as needed
            .background(color)
            .cornerRadius(15)
        }
    }
}

