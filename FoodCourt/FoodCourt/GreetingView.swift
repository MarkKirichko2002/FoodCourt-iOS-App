//
//  GreetingView.swift
//  FoodCourt
//
//  Created by Марк Киричко on 22.10.2024.
//

import SwiftUI

struct GreetingView: View {
    
    @State var name = ""
    @State var phoneNumber = ""
    
    var body: some View {
        VStack(spacing: 30) {
            VStack(spacing: 10) {
                Text("Как к вам обращаться?")
                    .font(.title)
                TextField("Введите имя", text: $name)
                    .textFieldStyle(.roundedBorder)
                    .padding(30)
            }
            
            VStack(spacing: 10) {
                Text("Номер телефона")
                    .font(.title)
                TextField("Введите номер", text: $phoneNumber)
                    .textFieldStyle(.roundedBorder)
                    .padding(30)
            }
            
            Button(action: {
                
            }) {
                Text("Далее")
                    .font(.system(size: 20))
                    .foregroundColor(.white)
            }.buttonStyle(.bordered)
            
        }.padding(10)
        Spacer()
    }
}

#Preview {
    GreetingView()
}
