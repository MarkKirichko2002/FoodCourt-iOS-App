//
//  BasketListView.swift
//  FoodCourt
//
//  Created by Марк Киричко on 09.10.2024.
//

import SwiftUI
import SDWebImageSwiftUI

struct BasketListView: View {
    
    @EnvironmentObject var menuList: MenuList
    
    @State var time = Date()
    @State var alert = false
    @State var isLoading = true
    @State var isWorking = false
    @State var buttonDisabled = false
    @State var suggestions = [Suggestion]()
    @State var text = ""
    @State var currentSuggestion = Suggestion(value: "", unrestrictedValue: "", data: [:])
    
    // MARK: - сервисы
    let service = APIService()
    let dateManager = DateManager()
    let locationService = LocationService()
    
    var body: some View {
        NavigationView {
            VStack {
                if isLoading {
                    ProgressView()
                        .scaleEffect(1.5, anchor: .center)
                } else if !isWorking {
                    Text("Нет поваров")
                        .fontWeight(.bold)
                } else if !menuList.tags.isEmpty {
                    Form() {
                        Section(header: Text("Заказы").font(.system(size: 18))) {
                            List {
                                ForEach(Array(menuList.products.keys), id: \.id) { key in
                                    if menuList.products[key] == 0 || menuList.tags.isEmpty {
                                        
                                    } else {
                                        HStack(spacing: 15) {
                                            WebImage(url: URL(string: key.photo)!)
                                                .resizable()
                                                .frame(width: 80, height: 80)
                                            VStack(alignment: .leading, spacing: 15) {
                                                Text(key.name)
                                                    .fontWeight(.bold)
                                                Text("\(menuList.products[key] ?? 0) шт * \(key.price) ₽ = \(priceCount(price: key.price, count: menuList.products[key] ?? 0))")
                                                    .fontWeight(.bold)
                                            }
                                            Spacer()
                                            HStack {
                                                Image("trash")
                                                    .onTapGesture {
                                                        if menuList.products[key] == 1 {
                                                            let id = menuList.tags.firstIndex { $0 == key.id }!
                                                            menuList.tags.remove(at: id)
                                                            menuList.products[key] = (menuList.products[key] ?? 0) - 1
                                                        } else {
                                                            menuList.products[key] = (menuList.products[key] ?? 0) - 1
                                                        }
                                                    }
                                                Text("\(menuList.products[key] ?? 0)")
                                                    .tint(Color(UIColor.label))
                                                Image(systemName: "plus")
                                                    .onTapGesture {
                                                        menuList.products[key] = (menuList.products[key] ?? 0) + 1
                                                    }
                                            }
                                            .padding(5)
                                            .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color(UIColor.label), lineWidth: 1))
                                            Image(systemName: "trash")
                                                .onTapGesture {
                                                    menuList.products[key] = 0
                                                    let id = menuList.tags.firstIndex { $0 == key.id }!
                                                    menuList.tags.remove(at: id)
                                                    print(menuList.tags)
                                             }
                                        }
                                    }
                                }
                            }
                        }
                        
                        Section() {
                            DatePicker(selection: $time, displayedComponents: .hourAndMinute) {
                                Text("Выберите время")
                                    .fontWeight(.bold)
                            }
                            .onChange(of: time) { _, newValue in
                                if dateManager.isValidTime(time: newValue) {
                                    self.buttonDisabled = false
                                } else {
                                    self.buttonDisabled = true
                                    self.alert.toggle()
                                }
                            }
                        }
                        
                        Section() {
                            TextField("", text: $text, prompt: Text("Введите ваш адрес"))
                                .onChange(of: text) { oldValue, newValue in
                                    self.locationService.getSuggestions(text: newValue) { suggestions in
                                        DispatchQueue.main.async {
                                            self.suggestions = suggestions
                                        }
                                    }
                                }
                            List(suggestions, id: \.value) { suggestion in
                                Text(convert(data: suggestion.data))
                                    .onTapGesture {
                                        text = convert(data: suggestion.data)
                                        currentSuggestion = suggestion
                                        suggestions = []
                                 }
                            }
                        }
                        
                        Section() {
                            HStack {
                                Text("Итог: \(getSum()) ₽")
                                    .fontWeight(.bold)
                                Spacer()
                                Button(action: {
                                    makeOrder()
                                }) {
                                    Text("Заказать")
                                        .fontWeight(.bold)
                                }.disabled(buttonDisabled)
                            }
                        }
                    }
                } else if menuList.tags.isEmpty {
                    VStack {
                        Text("Корзина пуста")
                            .font(.system(size: 20, weight: .bold))
                            .padding(15)
                        Button(action: {
                            NotificationCenter.default.post(name: Notification.Name("index"), object: 0)
                        }) {
                            Text("Перейти в меню")
                                .font(.system(size: 16, weight: .bold))
                        }.buttonStyle(.bordered)
                            .cornerRadius(10)
                    }
                }
            }
            .navigationTitle("Корзина")
            .alert("Время не актуально", isPresented: $alert) {
                Button(action: {
                    
                }) {
                    Text("ОК")
                }
            } message: {
                Text("Выберите другое время")
            }
            .onAppear {
                service.getWorkingCooks { isWorking in
                    if isWorking == "true" {
                        self.isWorking = true
                    } else {
                        self.isWorking = false
                    }
                    self.isLoading = false
                }
                
                if dateManager.isValidTime(time: Date()) {
                    self.buttonDisabled = false
                } else {
                    self.buttonDisabled = true
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: {
                        menuList.products.removeAll()
                        menuList.tags.removeAll()
                    }) {
                        Image("trash")
                    }
                }
            }
        }
    }
    
    func makeOrder() {
        var model: DeliveryPoint?  = nil
        if let lat = currentSuggestion.data["geo_lat"], let lon = currentSuggestion.data["geo_lon"] {
            model = DeliveryPoint(lat: Double(lat ?? ""), lon: Double(lon ?? ""))
        }
        service.createOrder(location: model, time: dateManager.getFormattedTime(date: time), products: menuList.products) {
            DispatchQueue.main.async {
                self.menuList.products.removeAll()
                self.menuList.tags.removeAll()
                NotificationCenter.default.post(name: Notification.Name("index"), object: 2)
                NotificationCenter.default.post(name: Notification.Name("order created"), object: nil)
            }
        }
    }
    
    func priceCount(price: Int, count: Int)-> String {
        let sum = price * count
        return "\(sum) ₽"
    }
    
    func getSum()-> Int {
        
        var sum = 0
        
        for product in menuList.products {
            sum = sum + (product.key.price * product.value)
        }
        
        return sum
    }
    
    func convert(data: [String: String?])-> String {
        let street = data["street"] == nil ? "" : "ул. \((data["street"] ?? "") ?? "")"
        let house = data["house"] == nil ? "" : " д. \((data["house"] ?? "") ?? "")"
        let block = data["block"] == nil ? "" : " стр. \((data["block"] ?? "") ?? "")"
        let floor = data["floor"] == nil ? "" : " этаж. \((data["floor"] ?? "") ?? "")"
        let flat = data["flat"] == nil ? "" : " кв. \((data["flat"] ?? "") ?? "")"
        let room = data["room"] == nil ? "" : " комната. \((data["room"] ?? "") ?? "")"
        return "\(street), \(house) \(block)\(floor)\(flat)\(room)"
    }
}

//#Preview {
//    BasketListView()
//}
