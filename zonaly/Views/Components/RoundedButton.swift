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
            Text(title)
                .fontWeight(.bold)
                .foregroundColor(.black)
                .padding(.vertical, 14)
                .frame(maxWidth: .infinity)
                .background(color)
                .cornerRadius(15)
        }
    }
}
