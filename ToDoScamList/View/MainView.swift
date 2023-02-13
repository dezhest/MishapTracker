//
//  Main.swift
//  ToDoScamList
//
//  Created by Денис Жестерев on 16.12.2022.
//

import SwiftUI
import CoreData

struct MainView: View {
    
    @StateObject var newScamViewModel = NewScamViewModel()
    @StateObject var viewModel = MainViewModel()
    @GestureState private var scale: CGFloat = 1.0
    var powerColor = PowerColor()
    init() {
        NavigationTheme.navigationBarColors(background: .systemOrange, titleColor: .white)
    }
    var body: some View {
        ZStack {
            NavigationView {
                List {
                    ForEach(viewModel.sortedScams(), id: \.self) { item in
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
                            cardScamView(item: item)
                                .onTapGesture {
                                    viewModel.findIndexForMdView(item: item)
                                    viewModel.toggleMdIsShown()
                                    viewModel.computedStatistic()
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
                    .onChange(of: viewModel.model.editIsShown) { _ in
                            viewModel.onChangeEditScam()
                    }
                }
                .navigationBarTitle(Text("Scam List"))
                .navigationBarItems(leading: Picker("Select number", selection: $viewModel.model.pickerSelection) {
                    Text("Сортировка по дате").tag(1)
                    Text("Сортировка по алфавиту").tag(2)
                    Text("Сортировка по силе").tag(3)
                    Text("Сортировка по типу").tag(4)
                } .pickerStyle(.menu), trailing: Button(action: {
                    newScamViewModel.toggleNewScamIsShown()
                }) {
                    Image(systemName: "plus")
                })
                .fullScreenCover(isPresented: $newScamViewModel.newScamModel.newScamIsShown) {
                    NewScam()
                }
                .sheet(isPresented: $viewModel.model.imageIsShown, content: {
                    ShowImage(image: $viewModel.model.showImage)
                })
                .fullScreenCover(isPresented: $viewModel.model.mdIsShown, content: {
                    MoreDetailed(id: $viewModel.stat.mDID, title: $viewModel.stat.mDTitle, type: $viewModel.stat.mDType, image: $viewModel.stat.mDImage, description: $viewModel.stat.mDDescription, allPower: $viewModel.stat.mDallPower, averagePowerOfAll: $viewModel.stat.mDaveragePowerOfAll, averagePowerSameType: $viewModel.stat.mDaveragePowerSameType, mostFrequentTypeCount: $viewModel.stat.mDmostFrequentTypeCount, mostFrequentType: $viewModel.stat.mDmostFrequentType, sameTypeCount: $viewModel.stat.mDSameTypeCount, last30dayPower: $viewModel.stat.mDlast30dayPower, last30daySameTypeCount: $viewModel.stat.mDlast30daySameTypeCount, averagePowerOfLast30day: $viewModel.stat.mDaveragePowerOfLast30day, currentWeekSameTypeCount: $viewModel.stat.mDcurrentWeekSameTypeCount, currentWeekPower: $viewModel.stat.mDcurrentWeekPower, oneWeekAgoPower: $viewModel.stat.mDoneWeekAgoPower, twoWeeksAgoPower: $viewModel.stat.mDtwoWeeksAgoPower, threeWeeksAgoPower: $viewModel.stat.mDthreeWeeksAgoPower, fourWeeksAgoPower: $viewModel.stat.mDfourWeeksAgoPower, fiveWeeksAgoPower: $viewModel.stat.mDfiveWeeksAgoPower, eachTypeCount: $viewModel.stat.mDeachTypeCount, allTypes: $viewModel.stat.mDallTypes)})
            }
            if viewModel.model.editIsShown == true {
                Text(" ")
                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
                    .background(Color.black)
                    .edgesIgnoringSafeArea(.all)
                    .opacity(0.8)
                    .onTapGesture{
                        viewModel.model.editIsShown = false
                    }
            }
            EditScam(isShown: $viewModel.model.editIsShown, isCanceled: $viewModel.model.editIsCanceled, text: $viewModel.model.editInput, power: $viewModel.model.editpower)
        }
        .environment(\.colorScheme, .light)
    }

    @ViewBuilder
    private func cardScamView(item: ScamCoreData) -> some View {
        ZStack {
            VStack(alignment: .leading, spacing: 0) {
                Text(item.title)
                    .font(.system(size: 13, weight: .bold, design: .default))
                Text("#\(item.type)")
                    .font(.system(size: 10, weight: .medium, design: .default))
                    .opacity(0.6)
                    .padding(5)
                    .padding(.bottom, 3)
                    .padding(.leading, -5)
                HStack {
                    Text("\(Int(item.power))/10 скамов")
                        .font(.system(size: 12, weight: .medium, design: .default))
                        .foregroundColor(.white)
                        .padding(3)
                        .background(powerColor.chooseColor(power: Int(item.power)))
                        .cornerRadius(20)
                        .padding(.bottom, 3)
                    Text("\(item.selectedDate, format: Date.FormatStyle(date: .numeric, time: .omitted))")
                        .font(.system(size: 10, weight: .medium, design: .default))
                        .padding(3)
                        .padding(.bottom, -1)
                        .foregroundColor(.gray)
                        .opacity(0.7)
                        .frame(alignment: .bottomLeading)
                        .offset(y: -1)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: 60, alignment: .leading)
            .padding(.leading, 65)
            .offset(x: 8)
            VStack {
                Image(systemName: "arrow.right.square")
                    .resizable()
                    .frame(width: 20, height: 20)
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    .opacity(0.35)
            }
            .padding(.trailing, 10)
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
            .previewInterfaceOrientation(.portrait)
            .environmentObject(MainViewModel())
    }
}
