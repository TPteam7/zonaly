//
//  LocationCard.swift
//  zonaly
//
//  Created by Trevor Pope on 3/22/25.
//

import SwiftUI

struct LocationCard: View {
    var name: String
    var onDelete: () -> Void
    var onEdit: () -> Void

    var body: some View {
        VStack {
            HStack(alignment: .top) {
                Text(name)
                    .foregroundColor(.white)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity, alignment: .topLeading)

                Spacer()

                Menu {
                    Button("Edit") {
                        onEdit()
                    }
                    Button("Delete", role: .destructive) {
                        onDelete()
                    }
                } label: {
                    Image(systemName: "ellipsis")
                        .resizable()
                        .frame(width: 20, height: 5)
                        .padding(.all, 10)
                }
                .foregroundColor(.white)
                .contentShape(Rectangle())
            }
            Spacer()
        }
        .padding()
        .frame(height: 120)
        .background(Color.mediumBlue)
        .cornerRadius(15)
    }
}
