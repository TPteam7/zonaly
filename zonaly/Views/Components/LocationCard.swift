//
//  LocationCard.swift
//  zonaly
//
//  Created by Trevor Pope on 3/22/25.
//

import SwiftUICore

struct LocationCard: View {
    var name: String
    
    var body: some View {
        HStack {
            Text(name)
                .foregroundColor(.white)
                .font(.subheadline)
            Spacer()
            Image(systemName: "ellipsis")
                .foregroundColor(.white)
        }
        .padding()
        .background(Color.mediumBlue)
        .cornerRadius(15)
    }
}
