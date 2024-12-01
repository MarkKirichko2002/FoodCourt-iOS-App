//
//  ClientTabView.swift
//  FoodCourt
//
//  Created by Марк Киричко on 09.10.2024.
//

import SwiftUI

struct ClientTabView: View {
    
    @State private var selectedTab = UserDefaults.standard.object(forKey: "index") as? Int ?? 0
    var menuList = MenuList()
    
    let menuListView = MenuListView()
    let basketListView = BasketListView()
    let ordersListView = ClientOrdersListView()
    let profileView = ProfileView()
    
    var body: some View {
        TabView(selection: $selectedTab) {
            menuListView
                .environmentObject(menuList)
                .tabItem {
                    Image(selectedTab == 0 ? "menu selected" : "menu")
                    Text("Меню")
                }.tag(0)
            basketListView
                .environmentObject(menuList)
                .tabItem {
                    Image(selectedTab == 1 ? "basket selected" : "basket")
                    Text("Корзина")
                }.tag(1)
            ordersListView
                .tabItem {
                    Image("orders")
                    Text("Заказы")
                }.tag(2)
            profileView
                .tabItem {
                    Image(selectedTab == 3 ? "profile selected" : "profile")
                    Text("Профиль")
                }.tag(3)
        }.tint(Color(UIColor.label))
        .onAppear {
            observeIndex()
        }
        .onChange(of: selectedTab) { oldValue, newValue in
            UserDefaults.standard.set(newValue, forKey: "index")
        }
    }
    
    func observeIndex() {
        NotificationCenter.default.addObserver(forName: Notification.Name("index"), object: nil, queue: .main) { notification in
            if let index = notification.object as? Int {
                selectedTab = index
                UserDefaults.standard.set(index, forKey: "index")
            }
        }
    }
}

#Preview {
    ClientTabView()
}
