//
//  StatisticDisclosureGroupsView.swift
//  ToDoScamList
//
//  Created by Denis Zhesterev on 05.03.2023.
//

import SwiftUI

struct StatisticDisclosureGroupsView: View {
    @EnvironmentObject var mainViewModel: MainViewModel
    var body: some View {
        DisclosureGroup(isExpanded: $mainViewModel.statisticModel.general, content: {
            ZStack {
                Text("Общая сила скама")
                    .font(.system(size: 14, weight: .medium, design: .default))
                    .frame(maxWidth: .infinity, alignment: .leading)
                VStack {
                    Text("\(Int(mainViewModel.statisticModel.allPower))")
                        .medium14()
                }
                .frame(maxWidth: .infinity, alignment: .trailing)
            }
            ZStack {
                Text("Средняя сила")
                    .font(.system(size: 14, weight: .medium, design: .default))
                    .frame(maxWidth: .infinity, alignment: .leading)
                VStack {
                    Text(String(format: "%.2f", mainViewModel.statisticModel.averagePowerOfAll))
                        .medium14()
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
                    Text(mainViewModel.statisticModel.mostFrequentType)
                        .medium14()
                        .frame(maxWidth: .infinity, alignment: .trailing)
                        .offset(y: 22.5)
                    Text("\(mainViewModel.statisticModel.mostFrequentTypeCount)")
                        .medium14()
                        .frame(maxWidth: .infinity, maxHeight: 80, alignment: .bottomTrailing)
                }
            }
        }, label: {Text("За все время").font(.system(size: 18, weight: .bold, design: .default))})
        DisclosureGroup(isExpanded: $mainViewModel.statisticModel.month, content: {
            ZStack {
                Text("Общая сила")
                    .font(.system(size: 14, weight: .medium, design: .default))
                    .frame(maxWidth: .infinity, alignment: .leading)
                VStack {
                    Text("\(mainViewModel.statisticModel.last30dayPower)")
                        .medium14()
                }
                .frame(maxWidth: .infinity, alignment: .trailing)
            }
            HStack {
                Group {
                    Text("Количество скамов типа ")
                        .font(.system(size: 14, weight: .medium, design: .default))
                    + Text("#\(mainViewModel.statisticModel.type)")
                        .font(.system(size: 14, weight: .medium, design: .default))
                        .foregroundColor(.orange)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                VStack {
                    Text("\(mainViewModel.statisticModel.last30daySameTypeCount)")
                        .medium14()
                }
                .frame(alignment: .trailing)
            }
            ZStack {
                Text("Средняя сила")
                    .font(.system(size: 14, weight: .medium, design: .default))
                    .frame(maxWidth: .infinity, alignment: .leading)
                VStack {
                    Text(String(format: "%.2f", mainViewModel.statisticModel.averagePowerOfLast30day))
                        .medium14()
                }
                .frame(maxWidth: .infinity, alignment: .trailing)
            }
        }, label: {Text("За месяц").font(.system(size: 18, weight: .bold, design: .default))})
        DisclosureGroup(isExpanded: $mainViewModel.statisticModel.week, content: {
            ZStack {
                Text("Общая сила")
                    .font(.system(size: 14, weight: .medium, design: .default))
                    .frame(maxWidth: .infinity, alignment: .leading)
                VStack {
                    Text("\(mainViewModel.statisticModel.currentWeekPower)")
                        .medium14()
                }
                .frame(maxWidth: .infinity, alignment: .trailing)
            }
            HStack {
                Group {
                    Text("Количество скамов типа ")
                        .font(.system(size: 14, weight: .medium, design: .default))
                    + Text("#\(mainViewModel.statisticModel.type)")
                        .font(.system(size: 14, weight: .medium, design: .default))
                        .foregroundColor(.orange)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                VStack {
                    Text("\(mainViewModel.statisticModel.currentWeekSameTypeCount)")
                        .medium14()
                }
                .frame(alignment: .trailing)
            }
        }, label: {Text("Текущая неделя").font(.system(size: 18, weight: .bold, design: .default))})

    }
}

struct StatisticDisclosureGroupsView_Previews: PreviewProvider {
    static var previews: some View {
        StatisticDisclosureGroupsView()
    }
}
