//
//  Statistics.swift
//  ToDoScamList
//
//  Created by Denis Zhesterev on 26.01.2023.
//

import SwiftUI
import SwiftUICharts

struct StatisticsView: View {
    @EnvironmentObject var mainViewModel: MainViewModel
    @Environment(\.dismiss) var dismiss
    let screenSize = UIScreen.main.bounds
    let pieChartStyle = ChartStyle(backgroundColor: .black, accentColor: .orange, gradientColor: GradientColor(start: .orange, end: .red), textColor: .white, legendTextColor: .white, dropShadowColor: .gray)
    
    var body: some View {
        NavigationView {
            List {
                HStack {
                    Group {
                        Text("Количество скамов типа ")
                            .font(.system(size: 18, weight: .bold, design: .default))
                        + Text("#\(mainViewModel.statisticModel.type)")
                            .font(.system(size: 14, weight: .medium, design: .default))
                            .foregroundColor(.orange)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    VStack {
                        Text("\(mainViewModel.statisticModel.sameTypeCount)")
                            .medium14()
                    }
                    .frame(alignment: .trailing)
                }
                HStack {
                    Group {
                        Text("Средняя сила типа ")
                            .font(.system(size: 18, weight: .bold, design: .default))
                        + Text("#\(mainViewModel.statisticModel.type)")
                            .font(.system(size: 14, weight: .medium, design: .default))
                            .foregroundColor(.orange)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    VStack {
                        Text(String(format: "%.2f", mainViewModel.statisticModel.averagePowerSameType))
                            .medium14()
                    }
                    .frame(alignment: .trailing)
                }
                StatisticDisclosureGroupsView()
                VStack {
                    BarChartView(data: ChartData(values: [("\(mainViewModel.statisticModel.fiveMondayAgo) - \(mainViewModel.statisticModel.fourSundayAgo)", Double(mainViewModel.statisticModel.fiveWeeksAgoPower)), ("\(mainViewModel.statisticModel.fourMondayAgo) - \(mainViewModel.statisticModel.threeSundayAgo)", Double(mainViewModel.statisticModel.fourWeeksAgoPower)), ("\(mainViewModel.statisticModel.threeMondayAgo) - \(mainViewModel.statisticModel.twoSundayAgo)", Double(mainViewModel.statisticModel.threeWeeksAgoPower)), ("\(mainViewModel.statisticModel.twoMondayAgo) - \(mainViewModel.statisticModel.oneSundayAgo)", Double(mainViewModel.statisticModel.twoWeeksAgoPower)), ("\(mainViewModel.statisticModel.oneMondayAgo) - \(mainViewModel.statisticModel.lastSunday)", Double(mainViewModel.statisticModel.oneWeekAgoPower)), ("\(mainViewModel.statisticModel.lastMonday) - \(mainViewModel.statisticModel.today)", Double(mainViewModel.statisticModel.currentWeekPower))]), title: "Общая сила", legend: "за последние недели", style: Styles.barChartStyleOrangeLight, form: CGSize(width: screenSize.width * 0.8, height: 200))
                        .padding(.top, 15)
                        .frame(maxWidth: .infinity, alignment: .bottom)
                    PieChartView(data: mainViewModel.findPieChartData(), title: "Типы скамов", style: pieChartStyle, form: CGSize(width: screenSize.width * 0.8, height: 300))
                        .padding(.top, 15)
                        .frame(maxWidth: .infinity, alignment: .bottom)
                }
                
            }
            .navigationBarTitle("Статистика")
            .navigationBarItems(leading: Button(action: { dismiss() }) {
                Image(systemName: "chevron.left")
                    .backButton()
            }, trailing: Text(mainViewModel.statisticModel.type))
        }
        .environment(\.colorScheme, .dark)
    }
}

struct StatisticsView_Previews: PreviewProvider {
    static var previews: some View {
        StatisticsView()
    }
}
