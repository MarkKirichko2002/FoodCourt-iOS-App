//
//  ClientOrderCell.swift
//  FoodCourt
//
//  Created by Марк Киричко on 30.11.2024.
//

import SwiftUI
import SDWebImageSwiftUI

struct ClientOrderCell: View {
    
    var order: OrderModel
    var viewModel: ClientOrdersListViewModel
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("№ \(order.order.id ?? 0)")
                    .fontWeight(.bold)
                HStack {
                    ForEach(order.order.products ?? [], id: \.productID) { product in
                        WebImage(url: URL(string: viewModel.getProduct(by: product.productID).photo))
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 30, height: 30)
                    }
                }
                
                Text(viewModel.convertDate(order: order.order))
                    .fontWeight(.bold)
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 15) {
                Text(viewModel.getStatus(by: order.status.statusId))
                    .fontWeight(.bold)
                Text("\(viewModel.getSum(by: order.order)) ₽")
                    .fontWeight(.bold)
            }
        }
    }
}

//#Preview {
//    ClientOrderCell()
//}
