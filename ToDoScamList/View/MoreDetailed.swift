//
//  MoreDetailed.swift
//  ToDoScamList
//
//  Created by Денис Жестерев on 17.01.2023.
//

import SwiftUI
import FancyScrollView
import CoreData

struct MoreDetailed: View {
    @Binding var id: ObjectIdentifier
    @Binding var title: String
    @Binding var type: String
    @Binding var image: Data
    @Binding var description: String
    @Binding var allPower: Double
    @Binding var averagePowerOfAll: Double
    @Binding var averagePowerSameType: Double
    @Binding var mostFrequentTypeCount: Int
    @Binding var mostFrequentType: String
    @Binding var sameTypeCount: Int
    @Binding var last30dayPower: Int
    @Binding var last30daySameTypeCount: Int
    @Binding var averagePowerOfLast30day: Double
    @Binding var currentWeekSameTypeCount: Int
    @Binding var currentWeekPower: Int
    @Binding var oneWeekAgoPower: Int
    @Binding var twoWeeksAgoPower: Int
    @Binding var threeWeeksAgoPower: Int
    @Binding var fourWeeksAgoPower: Int
    @Binding var fiveWeeksAgoPower: Int
    @Binding var eachTypeCount: [Int]
    @Binding var allTypes: [String]
    @StateObject var viewModel = MoreDetailedViewModel()
    @StateObject var mainViewModel = MainViewModel()
    let screenSize = UIScreen.main.bounds
    let textLimit = 280
    let coloredNavAppearance = UINavigationBarAppearance()
    let fetchRequest = NSFetchRequest<ScamCoreData>(entityName: "ScamCoreData")
    func saveToData() {
        if !viewModel.model.editIsShown {
            do {
                let results = try CoreDataManager.instance.managedObjectContext.fetch(fetchRequest)
                let editScam = results[findIndex()] as NSManagedObject
                editScam.setValue(description, forKey: "scamDescription")
                CoreDataManager.instance.saveContext()
                mainViewModel.updateView()
            } catch {
                let saveError = error as NSError
                print(saveError)
            }
        }
    }
    func newOrSystemImage() -> Image {
        if image != Data() {
            return Image(uiImage: UIImage(data: image) ?? UIImage())
        } else {
            return Image("Scam")
        }
    }
    func findIndex() -> Int {
        let fetchRequest = NSFetchRequest<ScamCoreData>(entityName: "ScamCoreData")
        var index = 0
        do {
            let results = try CoreDataManager.instance.managedObjectContext.fetch(fetchRequest)
            for scam in results where scam.id == id {
                if let unwrapped = results.firstIndex(of: scam) {index = unwrapped}
            }
        }
        catch {
            print("Error fetching data")
        }
        return index
    }
    var body: some View {
        ZStack {
            Text(" ")
                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
                .background(Color.black)
                .edgesIgnoringSafeArea(.all)
            FancyScrollView(title: title,
                            headerHeight: 350,
                            scrollUpHeaderBehavior: .sticky,
                            scrollDownHeaderBehavior: .sticky,
                            header: { newOrSystemImage().resizable().aspectRatio(contentMode: .fill) }) {
                ZStack(alignment: .top) {
                    ZStack(alignment: .top) {
                        Text("Описание:")
                            .font(.system(size: 35, weight: .medium, design: .default))
                            .frame(maxWidth: .infinity, maxHeight: 0, alignment: .leading)
                            .padding(.leading, 20)
                            .padding(.top, 70)
                        if description.isEmpty {
                            ZStack(alignment: .top) {
                                Text("Добавить описание")
                                    .font(.system(size: 20, weight: .medium, design: .default))
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .foregroundColor(.gray)
                                    .padding(.leading, 20)
                                Image(systemName: "pencil")
                                    .resizable()
                                    .frame(width: 20, height: 20)
                                    .foregroundColor(.blue)
                                    .frame(maxWidth: .infinity, alignment: .trailing)
                                    .padding(.trailing, 20)
                            }
                            .padding(.top, 120)
                            .onTapGesture {
                                viewModel.toggleEditIsShown()
                            }
                        } else {
                            ZStack(alignment: .top) {
                                Text(description)
                                    .font(.system(size: 19, weight: .medium, design: .default))
                                    .foregroundColor(.gray)
                                    .frame(maxWidth: .infinity, alignment: .topLeading)
                                    .padding(.leading, 20)
                                Image(systemName: "pencil")
                                    .resizable()
                                    .frame(width: 20, height: 20)
                                    .foregroundColor(.blue)
                                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
                                    .padding(.trailing, 30)
                                    .offset(y: -30)
                                    .onTapGesture {
                                        viewModel.model.editInput = description
                                        viewModel.toggleEditIsShown()
                                    }
                            }
                            .padding(.top, 120)
                        }
                        Text("Yo")
                            .opacity(0)
                            .padding(.top, 750)
                    }
                }
                .frame(maxHeight: .infinity)
                .onChange(of: viewModel.model.editIsShown) { _ in
                    description = viewModel.model.editInput
                    saveToData()
                }
                .frame(maxWidth: .infinity)
            }
                            .environment(\.colorScheme, .dark)
                            .fullScreenCover(isPresented: $viewModel.model.statIsShown) {
                                Statistics(type: $type, allPower: $allPower, averagePowerOfAll: $averagePowerOfAll, averagePowerSameType: $averagePowerSameType, averagePowerOfLast30day: $averagePowerOfLast30day, mostFrequentTypeCount: $mostFrequentTypeCount, mostFrequentType: $mostFrequentType, sameTypeCount: $sameTypeCount, last30dayPower: $last30dayPower, last30daySameTypeCount: $last30daySameTypeCount, currentWeekSameTypeCount: $currentWeekSameTypeCount, currentWeekPower: $currentWeekPower, oneWeekAgoPower: $oneWeekAgoPower, twoWeeksAgoPower: $twoWeeksAgoPower, threeWeeksAgoPower: $threeWeeksAgoPower, fourWeeksAgoPower: $fourWeeksAgoPower, fiveWeeksAgoPower: $fiveWeeksAgoPower, eachTypeCount: $eachTypeCount, allTypes: $allTypes)
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
            EditDescription(isShown: $viewModel.model.editIsShown, isCanceled: $viewModel.model.editIsCanceled, text: $viewModel.model.editInput)
            if !viewModel.model.editIsShown {
                Text("Статистика")
                    .foregroundColor(.white)
                    .font(.system(size: 18, weight: .bold, design: .default))
                    .frame(width: 180, height: 5)
                    .foregroundColor(.white)
                    .padding()
                    .background(Color(.orange))
                    .cornerRadius(20)
                    .onTapGesture {
                        viewModel.model.statIsShown.toggle()
                    }
                    .frame(maxHeight: screenSize.height, alignment: .bottom)
                    .offset(y: -20)
            }
        }
        .environment(\.colorScheme, .dark)
    }
}

struct MoreDetailed_Previews: PreviewProvider {
    static var previews: some View {
        MoreDetailed(id: .constant(ObjectIdentifier(AnyObject.self)), title: .constant(""), type: .constant(""), image: .constant(Data()), description: .constant(""), allPower: .constant(0.0), averagePowerOfAll: .constant(0.0), averagePowerSameType: .constant(0.0), mostFrequentTypeCount: .constant(0), mostFrequentType: .constant(""), sameTypeCount: .constant(0), last30dayPower: .constant(0), last30daySameTypeCount: .constant(0), averagePowerOfLast30day: .constant(0.0), currentWeekSameTypeCount: .constant(0), currentWeekPower: .constant(0), oneWeekAgoPower: .constant(0), twoWeeksAgoPower: .constant(0), threeWeeksAgoPower: .constant(0), fourWeeksAgoPower: .constant(0), fiveWeeksAgoPower: .constant(0), eachTypeCount: .constant([0]), allTypes: .constant([""]))
    }
}
