//
//  Main.swift
//  ToDoScamList
//
//  Created by Денис Жестерев on 16.12.2022.
//

import SwiftUI
import CoreData

struct MainView: View {
    @ObservedObject var stat = StatisticModel()
    @StateObject var newScamViewModel = NewScamViewModel()
    @StateObject var viewModel = MainViewModel()
    @State private var mdIsShown = false
    @State private var image: Data = .init(count: 0)
    @State private var indexOfMoreDetailed = 0
    @GestureState private var scale: CGFloat = 1.0
//    let viewContext = PersistenceController.shared.container.viewContext
    let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Scam")
    @FetchRequest(entity: Scam.entity(), sortDescriptors: []) var entity: FetchedResults<Scam>
    var sortedScams: [Scam] {
        switch viewModel.pickerSelection {
        case(1): return entity.sorted(by: {$0.selectedDate > $1.selectedDate})
        case(2): return entity.sorted(by: {$0.title < $1.title})
        case(3): return entity.sorted(by: {$0.power > $1.power})
        case(4): return entity.sorted(by: {$0.type > $1.type})
        default: return []
        }
    }
    
    let concurrentQueue = DispatchQueue(label: "scam.stat", qos: .userInitiated, attributes: .concurrent)
    var powerColor = PowerColor()
    init() {
        NavigationTheme.navigationBarColors(background: .systemOrange, titleColor: .white)
    }
    var body: some View {
        ZStack {
            NavigationView {
                List {
                    ForEach(sortedScams) { item in
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
                                    if let unwrapped = sortedScams.firstIndex(of: item) {indexOfMoreDetailed = unwrapped}
                                    if let unwrapped = sortedScams[indexOfMoreDetailed].imageD {stat.mDImage = unwrapped}
                                    mdIsShown.toggle()
                                    concurrentQueue.async {
                                        stat.globalStat(scam: viewModel.sortedScams(), index: indexOfMoreDetailed)
                                    }
                                    concurrentQueue.async {
                                        stat.monthStat(scam: viewModel.sortedScams(), index: indexOfMoreDetailed)
                                    }
                                    concurrentQueue.async {
                                        stat.weekStat(scam: viewModel.sortedScams(), index: indexOfMoreDetailed)
                                    }
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
                .navigationBarItems(leading: Picker("Select number", selection: $viewModel.pickerSelection) {
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
                .sheet(isPresented: $viewModel.imageIsShown, content: {
                    ShowImage(image: $viewModel.showImage)
                })
                .fullScreenCover(isPresented: $mdIsShown, content: {
                    MoreDetailed(id: $stat.mDID, title: $stat.mDTitle, type: $stat.mDType, image: $stat.mDImage, description: $stat.mDDescription, allPower: $stat.mDallPower, averagePowerOfAll: $stat.mDaveragePowerOfAll, averagePowerSameType: $stat.mDaveragePowerSameType, mostFrequentTypeCount: $stat.mDmostFrequentTypeCount, mostFrequentType: $stat.mDmostFrequentType, sameTypeCount: $stat.mDSameTypeCount, last30dayPower: $stat.mDlast30dayPower, last30daySameTypeCount: $stat.mDlast30daySameTypeCount, averagePowerOfLast30day: $stat.mDaveragePowerOfLast30day, currentWeekSameTypeCount: $stat.mDcurrentWeekSameTypeCount, currentWeekPower: $stat.mDcurrentWeekPower, oneWeekAgoPower: $stat.mDoneWeekAgoPower, twoWeeksAgoPower: $stat.mDtwoWeeksAgoPower, threeWeeksAgoPower: $stat.mDthreeWeeksAgoPower, fourWeeksAgoPower: $stat.mDfourWeeksAgoPower, fiveWeeksAgoPower: $stat.mDfiveWeeksAgoPower, eachTypeCount: $stat.mDeachTypeCount, allTypes: $stat.mDallTypes)})
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
            EditScam(isShown: $viewModel.model.editIsShown, isCanceled: $viewModel.editIsCanceled, text: $viewModel.editInput, power: $viewModel.editpower)
        }
        .environment(\.colorScheme, .light)
    }

    @ViewBuilder
    private func cardScamView(item: Scam) -> some View {
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
