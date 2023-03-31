//
//  Main.swift
//  ToDoScamList
//
//  Created by Денис Жестерев on 16.12.2022.
//

import SwiftUI
import CoreData

struct MainView: View {
    @StateObject var viewModel = MainViewModel()
    @GestureState private var scale: CGFloat = 1.0
    let powerColor = PowerColor()
    init() {
        NavigationTheme.navigationBarColors(background: .systemOrange, titleColor: .white)
    }
    var body: some View {
        ZStack {
            NavigationView {
                List {
                    ForEach(viewModel.sortedScams, id: \.self) { item in
                        ZStack {
                            viewModel.newOrSystemImage(item: item)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 60, height: 60)
                                .clipShape(Circle())
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .onTapGesture {
                                    viewModel.showImage(item: item)
                                }
                            CardScamView(item: item)
                                .onTapGesture {
                                    viewModel.findIndexForMdView(item: item)
                                    viewModel.toggleMdIsShown()
                                    viewModel.computeStatistic()
                                }
                        }
                        .frame(maxWidth: .infinity)
                        .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                            Button(role: .destructive, action: {
                                viewModel.deleteScam(item: item)
                            }) {
                                Label("Delete", systemImage: "trash")
                            }
                        }
                        .swipeActions(edge: .leading) {
                            Button {
                                viewModel.placeholderTextField(item: item)
                                withAnimation(.spring()) {
                                    viewModel.toggleEditIsShown()
                                }
                            } label: {
                                Label("Edit", systemImage: "pencil")
                            }
                            .tint(.green)
                        }
                    }
                    .id(UUID())
                }
                .navigationBarTitle("Mishaps")
                .navigationBarItems(leading: Picker("Select number", selection: $viewModel.model.pickerSelection) {
                    Text("Сортировка по дате").tag(SortType.date)
                    Text("Сортировка по алфавиту").tag(SortType.name)
                    Text("Сортировка по силе").tag(SortType.power)
                    Text("Сортировка по типу").tag(SortType.type)
                } .pickerStyle(.menu), trailing: Button(action: {
                    viewModel.toggleNewScamIsShown()
                }) {
                    Image(systemName: "plus")
                })
                .fullScreenCover(isPresented: $viewModel.model.newScamIsShown) {
                    NewScamView()
                }
                .sheet(isPresented: $viewModel.model.imageIsShown, content: {
                    ShowImage(image: $viewModel.model.showImage)
                })
                .fullScreenCover(isPresented: $viewModel.model.mdIsShown, content: {
                    MoreDetailedView()})
            }
            if viewModel.editIsShown == true {
                Text(" ")
                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
                    .background(Color.black)
                    .edgesIgnoringSafeArea(.all)
                    .opacity(0.8)
                    .onTapGesture{
                        viewModel.toggleEditIsShown()
                    }
            }
            EditScamView(isShown: $viewModel.editIsShown, isCanceled: $viewModel.model.editIsCanceled, text: $viewModel.model.editInput, power: $viewModel.model.editpower)
        }
        .environmentObject(viewModel)
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
