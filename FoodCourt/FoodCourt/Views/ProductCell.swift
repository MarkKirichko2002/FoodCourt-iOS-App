//
//  ProductCell.swift
//  FoodCourt
//
//  Created by Марк Киричко on 29.11.2024.
//

import SwiftUI
import SDWebImageSwiftUI

struct ProductCell: View {
    
    @Binding var product: Product
    
    var body: some View {
        HStack(spacing: 15) {
            WebImage(url: URL(string: product.photo.convertImage())!)
                .resizable()
                .frame(width: 80, height: 80)
            VStack(alignment: .leading, spacing: 15) {
                Text(product.name)
                    .fontWeight(.bold)
                Text(product.description)
                    .fontWeight(.bold)
                Text("\(product.price) ₽")
                    .tint(Color(UIColor.label))
                    .padding(5)
                    .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color(UIColor.label), lineWidth: 1))
            }
        }
    }
}

//#Preview {
//    ProductCell()
//}
