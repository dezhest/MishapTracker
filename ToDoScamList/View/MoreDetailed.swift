//
//  MoreDetailed.swift
//  ToDoScamList
//
//  Created by Денис Жестерев on 17.01.2023.
//

import SwiftUI

struct MoreDetailed: View {
    @Binding var title: String
    @Binding var allPower: Double
    @Binding var medianaPowerOfAll: Double
    @Binding var medianaPowerSameType: Double
    @Binding var mostFrequentTypeCount: Int
    @Binding var mostFrequentType: String
    @Binding var sameTypeCount: Int
    @Binding var last30dayPower: Int
    @Binding var last30daySameTypeCount: Int
    @Binding var medianaPowerOfLast30day: Double
    @Binding var currentWeekSameTypeCount: Int
    @Binding var currentWeekPower: Int
    @Binding var previosOneWeekPower: Int
    @Binding var previosTwoWeekPower: Int
    @Binding var previosThreeWeekPower: Int
    @Binding var previosFourWeekPower: Int
    @Binding var previosFiveWeekPower: Int
    @State private var general = false
    @State private var month = false
    @State private var week = false
    var body: some View {
        NavigationView {
            List {
                HStack {
                    Text("Количество скамов такого же типа")
                    .font(.system(size: 18, weight: .bold, design: .default))
                        .font(.system(size: 14, weight: .medium, design: .default))
                        .frame(maxWidth: .infinity, alignment: .leading)
                    VStack {
                        Text("\(sameTypeCount)")
                            .font(.system(size: 14, weight: .medium, design: .default))
                            .foregroundColor(.white)
                            .padding(7)
                            .background(Color(.orange))
                            .cornerRadius(20)
                            .padding(.bottom, 3)
                    }
                    .frame(alignment: .trailing)
                }
                HStack {
                    Text("Средняя сила скама такого же типа")
                    .font(.system(size: 18, weight: .bold, design: .default))
                        .font(.system(size: 14, weight: .medium, design: .default))
                        .frame(maxWidth: .infinity, alignment: .leading)
                    VStack {
                        Text(String(format: "%.2f", medianaPowerSameType))
                            .font(.system(size: 14, weight: .medium, design: .default))
                            .foregroundColor(.white)
                            .padding(7)
                            .background(Color(.orange))
                            .cornerRadius(20)
                            .padding(.bottom, 3)
                    }
                    .frame(alignment: .trailing)
                }
                DisclosureGroup(isExpanded: $general, content: {
                    ZStack {
                        Text("Общая сила скама")
                            .font(.system(size: 14, weight: .medium, design: .default))
                            .frame(maxWidth: .infinity, alignment: .leading)
                        VStack {
                            Text("\(Int(allPower))")
                                .font(.system(size: 14, weight: .medium, design: .default))
                                .foregroundColor(.white)
                                .padding(7)
                                .background(Color(.orange))
                                .cornerRadius(20)
                                .padding(.bottom, 3)
                        }
                        .frame(maxWidth: .infinity, alignment: .trailing)
                    }
                    ZStack {
                        Text("Средняя сила")
                            .font(.system(size: 14, weight: .medium, design: .default))
                            .frame(maxWidth: .infinity, alignment: .leading)
                        VStack {
                            Text(String(format: "%.2f", medianaPowerOfAll))
                                .font(.system(size: 14, weight: .medium, design: .default))
                                .foregroundColor(.white)
                                .padding(7)
                                .background(Color(.orange))
                                .cornerRadius(20)
                                .padding(.bottom, 3)
                        }
                        .frame(maxWidth: .infinity, alignment: .trailing)
                    }
                    ZStack {
                        VStack(alignment: .leading, spacing: 60) {
                            Text("Самый популярный тип:")
                                .font(.system(size: 14, weight: .medium, design: .default))
                                .padding(0)
                            Text("Встречается")
                                .font(.system(size: 14, weight: .medium, design: .default))
                                .padding(0)
                                .offset(y: -7)
                        }.frame(maxWidth: .infinity, alignment: .leading)
                        VStack {
                            Text(mostFrequentType)
                                .font(.system(size: 14, weight: .medium, design: .default))
                                .foregroundColor(.white)
                                .padding(7)
                                .background(Color(.orange))
                                .cornerRadius(20)
                                .padding(.bottom, 3)
                                .frame(maxWidth: .infinity, alignment: .trailing)
                                .offset(y: 22.5)
                            Text("\(mostFrequentTypeCount)")
                                .font(.system(size: 14, weight: .medium, design: .default))
                                .foregroundColor(.white)
                                .padding(7)
                                .background(Color(.orange))
                                .cornerRadius(20)
                                .padding(.bottom, 3)
                                .frame(maxWidth: .infinity, maxHeight: 80, alignment: .bottomTrailing)
                        }
                    }
                }, label: {Text("За все время").font(.system(size: 18, weight: .bold, design: .default))})
                DisclosureGroup(isExpanded: $month, content: {
                    ZStack {
                        Text("Общая сила")
                            .font(.system(size: 14, weight: .medium, design: .default))
                            .frame(maxWidth: .infinity, alignment: .leading)
                        VStack {
                            Text("\(last30dayPower)")
                                .font(.system(size: 14, weight: .medium, design: .default))
                                .foregroundColor(.white)
                                .padding(7)
                                .background(Color(.orange))
                                .cornerRadius(20)
                                .padding(.bottom, 3)
                        }
                        .frame(maxWidth: .infinity, alignment: .trailing)
                    }
                    HStack {
                        Text("Количество скамов в этом типе")
                            .font(.system(size: 14, weight: .medium, design: .default))
                            .frame(maxWidth: .infinity, alignment: .leading)
                        VStack {
                            Text("\(last30daySameTypeCount)")
                                .font(.system(size: 14, weight: .medium, design: .default))
                                .foregroundColor(.white)
                                .padding(7)
                                .background(Color(.orange))
                                .cornerRadius(20)
                                .padding(.bottom, 3)
                        }
                        .frame(alignment: .trailing)
                    }
                    ZStack {
                        Text("Средняя сила")
                            .font(.system(size: 14, weight: .medium, design: .default))
                            .frame(maxWidth: .infinity, alignment: .leading)
                        VStack {
                            Text(String(format: "%.2f", medianaPowerOfLast30day))
                                .font(.system(size: 14, weight: .medium, design: .default))
                                .foregroundColor(.white)
                                .padding(7)
                                .background(Color(.orange))
                                .cornerRadius(20)
                                .padding(.bottom, 3)
                        }
                        .frame(maxWidth: .infinity, alignment: .trailing)
                    }
                }, label: {Text("За месяц").font(.system(size: 18, weight: .bold, design: .default))})
                DisclosureGroup(isExpanded: $week, content: {
                    ZStack {
                        Text("Общая сила")
                            .font(.system(size: 14, weight: .medium, design: .default))
                            .frame(maxWidth: .infinity, alignment: .leading)
                        VStack {
                            Text("\(currentWeekPower)")
                                .font(.system(size: 14, weight: .medium, design: .default))
                                .foregroundColor(.white)
                                .padding(7)
                                .background(Color(.orange))
                                .cornerRadius(20)
                                .padding(.bottom, 3)
                        }
                        .frame(maxWidth: .infinity, alignment: .trailing)
                    }
                    HStack {
                        Text("Количество скамов в этом типе")
                            .font(.system(size: 14, weight: .medium, design: .default))
                            .frame(maxWidth: .infinity, alignment: .leading)
                        VStack {
                            Text("\(currentWeekSameTypeCount)")
                                .font(.system(size: 14, weight: .medium, design: .default))
                                .foregroundColor(.white)
                                .padding(7)
                                .background(Color(.orange))
                                .cornerRadius(20)
                                .padding(.bottom, 3)
                        }
                        .frame(alignment: .trailing)
                    }
                }, label: {Text("Текущая неделя").font(.system(size: 18, weight: .bold, design: .default))})
            }
            .navigationBarTitle(Text("Статистика"))
            .navigationBarItems(leading: Text("\(title)"))
        }.environment(\.colorScheme, .dark)
    }
}

struct MoreDetailed_Previews: PreviewProvider {
    static var previews: some View {
        MoreDetailed(title: .constant(""), allPower: .constant(0.0), medianaPowerOfAll: .constant(0.0), medianaPowerSameType: .constant(0.0), mostFrequentTypeCount: .constant(0), mostFrequentType: .constant(""), sameTypeCount: .constant(0), last30dayPower: .constant(0), last30daySameTypeCount: .constant(0), medianaPowerOfLast30day: .constant(0.0), currentWeekSameTypeCount: .constant(0), currentWeekPower: .constant(0), previosOneWeekPower: .constant(0), previosTwoWeekPower: .constant(0), previosThreeWeekPower: .constant(0), previosFourWeekPower: .constant(0), previosFiveWeekPower: .constant(0))
    }
}
