//
//  MoreDetailed.swift
//  ToDoScamList
//
//  Created by Денис Жестерев on 17.01.2023.
//

import SwiftUI
import FancyScrollView
import Combine

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
    @Binding var previosOneWeekPower: Int
    @Binding var previosTwoWeekPower: Int
    @Binding var previosThreeWeekPower: Int
    @Binding var previosFourWeekPower: Int
    @Binding var previosFiveWeekPower: Int
    @Binding var eachTypeCount: [Int]
    @Binding var allTypes: [String]
    @State private var statIsShown = false
    @State private var statistic = false
    @State private var general = false
    @State private var month = false
    @State private var week = false
    @State private var editIsShown = false
    @State private var editIsCanceled = false
    @State private var editInput = ""
    @Environment(\.dismiss) var dismiss
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(entity: Scam.entity(), sortDescriptors: []) var entity: FetchedResults<Scam>
    let screenSize = UIScreen.main.bounds
    let textLimit = 280
    var body: some View {
        ZStack {
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
                            editIsShown.toggle()
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
                                    editInput = description
                                    editIsShown.toggle()
                                }
                        }
                        .padding(.top, 120)
                    }

            }
                Text("Статистика")
                    .foregroundColor(.white)
                    .font(.system(size: 18, weight: .bold, design: .default))
                    .frame(width: 180, height: 5)
                    .foregroundColor(.white)
                    .padding()
                    .background(Color(.orange))
                    .cornerRadius(20)
                    .onTapGesture {
                        statIsShown.toggle()
                    }
                    .padding(.top, 550)
            }
            .frame(maxHeight: .infinity)
            .onChange(of: editIsShown) {_ in
                description = editInput
                entity[findIndex()].scamDescription = description
                try? viewContext.save()
            }
            .frame(maxWidth: .infinity)
        }
                        .environment(\.colorScheme, .dark)
                        .sheet(isPresented: $statIsShown) {
                            Statistics(type: $type, allPower: $allPower, averagePowerOfAll: $averagePowerOfAll, averagePowerSameType: $averagePowerSameType, averagePowerOfLast30day: $averagePowerOfLast30day, mostFrequentTypeCount: $mostFrequentTypeCount, mostFrequentType: $mostFrequentType, sameTypeCount: $sameTypeCount, last30dayPower: $last30dayPower, last30daySameTypeCount: $last30daySameTypeCount, currentWeekSameTypeCount: $currentWeekSameTypeCount, currentWeekPower: $currentWeekPower, previosOneWeekPower: $previosOneWeekPower, previosTwoWeekPower: $previosTwoWeekPower, previosThreeWeekPower: $previosThreeWeekPower, previosFourWeekPower: $previosFourWeekPower, previosFiveWeekPower: $previosFiveWeekPower, eachTypeCount: $eachTypeCount, allTypes: $allTypes)
                        }
            EditDescription(isShown: $editIsShown, isCanceled: $editIsCanceled, text: $editInput)

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
        var index = 0
        for scam in entity where scam.id == id {
                if let unwrapped = entity.firstIndex(of: scam) {index = unwrapped}
        }
        return index
    }
}

struct MoreDetailed_Previews: PreviewProvider {
    static var previews: some View {
        MoreDetailed(id: .constant(ObjectIdentifier(AnyObject.self)), title: .constant(""), type: .constant(""), image: .constant(Data()), description: .constant(""), allPower: .constant(0.0), averagePowerOfAll: .constant(0.0), averagePowerSameType: .constant(0.0), mostFrequentTypeCount: .constant(0), mostFrequentType: .constant(""), sameTypeCount: .constant(0), last30dayPower: .constant(0), last30daySameTypeCount: .constant(0), averagePowerOfLast30day: .constant(0.0), currentWeekSameTypeCount: .constant(0), currentWeekPower: .constant(0), previosOneWeekPower: .constant(0), previosTwoWeekPower: .constant(0), previosThreeWeekPower: .constant(0), previosFourWeekPower: .constant(0), previosFiveWeekPower: .constant(0), eachTypeCount: .constant([0]), allTypes: .constant([""]))
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
