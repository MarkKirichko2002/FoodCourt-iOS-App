//
//  CookOrdersListView.swift
//  FoodCourt
//
//  Created by Марк Киричко on 01.12.2024.
//

import SwiftUI

struct CookOrdersListView: View {
    
    @ObservedObject var viewModel = CookOrdersListViewModel()
    
    var body: some View {
        NavigationView {
            VStack {
                if viewModel.isLoading {
                    ProgressView()
                        .scaleEffect(1.5, anchor: .center)
                } else if viewModel.orders.isEmpty {
                    Text("Заказов нет")
                        .fontWeight(.bold)
                } else {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            ForEach(viewModel.sections, id: \.name) { section in
                                if viewModel.selectedSection == section.name {
                                    Button(action: {
                                        viewModel.selectedSection = section.name
                                        viewModel.isScroll.toggle()
                                    }) {
                                        Text("\(section.name)")
                                            .fontWeight(.bold)
                                    }.buttonStyle(.bordered)
                                        .cornerRadius(10)
                                        .padding(5)
                                } else {
                                    Button(action: {
                                        viewModel.selectedSection = section.name
                                        viewModel.isScroll.toggle()
                                    }) {
                                        Text("\(section.name)")
                                            .padding(5)
                                    }
                                }
                            }
                        }
                    }
                    ScrollViewReader { scrollView in
                        List {
                            ForEach(viewModel.sections, id: \.name) { section in
                                Section(header: Text("\(section.name)").font(.system(size: 18))) {
                                    ForEach(section.orders) { order in
                                        CookOrderCell(order: order, viewModel: viewModel, statuses: viewModel.statuses)
                                    }.id(section.name)
                                }
                            }
                        }.refreshable {
                            viewModel.getOrders()
                        }
                        .onChange(of: viewModel.isScroll) {
                            withAnimation {
                                scrollView.scrollTo(viewModel.selectedSection, anchor: .top)
                            }
                        }
                    }
                }
            }.navigationTitle("Заказы")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Picker("", selection: $viewModel.isWorking) {
                            ForEach(WorkingStatus.allCases, id: \.self) { status in
                                Text(status.title)
                            }
                        }.onChange(of: viewModel.isWorking) { oldValue, newValue in
                            viewModel.editWorking(status: newValue)
                        }
                    }
              }
        }
    }
}

#Preview {
    CookOrdersListView()
}
