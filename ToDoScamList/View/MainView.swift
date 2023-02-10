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
    @ObservedObject var edit = EditScamModel()
    @StateObject var newScamViewModel = NewScamViewModel()
    @State private var imageIsShown = false
    @State private var mdIsShown = false
    @State private var editIsShown = false
    @State private var pickerSelection = 1
    @State private var image: Data = .init(count: 0)
    @State private var indexOfImage = 0
    @State private var showImage = Image("Scam")
    @State private var indexOfMoreDetailed = 0
    @GestureState private var scale: CGFloat = 1.0
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(entity: Scam.entity(), sortDescriptors: []) var entity: FetchedResults<Scam>
    var sortedScams: [Scam] {
        switch pickerSelection {
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
                    ForEach(sortedScams, id: \.self) { item in
                        ZStack {
                            newOrSystemImage(item: item)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 60, height: 60)
                                .clipShape(Circle())
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .onTapGesture {
                                    if item.imageD != Data() {
                                        if let unwrapped = sortedScams.firstIndex(of: item) {indexOfImage = unwrapped}
                                        showImage = Image(uiImage: UIImage(data: sortedScams[indexOfImage].imageD ?? Data()) ?? UIImage(imageLiteralResourceName: "Scam"))
                                        self.imageIsShown.toggle()
                                    }
                                }
                            cardScamView(item: item)
                                .onTapGesture {
                                    if let unwrapped = sortedScams.firstIndex(of: item) {indexOfMoreDetailed = unwrapped}
                                    if let unwrapped = sortedScams[indexOfMoreDetailed].imageD {stat.mDImage = unwrapped}
                                    mdIsShown.toggle()
                                    concurrentQueue.async {
                                        stat.globalStat(scam: sortedScams, index: indexOfMoreDetailed)
                                    }
                                    concurrentQueue.async {
                                        stat.monthStat(scam: sortedScams, index: indexOfMoreDetailed)
                                    }
                                    concurrentQueue.async {
                                        stat.weekStat(scam: sortedScams, index: indexOfMoreDetailed)
                                    }
                                }
                        }
                        .frame(maxWidth: .infinity)
                        .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                            Button(role: .destructive, action: {
                                if let unwrapped = sortedScams.firstIndex(of: item) {edit.indexOfEditScam = unwrapped}
                                deleteScam(item: item)
                            }) {
                                Label("Delete", systemImage: "trash")
                            }
                        }
                        .swipeActions(edge: .leading) {
                            Button {
                                edit.editInput = item.title
                                edit.editpower = item.power
                                if let unwrapped = sortedScams.firstIndex(of: item) {edit.indexOfEditScam = unwrapped}
                                withAnimation(.spring()) {
                                    editIsShown.toggle()
                                }
                            } label: {
                                Label("Edit", systemImage: "pencil")
                            }
                            .tint(.green)
                        }
                    }
                    .onChange(of: editIsShown) { _ in
                        sortedScams[edit.indexOfEditScam].title = edit.editInput
                        sortedScams[edit.indexOfEditScam].power = edit.editpower
                        try? viewContext.save()
                    }
                }
                .navigationBarTitle(Text("Scam List"))
                .navigationBarItems(leading: Picker("Select number", selection: $pickerSelection) {
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
                .sheet(isPresented: $imageIsShown, content: {
                    ShowImage(image: $showImage)
                })
                .fullScreenCover(isPresented: $mdIsShown, content: {
                    MoreDetailed(id: $stat.mDID, title: $stat.mDTitle, type: $stat.mDType, image: $stat.mDImage, description: $stat.mDDescription, allPower: $stat.mDallPower, averagePowerOfAll: $stat.mDaveragePowerOfAll, averagePowerSameType: $stat.mDaveragePowerSameType, mostFrequentTypeCount: $stat.mDmostFrequentTypeCount, mostFrequentType: $stat.mDmostFrequentType, sameTypeCount: $stat.mDSameTypeCount, last30dayPower: $stat.mDlast30dayPower, last30daySameTypeCount: $stat.mDlast30daySameTypeCount, averagePowerOfLast30day: $stat.mDaveragePowerOfLast30day, currentWeekSameTypeCount: $stat.mDcurrentWeekSameTypeCount, currentWeekPower: $stat.mDcurrentWeekPower, oneWeekAgoPower: $stat.mDoneWeekAgoPower, twoWeeksAgoPower: $stat.mDtwoWeeksAgoPower, threeWeeksAgoPower: $stat.mDthreeWeeksAgoPower, fourWeeksAgoPower: $stat.mDfourWeeksAgoPower, fiveWeeksAgoPower: $stat.mDfiveWeeksAgoPower, eachTypeCount: $stat.mDeachTypeCount, allTypes: $stat.mDallTypes)})
            }
            if editIsShown == true {
                Text(" ")
                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
                    .background(Color.black)
                    .edgesIgnoringSafeArea(.all)
                    .opacity(0.8)
                    .onTapGesture{
                        editIsShown = false
                    }
            }
            EditScam(isShown: $editIsShown, isCanceled: $edit.editIsCanceled, text: $edit.editInput, power: $edit.editpower)
        }
        .environment(\.colorScheme, .light)
    }
    func newOrSystemImage(item: Scam) -> Image {
        if item.imageD != Data() {
            return Image(uiImage: UIImage(data: item.imageD ?? Data()) ?? UIImage())
        } else {
            return Image("Scam")
        }
    }
    func deleteScam(item: Scam) {
        viewContext.delete(item)
        try? viewContext.save()
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
    }
}
