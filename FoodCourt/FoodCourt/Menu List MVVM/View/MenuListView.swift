//
//  MenuListView.swift
//  FoodCourt
//
//  Created by Марк Киричко on 09.10.2024.
//

import SwiftUI
import SDWebImageSwiftUI

class MenuList: ObservableObject {
    @Published var products: [Product : Int] = [:]
    @Published var tags = [Int]()
    @Published var deliveryPrice: Int = 0
}

struct MenuListView: View {
    
    @EnvironmentObject var menuList: MenuList
    @ObservedObject var viewModel = MenuListViewModel()
    
    @State private var scrollPosition: CGFloat = 0.0
    
    var body: some View {
        NavigationView {
            VStack {
                if viewModel.isLoading {
                    ProgressView()
                        .scaleEffect(1.5, anchor: .center)
                } else {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            ForEach(viewModel.categories, id: \.name) { category in
                                if viewModel.selectedCategory == category.name {
                                    Button(action: {
                                        viewModel.selectedCategory = category.name
                                        viewModel.isScroll.toggle()
                                    }) {
                                        Text("\(category.name)")
                                            .fontWeight(.bold)
                                    }.buttonStyle(.bordered)
                                        .cornerRadius(10)
                                        .padding(5)
                                } else {
                                    Button(action: {
                                        viewModel.selectedCategory = category.name
                                        viewModel.isScroll.toggle()
                                    }) {
                                        Text("\(category.name)")
                                            .padding(5)
                                    }
                                }
                            }
                        }
                    }
                    ScrollViewReader { scrollView in
                        ZStack(alignment: .bottomTrailing) {
                            List {
                                ForEach(viewModel.categories, id: \.name) { category in
                                    Section(header: Text("\(category.name)").font(.system(size: 18))) {
                                        ForEach(category.products) { product in
                                            HStack(spacing: 15) {
                                                WebImage(url: URL(string: product.photo.convertImage())!)
                                                    .resizable()
                                                    .frame(width: 80, height: 80)
                                                VStack(alignment: .leading, spacing: 15) {
                                                    Text(product.name)
                                                        .fontWeight(.bold)
                                                    Text(product.description)
                                                        .fontWeight(.bold)
                                                    
                                                    if menuList.tags.contains(where: { $0 == product.id }) {
                                                        HStack(spacing: 10) {
                                                            Image("trash")
                                                                .onTapGesture {
                                                                    if menuList.products[product] == 1 {
                                                                        let id = menuList.tags.firstIndex { $0 == product.id }!
                                                                        menuList.tags.remove(at: id)
                                                                        menuList.products[product] = (menuList.products[product] ?? 0) - 1
                                                                    } else {
                                                                        menuList.products[product] = (menuList.products[product] ?? 0) - 1
                                                                    }
                                                                }
                                                            Text("\(menuList.products[product] ?? 0)")
                                                                .tint(Color(UIColor.label))
                                                            Image(systemName: "plus")
                                                                .onTapGesture {
                                                                    menuList.products[product] = (menuList.products[product] ?? 0) + 1
                                                                }
                                                        }
                                                        .padding(5)
                                                        .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color(UIColor.label), lineWidth: 1))
                                                    } else if !menuList.tags.contains(where: { $0 == product.id }) {
                                                        if viewModel.getIsCook() {
                                                            HStack {
                                                                Image("edit")
                                                                    .tint(Color(UIColor.label))
                                                                    .padding(5)
                                                                    .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color(UIColor.label), lineWidth: 1))
                                                                    .onTapGesture {
                                                                        viewModel.currentProduct = product
                                                                        viewModel.isPresented.toggle()
                                                                    }
                                                                Image("trash")
                                                                    .tint(Color(UIColor.label))
                                                                    .padding(5)
                                                                    .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color(UIColor.label), lineWidth: 1))
                                                                    .onTapGesture {
                                                                        viewModel.deleteProduct(product: product)
                                                                    }
                                                            }
                                                        } else {
                                                            Text("\(product.price) ₽")
                                                                .tint(Color(UIColor.label))
                                                                .padding(5)
                                                                .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color(UIColor.label), lineWidth: 1))
                                                                .onTapGesture {
                                                                    if menuList.products[product] == nil || menuList.products[product] == 0  {
                                                                        menuList.products[product] = 1
                                                                    }
                                                                    menuList.tags.append(product.id)
                                                                }
                                                        }
                                                    }
                                                }
                                            }
                                        }.id(category.name)
                                    }
                                }
                            }.refreshable {
                                viewModel.getMenu()
                            }
                            
                            if viewModel.getIsCook() {
                                Button {
                                    viewModel.resetCurrentProduct()
                                    viewModel.isPresented.toggle()
                                } label: {
                                    Image(systemName: "plus")
                                        .font(.title.weight(.semibold))
                                        .padding()
                                        .background(Color(.systemBackground))
                                        .foregroundColor(.primary)
                                        .clipShape(Circle())
                                }
                                .padding(25)
                            }
                        }
                        .onChange(of: viewModel.isScroll) {
                            withAnimation {
                                scrollView.scrollTo(viewModel.selectedCategory, anchor: .top)
                            }
                        }
                    }
                    
                    if !viewModel.getIsCook() {
                        HStack {
                            Text("Доставка стоит \(menuList.deliveryPrice) ₽")
                            Spacer()
                            HStack(spacing: 10) {
                                Image("basket")
                                Text("\(viewModel.getSum(by: menuList.products)) ₽")
                                    .fontWeight(.bold)
                            }.padding(5)
                                .onTapGesture {
                                    NotificationCenter.default.post(name: Notification.Name("index"), object: 1)
                                }
                                .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color(UIColor.label), lineWidth: 1))
                        }.padding(10)
                            .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color(UIColor.label), lineWidth: 0.1))
                    }
                }
            }
            .navigationTitle("Меню")
            .navigationBarTitleDisplayMode(.inline)
            .fullScreenCover(isPresented: $viewModel.isPresented) {
                NavigationView {
                    AddProductView(isChanged: $viewModel.isChanged, product: viewModel.currentProduct)
                }
            }
            .onChange(of: viewModel.isChanged) {
                viewModel.getMenu()
            }
        }
    }
}


//#Preview {
//    MenuListView()
//}
