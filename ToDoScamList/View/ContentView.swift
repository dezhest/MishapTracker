//
//  ContentView.swift
//  ToDoScamList
//
//  Created by Денис Жестерев on 16.12.2022.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @ObservedObject var stat = StatisticModel()
    @ObservedObject var edit = EditScamModel()
    @State private var newScamIsShown = false
    @State private var imageIsShown = false
    @State private var mdIsShown = false
    @State private var editIsShown = false
    @State private var image: Data = .init(count: 0)
    @State private var indexOfImage = 0
    @State private var showImage = Image("Scam")
    @State private var indexOfMoreDetailed = 0
    @GestureState private var scale: CGFloat = 1.0
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(entity: Scam.entity(), sortDescriptors: []) var entity: FetchedResults<Scam>
    @State var pickerSelection: Int = 1
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
                                    mDGlobalStat(item: item)
                                }
                                concurrentQueue.async {
                                    mDMonthStat(item: item)
                                }
                                concurrentQueue.async {
                                    mDWeekStat(item: item)
                                }
                            }
                        } .frame(maxWidth: .infinity)
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
                    self.newScamIsShown = true
                }) {
                    Image(systemName: "plus")
                })
                .fullScreenCover(isPresented: $newScamIsShown) {
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
    // MARK: — Swipe to delete from list
    func deleteScam(item: Scam) {
        viewContext.delete(item)
        try? viewContext.save()
    }
    // MARK: — Color of Scam power
    func colorOfPower(power: Int) -> Color {
        switch power {
        case 0: return Color(UIColor(red: 252/255, green: 191/255, blue: 41/255, alpha: 1.0))
        case 1: return Color(UIColor(red: 252/255, green: 178/255, blue: 43/255, alpha: 1.0))
        case 2: return Color(UIColor(red: 252/255, green: 164/255, blue: 45/255, alpha: 1.0))
        case 3: return Color(UIColor(red: 252/255, green: 153/255, blue: 47/255, alpha: 1.0))
        case 4: return Color(UIColor(red: 252/255, green: 141/255, blue: 48/255, alpha: 1.0))
        case 5: return Color(UIColor(red: 252/255, green: 127/255, blue: 49/255, alpha: 1.0))
        case 6: return Color(UIColor(red: 252/255, green: 114/255, blue: 50/255, alpha: 1.0))
        case 7: return Color(UIColor(red: 252/255, green: 102/255, blue: 51/255, alpha: 1.0))
        case 8: return Color(UIColor(red: 252/255, green: 88/255, blue: 51/255, alpha: 1.0))
        case 9: return Color(UIColor(red: 252/255, green: 72/255, blue: 51/255, alpha: 1.0))
        case 10: return Color(UIColor(red: 252/255, green: 55/255, blue: 51/255, alpha: 1.0))
        default: return Color(.black)
        }
    }
    // MARK: — Properties for MoreDetailed View
    func mDGlobalStat(item: Scam) {
        let allTypes = sortedScams.map({$0.type})
        let arrayallPower = sortedScams.map({Int($0.power)})
        let sameTypeScams = sortedScams.filter({$0.type == sortedScams[indexOfMoreDetailed].type})
        let sameTypeAllPower = (Double(sameTypeScams.map({Int($0.power)}).reduce(0, +))*100).rounded()/100
        let arrayAllType = sortedScams.map({$0.type})
        let mDID = sortedScams[indexOfMoreDetailed].id
        let mDTitle = sortedScams[indexOfMoreDetailed].title
        let mDType = sortedScams[indexOfMoreDetailed].type
        let mDDescription = sortedScams[indexOfMoreDetailed].scamDescription
        let mDSameTypeCount = sortedScams.filter({$0.type == sortedScams[indexOfMoreDetailed].type}).count
        let mDallPower = (Double(arrayallPower.reduce(0, +))*100).rounded()/100
        let mDaveragePowerOfAll = (mDallPower / Double(sortedScams.count)*100).rounded()/100
        let mDaveragePowerSameType = (sameTypeAllPower / Double(sameTypeScams.count)*100).rounded()/100
        let mDeachTypeCount = findEachTypeCount()
        let mDallTypes = allTypes.removingDuplicates()
        var mostFrequentTypeCount = 0
        var mostFrequentType = ""
        func mostFrequent<T: Hashable>(array: [T]) -> (value: T, count: Int)? {
            let counts = array.reduce(into: [:]) { $0[$1, default: 0] += 1 }
            if let (value, count) = counts.max(by: { $0.1 < $1.1 }) {
                return (value, count)
            }
            return nil
        }
        if let result = mostFrequent(array: arrayAllType) {
            if result.count == 1 && arrayAllType.count != 1 {
                mostFrequentType = "-"
                mostFrequentTypeCount = 0
            } else {
                mostFrequentType = result.value
                mostFrequentTypeCount = result.count
            }
        }
        func findEachTypeCount() -> [Int] {
            var eachTypeCount = [Int]()
            for item in allTypes.removingDuplicates() {
                eachTypeCount.append(allTypes.filter({$0 == item}).count)
            }
            return(eachTypeCount)
        }
        DispatchQueue.main.async{
            stat.mDID = mDID
            stat.mDTitle = mDTitle
            stat.mDType = mDType
            stat.mDDescription = mDDescription
            stat.mDSameTypeCount = mDSameTypeCount
            stat.mDallPower = mDallPower
            stat.mDaveragePowerOfAll = mDaveragePowerOfAll
            stat.mDaveragePowerSameType = mDaveragePowerSameType
            stat.mDmostFrequentTypeCount = mostFrequentTypeCount
            stat.mDmostFrequentType = mostFrequentType
            stat.mDeachTypeCount = mDeachTypeCount
            stat.mDallTypes = mDallTypes
        }
    }
    func mDMonthStat(item: Scam) {
        let last30DayScams = sortedScams.filter({$0.selectedDate > CalendarWeeksAgo().monthAgoDate})
        let mDlast30dayPower = last30DayScams.map({Int($0.power)}).reduce(0, +)
        let mDlast30daySameTypeCount = last30DayScams.filter({$0.type == sortedScams[indexOfMoreDetailed].type}).count
        let mDaveragePowerOfLast30day = (Double(mDlast30dayPower) / Double(last30DayScams.count)*100).rounded()/100
        DispatchQueue.main.async {
            stat.mDlast30dayPower = mDlast30dayPower
            stat.mDlast30daySameTypeCount = mDlast30daySameTypeCount
            stat.mDaveragePowerOfLast30day = mDaveragePowerOfLast30day
        }
    }
    func mDWeekStat(item: Scam) {
        let currentWeekScams = sortedScams.filter({$0.selectedDate > Date.today().previous(.monday)})
        let oneWeekAgoScams = sortedScams.filter({($0.selectedDate > CalendarWeeksAgo().oneWeekAgoDate) && ($0.selectedDate < Date.today().previous(.monday))})
        let twoWeeksAgoScams = sortedScams.filter({($0.selectedDate > CalendarWeeksAgo().twoWeeksAgoDate) && ($0.selectedDate < CalendarWeeksAgo().oneWeekAgoDate)})
        let threeWeeksAgoScams = sortedScams.filter({($0.selectedDate > CalendarWeeksAgo().threeWeeksAgoDate) && ($0.selectedDate < CalendarWeeksAgo().twoWeeksAgoDate)})
        let fourWeeksAgoScams = sortedScams.filter({($0.selectedDate > CalendarWeeksAgo().fourWeeksAgoDate) && ($0.selectedDate < CalendarWeeksAgo().threeWeeksAgoDate)})
        let fiveWeeksAgoScams = sortedScams.filter({($0.selectedDate > CalendarWeeksAgo().fiveWeeksAgoDate) && ($0.selectedDate < CalendarWeeksAgo().fourWeeksAgoDate)})
       let mDcurrentWeekSameTypeCount = currentWeekScams.filter({$0.type == sortedScams[indexOfMoreDetailed].type}).count
       let mDcurrentWeekPower = currentWeekScams.map({Int($0.power)}).reduce(0, +)
       let mDoneWeekAgoPower = oneWeekAgoScams.map({Int($0.power)}).reduce(0, +)
       let mDtwoWeeksAgoPower = twoWeeksAgoScams.map({Int($0.power)}).reduce(0, +)
       let mDthreeWeeksAgoPower = threeWeeksAgoScams.map({Int($0.power)}).reduce(0, +)
       let mDfourWeeksAgoPower = fourWeeksAgoScams.map({Int($0.power)}).reduce(0, +)
       let mDfiveWeeksAgoPower = fiveWeeksAgoScams.map({Int($0.power)}).reduce(0, +)
        DispatchQueue.main.async {
            stat.mDcurrentWeekSameTypeCount = mDcurrentWeekSameTypeCount
            stat.mDcurrentWeekPower = mDcurrentWeekPower
            stat.mDoneWeekAgoPower = mDoneWeekAgoPower
            stat.mDtwoWeeksAgoPower = mDtwoWeeksAgoPower
            stat.mDthreeWeeksAgoPower = mDthreeWeeksAgoPower
            stat.mDfourWeeksAgoPower = mDfourWeeksAgoPower
            stat.mDfiveWeeksAgoPower = mDfiveWeeksAgoPower
        }
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
                        .background(colorOfPower(power: Int(item.power)))
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

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .previewInterfaceOrientation(.portrait)
    }
}
