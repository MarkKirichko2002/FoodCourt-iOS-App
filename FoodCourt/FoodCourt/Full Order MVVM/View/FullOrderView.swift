//
//  FullOrderView.swift
//  FoodCourt
//
//  Created by Марк Киричко on 01.12.2024.
//

import SwiftUI
import SDWebImageSwiftUI

struct FullOrderView: View {
    
    var order: OrderModel
    @ObservedObject var viewModel = FullOrderViewModel()
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            if viewModel.isLoading {
                ProgressView()
                    .scaleEffect(1.5, anchor: .center)
            } else {
                VStack(alignment: .leading) {
                    VStack(alignment: .leading) {
                        ForEach(order.order.products ?? [], id: \.productID) { product in
                            HStack(spacing: 15) {
                                WebImage(url: URL(string: viewModel.getProduct(by: product.productID).photo))
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 50, height: 50)
                                Text("\(product.count) * \(viewModel.getProduct(by: product.productID).name) (\(viewModel.getProduct(by: product.productID).price)) = \(viewModel.getSum(price: viewModel.getProduct(by: product.productID).price, count: product.count)) ₽")
                                    .fontWeight(.bold)
                            }
                        }
                    }
                    
                    .padding(15)
                    
                    VStack(alignment: .leading, spacing: 15) {
                        Text(viewModel.address)
                            .fontWeight(.bold)
                        if order.order.preferredTime != nil {
                            Text(viewModel.convertPreferedTime(order: order.order))
                                .fontWeight(.bold)
                        }
                        Text(viewModel.getStatus(by: order.status.statusId).statusName)
                            .fontWeight(.bold)
                        Text(viewModel.convertPrice(order: order))
                            .fontWeight(.bold)
                    } .padding(15)
                    
                    Spacer()
                    
                }.onAppear {
                    viewModel.getLocationAddress(order: order.order)
                }.navigationTitle("Заказ № \(order.order.id ?? 0)")
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar {
                        ToolbarItem(placement: .topBarTrailing) {
                            Button(action: {
                                dismiss()
                            }) {
                                Image("cross")
                            }
                        }
                  }
            }
        }
    }
}

//#Preview {
//    FullOrderView()
//}
