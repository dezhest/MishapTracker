//
//  ContentView.swift
//  ToDoScamList
//
//  Created by Денис Жестерев on 16.12.2022.
//

import SwiftUI
import CoreData

struct ContentView: View {
    // MARK: — Main properties
    @ObservedObject var scams = Scams()
    @State private var showingNewSheet = false
    @State private var showingImage = false
    @State private var mdIsShown = false
    @State var pickerSelection: Int = 1
    @State private var image: Data = .init(count: 0)
    @GestureState private var scale: CGFloat = 1.0
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(entity: Scam.entity(), sortDescriptors: []) var entity: FetchedResults<Scam>
    // MARK: — Properties for EditScam View
    @State private var editIsShown = false
    @State private var editIsCanceled = false
    @State private var editIsAdded = false
    @State private var editInput = ""
    @State private var editpower: Double = 0
    @State private var editOnChanged = false
    @State private var indexOfEditScam = 0
    @State private var indexOfMDScam = 0
    @State private var indexOfImage = 0
    @State private var showImage = Image("Scam")
    // MARK: — Properties for MoreDetailed View
    @State private var indexOfMoreDetailed: Int = 0
    @State private var mDID = ObjectIdentifier(AnyObject.self)
    @State private var mDTitle = ""
    @State private var mDType = ""
    @State private var mDImage = Data()
    @State private var mDDescription = ""
    @State private var mDSameTypeCount = 0
    @State private var mDaveragePowerSameType = 0.0
    @State private var mDallPower = 0.0
    @State private var mDaveragePowerOfAll = 0.0
    @State private var mDmostFrequentTypeCount = 0
    @State private var mDmostFrequentType = ""
    @State private var mDlast30dayPower = 0
    @State private var mDlast30daySameTypeCount = 0
    @State private var mDaveragePowerOfLast30day = 0.0
    @State private var mDcurrentWeekSameTypeCount = 0
    @State private var mDcurrentWeekPower = 0
    @State private var mDpreviosOneWeekPower = 0
    @State private var mDpreviosTwoWeekPower = 0
    @State private var mDpreviosThreeWeekPower = 0
    @State private var mDpreviosFourWeekPower = 0
    @State private var mDpreviosFiveWeekPower = 0
    @State private var mDeachTypeCount = [Int]()
    @State private var mDallTypes = [String]()
    let previosOneWeek = Date.today().previous(.monday).previous(.monday)
    let previosTwoWeek = Date.today().previous(.monday).previous(.monday).previous(.monday)
    let previosThreeWeek = Date.today().previous(.monday).previous(.monday).previous(.monday).previous(.monday)
    let previosFourWeek = Date.today().previous(.monday).previous(.monday).previous(.monday).previous(.monday).previous(.monday)
    let previosFiveWeek = Date.today().previous(.monday).previous(.monday).previous(.monday).previous(.monday).previous(.monday).previous(.monday)
    let monthAgoDate = Calendar(identifier: .iso8601).date(byAdding: .day, value: -30, to: Date())!
    var sortedScams: [Scam] {
        switch pickerSelection {
        case(1): return entity.sorted(by: {$0.selectedDate > $1.selectedDate})
        case(2): return entity.sorted(by: {$0.title < $1.title})
        case(3): return entity.sorted(by: {$0.power > $1.power})
        case(4): return entity.sorted(by: {$0.type > $1.type})
        default: return []
        }
    }
    init() {
        UITableView.appearance().backgroundColor = .clear
        UITableViewCell.appearance().backgroundColor = .clear
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor.orange]
    }
    var body: some View {
        ZStack {
            NavigationView {
                LinearGradient(gradient: Gradient(colors: [Color(UIColor(red: 255/255, green: 254/255, blue: 215/255, alpha: 1.0)),
                                                           Color(UIColor(red: 255/255, green: 223/255, blue: 226/255, alpha: 1.0))]),
                               startPoint: .top, endPoint: .bottom)
                .edgesIgnoringSafeArea(.vertical)
                .overlay(
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
                                                self.showingImage.toggle()
                                            }
                                            print(print(type(of: sortedScams[indexOfMoreDetailed].id)))
                                        }
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
                                                .onTapGesture {
                                                    mdIsShown.toggle()
                                                    moreDetailedComputing(item: item)
                                                }
                                        }
                                    }
                                } .frame(maxWidth: .infinity)
                                .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                                    Button(role: .destructive, action: {
                                        if let unwrapped = sortedScams.firstIndex(of: item) {indexOfEditScam = unwrapped}
                                        deleteScam(item: item)
                                    }) {
                                        Label("Delete", systemImage: "trash")
                                    }
                                }
                                .swipeActions(edge: .leading) {
                                    Button {
                                        editInput = item.title
                                        editpower = item.power
                                        if let unwrapped = sortedScams.firstIndex(of: item) {indexOfEditScam = unwrapped}
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
                            sortedScams[indexOfEditScam].title = editInput
                            sortedScams[indexOfEditScam].power = editpower
                            try? viewContext.save()
                        }
                    })
                .navigationBarTitle(Text("Scam List"))
                .navigationBarItems(leading:
                                        Picker("Select number", selection: $pickerSelection) {
                    Text("Сортировка по дате").tag(1)
                    Text("Сортировка по алфавиту").tag(2)
                    Text("Сортировка по силе скама").tag(3)
                    Text("Сортировка по типу").tag(4)
                }
                    .pickerStyle(.menu),
                                    trailing: Button(action: {
                    self.showingNewSheet = true
                }) {
                    Image(systemName: "plus")
                })
                .sheet(isPresented: $showingNewSheet) {
                    NewSheet()
                }
                .sheet(isPresented: $showingImage, content: {
                    ShowImage(image: $showImage)
                })
                .fullScreenCover(isPresented: $mdIsShown, content: {
                    MoreDetailed(id: $mDID, title: $mDTitle, type: $mDType, image: $mDImage, description: $mDDescription, allPower: $mDallPower, averagePowerOfAll: $mDaveragePowerOfAll, averagePowerSameType: $mDaveragePowerSameType, mostFrequentTypeCount: $mDmostFrequentTypeCount, mostFrequentType: $mDmostFrequentType, sameTypeCount: $mDSameTypeCount, last30dayPower: $mDlast30dayPower, last30daySameTypeCount: $mDlast30daySameTypeCount, averagePowerOfLast30day: $mDaveragePowerOfLast30day, currentWeekSameTypeCount: $mDcurrentWeekSameTypeCount, currentWeekPower: $mDcurrentWeekPower, previosOneWeekPower: $mDpreviosOneWeekPower, previosTwoWeekPower: $mDpreviosTwoWeekPower, previosThreeWeekPower: $mDpreviosThreeWeekPower, previosFourWeekPower: $mDpreviosFourWeekPower, previosFiveWeekPower: $mDpreviosFiveWeekPower, eachTypeCount: $mDeachTypeCount, allTypes: $mDallTypes)})
            }
            .navigationViewStyle(.stack)
            EditScam(isShown: $editIsShown, isCanceled: $editIsCanceled, text: $editInput, power: $editpower)
        } .environment(\.colorScheme, .light)
    }
    // MARK: — Swipe to delete from list
    func deleteScam(item: Scam) {
        viewContext.delete(item)
        try? viewContext.save()
    }
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
    func newOrSystemImage(item: Scam) -> Image {
        if item.imageD != Data() {
            return Image(uiImage: UIImage(data: item.imageD ?? Data()) ?? UIImage())
        } else {
            return Image("Scam")
        }
    }
    // MARK: — Properties for MoreDetailed View
    func moreDetailedComputing(item: Scam) {
        if let unwrapped = sortedScams.firstIndex(of: item) {indexOfMoreDetailed = unwrapped}
        let arrayallPower = sortedScams.map({Int($0.power)})
        let arrayAllType = sortedScams.map({$0.type})
        let last30DayScams = sortedScams.filter({$0.selectedDate > monthAgoDate})
        let currentWeekScams = sortedScams.filter({$0.selectedDate > Date.today().previous(.monday)})
        let previosOneWeekScams = sortedScams.filter({($0.selectedDate > previosOneWeek) && ($0.selectedDate < Date.today().previous(.monday))})
        let previosTwoWeekScams = sortedScams.filter({($0.selectedDate > previosTwoWeek) && ($0.selectedDate < previosOneWeek)})
        let previosThreeWeekScams = sortedScams.filter({($0.selectedDate > previosThreeWeek) && ($0.selectedDate < previosTwoWeek)})
        let previosFourWeekScams = sortedScams.filter({($0.selectedDate > previosFourWeek) && ($0.selectedDate < previosThreeWeek)})
        let previosFiveWeekScams = sortedScams.filter({($0.selectedDate > previosFiveWeek) && ($0.selectedDate < previosFourWeek)})
        let sameTypeScams = sortedScams.filter({$0.type == sortedScams[indexOfMoreDetailed].type})
        let sameTypeAllPower = (Double(sameTypeScams.map({Int($0.power)}).reduce(0, +))*100).rounded()/100
        let allTypes = sortedScams.map({$0.type})
        func findEachTypeCount() -> [Int] {
            var eachTypeCount = [Int]()
            for item in allTypes.removingDuplicates() {
                eachTypeCount.append(allTypes.filter({$0 == item}).count)
            }
            return(eachTypeCount)
        }
        // MARK: — General Statistic
        let allPower = (Double(arrayallPower.reduce(0, +))*100).rounded()/100
        let averagePowerOfAll = (allPower / Double(sortedScams.count)*100).rounded()/100
        let averagePowerSameType = (sameTypeAllPower / Double(sameTypeScams.count)*100).rounded()/100
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
        // MARK: — Month Statistic
        let last30dayPower = last30DayScams.map({Int($0.power)}).reduce(0, +)
        let last30daySameTypeCount = last30DayScams.filter({$0.type == sortedScams[indexOfMoreDetailed].type}).count
        let averagePowerOfLast30day = (Double(last30dayPower) / Double(last30DayScams.count)*100).rounded()/100
        // MARK: — Week Statistic
        let currentWeekSameTypeCount = currentWeekScams.filter({$0.type == sortedScams[indexOfMoreDetailed].type}).count
        let currentWeekPower = currentWeekScams.map({Int($0.power)}).reduce(0, +)
        let previosOneWeekPower = previosOneWeekScams.map({Int($0.power)}).reduce(0, +)
        let previosTwoWeekPower = previosTwoWeekScams.map({Int($0.power)}).reduce(0, +)
        let previosThreeWeekPower = previosThreeWeekScams.map({Int($0.power)}).reduce(0, +)
        let previosFourWeekPower = previosFourWeekScams.map({Int($0.power)}).reduce(0, +)
        let previosFiveWeekPower = previosFiveWeekScams.map({Int($0.power)}).reduce(0, +)
        // MARK: — State Properties for MoreDetailed View
        mDID = sortedScams[indexOfMoreDetailed].id
        mDTitle = sortedScams[indexOfMoreDetailed].title
        mDType = sortedScams[indexOfMoreDetailed].type
        if let unwrapped = sortedScams[indexOfMoreDetailed].imageD {mDImage = unwrapped}
        mDDescription = sortedScams[indexOfMoreDetailed].scamDescription
        mDSameTypeCount = sameTypeScams.count
        mDallPower = allPower
        mDaveragePowerOfAll = averagePowerOfAll
        mDaveragePowerSameType = averagePowerSameType
        mDmostFrequentTypeCount = mostFrequentTypeCount
        mDmostFrequentType = mostFrequentType
        mDlast30dayPower = last30dayPower
        mDlast30daySameTypeCount = last30daySameTypeCount
        mDaveragePowerOfLast30day = averagePowerOfLast30day
        mDcurrentWeekSameTypeCount = currentWeekSameTypeCount
        mDcurrentWeekPower = currentWeekPower
        mDpreviosOneWeekPower = previosOneWeekPower
        mDpreviosTwoWeekPower = previosTwoWeekPower
        mDpreviosThreeWeekPower = previosThreeWeekPower
        mDpreviosFourWeekPower = previosFourWeekPower
        mDpreviosFiveWeekPower = previosFiveWeekPower
        mDeachTypeCount = findEachTypeCount()
        mDallTypes = allTypes.removingDuplicates()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .previewInterfaceOrientation(.portrait)
    }
}
