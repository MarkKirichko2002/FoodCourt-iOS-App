//
//  CookOrderCell.swift
//  FoodCourt
//
//  Created by Марк Киричко on 30.11.2024.
//

import SwiftUI
import SDWebImageSwiftUI

struct CookOrderCell: View {
    
    @State var currentStatus = StatusModel(statusId: 1, statusName: "Новый")
    @State var address = "..."
    @State var isChanged = false
    
    var order: OrderModel
    var viewModel: CookOrdersListViewModel
    var statuses = [StatusModel]()
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                HStack {
                    Text("№ \(order.order.id ?? 0)")
                        .fontWeight(.bold)
                    Spacer()
                    Text(viewModel.getStatus(by: order.status.statusId).statusName)
                        .fontWeight(.bold)
                }
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
                
                VStack(alignment: .leading, spacing: 5) {
                    Text(address.isEmpty ? "Самовывоз": "Адрес доставки: \(address)")
                        .fontWeight(.bold)
                    Text(viewModel.convertClientInfo(client: order.client))
                        .fontWeight(.bold)
                }
                
                Spacer()
                
                HStack {
                    Text(viewModel.convertPreferedTime(order: order.order))
                        .fontWeight(.bold)
                    Spacer()
                    Text("\(viewModel.getSum(by: order.order)) ₽")
                        .fontWeight(.bold)
                }
                
                if order.status.statusId < 5 {
                    Picker("Статус", selection: $currentStatus) {
                        ForEach(statuses, id: \.self) { status in
                            Text(status.statusName)
                        }
                    }.fontWeight(.bold)
                    .onChange(of: currentStatus) {
                        self.viewModel.editOrder(statusId: currentStatus.statusId, order: order.order)
                    }
                }
            }
        }.onAppear {
            viewModel.getLocationAddress(order: order.order) { address in
                self.address = address
            }
        }
    }
}

//#Preview {
//    CookOrderCell(order: Order(id: 0, created: "", preferredTime: "", deliveryPoint: nil, products: nil, client: nil), address: "")
//}
