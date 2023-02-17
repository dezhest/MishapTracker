//
//  Statistics.swift
//  ToDoScamList
//
//  Created by Denis Zhesterev on 26.01.2023.
//

import SwiftUI
import SwiftUICharts

struct Statistics: View {
    @EnvironmentObject var mainViewModel: MainViewModel
    @Environment(\.presentationMode) var presentationMode
    let screenSize = UIScreen.main.bounds
    let pieChartStyle = ChartStyle(backgroundColor: .black, accentColor: .orange, gradientColor: GradientColor(start: .orange, end: .red), textColor: .white, legendTextColor: .white, dropShadowColor: .gray)
    
    var body: some View {
        NavigationView {
        List {
            HStack {
                Group {
                    Text("Количество скамов типа ")
                        .font(.system(size: 18, weight: .bold, design: .default))
                    + Text("#\(mainViewModel.model.type)")
                        .font(.system(size: 14, weight: .medium, design: .default))
                        .foregroundColor(.orange)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                VStack {
                    Text("\(mainViewModel.model.sameTypeCount)")
                        .medium14()
                }
                .frame(alignment: .trailing)
            }
            HStack {
                Group {
                    Text("Средняя сила типа ")
                        .font(.system(size: 18, weight: .bold, design: .default))
                    + Text("#\(mainViewModel.model.type)")
                        .font(.system(size: 14, weight: .medium, design: .default))
                        .foregroundColor(.orange)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                VStack {
                    Text(String(format: "%.2f", mainViewModel.model.averagePowerSameType))
                        .medium14()
                }
                .frame(alignment: .trailing)
            }
            DisclosureGroup(isExpanded: $mainViewModel.model.general, content: {
                ZStack {
                    Text("Общая сила скама")
                        .font(.system(size: 14, weight: .medium, design: .default))
                        .frame(maxWidth: .infinity, alignment: .leading)
                    VStack {
                        Text("\(Int(mainViewModel.model.allPower))")
                            .medium14()
                    }
                    .frame(maxWidth: .infinity, alignment: .trailing)
                }
                ZStack {
                    Text("Средняя сила")
                        .font(.system(size: 14, weight: .medium, design: .default))
                        .frame(maxWidth: .infinity, alignment: .leading)
                    VStack {
                        Text(String(format: "%.2f", mainViewModel.model.averagePowerOfAll))
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
                        Text(mainViewModel.model.mostFrequentType)
                            .medium14()
                            .frame(maxWidth: .infinity, alignment: .trailing)
                            .offset(y: 22.5)
                        Text("\(mainViewModel.model.mostFrequentTypeCount)")
                            .medium14()
                            .frame(maxWidth: .infinity, maxHeight: 80, alignment: .bottomTrailing)
                    }
                }
            }, label: {Text("За все время").font(.system(size: 18, weight: .bold, design: .default))})
            DisclosureGroup(isExpanded: $mainViewModel.model.month, content: {
                ZStack {
                    Text("Общая сила")
                        .font(.system(size: 14, weight: .medium, design: .default))
                        .frame(maxWidth: .infinity, alignment: .leading)
                    VStack {
                        Text("\(mainViewModel.model.last30dayPower)")
                            .medium14()
                    }
                    .frame(maxWidth: .infinity, alignment: .trailing)
                }
                HStack {
                    Group {
                        Text("Количество скамов типа ")
                            .font(.system(size: 14, weight: .medium, design: .default))
                        + Text("#\(mainViewModel.model.type)")
                            .font(.system(size: 14, weight: .medium, design: .default))
                            .foregroundColor(.orange)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    VStack {
                        Text("\(mainViewModel.model.last30daySameTypeCount)")
                            .medium14()
                    }
                    .frame(alignment: .trailing)
                }
                ZStack {
                    Text("Средняя сила")
                        .font(.system(size: 14, weight: .medium, design: .default))
                        .frame(maxWidth: .infinity, alignment: .leading)
                    VStack {
                        Text(String(format: "%.2f", mainViewModel.model.averagePowerOfLast30day))
                            .medium14()
                    }
                    .frame(maxWidth: .infinity, alignment: .trailing)
                }
            }, label: {Text("За месяц").font(.system(size: 18, weight: .bold, design: .default))})
            DisclosureGroup(isExpanded: $mainViewModel.model.week, content: {
                ZStack {
                    Text("Общая сила")
                        .font(.system(size: 14, weight: .medium, design: .default))
                        .frame(maxWidth: .infinity, alignment: .leading)
                    VStack {
                        Text("\(mainViewModel.model.currentWeekPower)")
                            .medium14()
                    }
                    .frame(maxWidth: .infinity, alignment: .trailing)
                }
                HStack {
                    Group {
                        Text("Количество скамов типа ")
                            .font(.system(size: 14, weight: .medium, design: .default))
                        + Text("#\(mainViewModel.model.type)")
                            .font(.system(size: 14, weight: .medium, design: .default))
                            .foregroundColor(.orange)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    VStack {
                        Text("\(mainViewModel.model.currentWeekSameTypeCount)")
                            .medium14()
                    }
                    .frame(alignment: .trailing)
                }
            }, label: {Text("Текущая неделя").font(.system(size: 18, weight: .bold, design: .default))})
            VStack {
                BarChartView(data: ChartData(values: [("\(mainViewModel.model.fiveMondayAgo) - \(mainViewModel.model.fourSundayAgo)", Double(mainViewModel.model.fiveWeeksAgoPower)), ("\(mainViewModel.model.fourMondayAgo) - \(mainViewModel.model.threeSundayAgo)", Double(mainViewModel.model.fourWeeksAgoPower)), ("\(mainViewModel.model.threeMondayAgo) - \(mainViewModel.model.twoSundayAgo)", Double(mainViewModel.model.threeWeeksAgoPower)), ("\(mainViewModel.model.twoMondayAgo) - \(mainViewModel.model.oneSundayAgo)", Double(mainViewModel.model.twoWeeksAgoPower)), ("\(mainViewModel.model.oneMondayAgo) - \(mainViewModel.model.lastSunday)", Double(mainViewModel.model.oneWeekAgoPower)), ("\(mainViewModel.model.lastMonday) - \(mainViewModel.model.today)", Double(mainViewModel.model.currentWeekPower))]), title: "Общая сила", legend: "за последние недели", style: Styles.barChartStyleOrangeLight, form: CGSize(width: screenSize.width * 0.8, height: 200))
                    .padding(.top, 15)
                    .frame(maxWidth: .infinity, alignment: .bottom)
                PieChartView(data: mainViewModel.findPieChartData(), title: "Типы скамов", style: pieChartStyle, form: CGSize(width: screenSize.width * 0.8, height: 300))
                    .padding(.top, 15)
                    .frame(maxWidth: .infinity, alignment: .bottom)
            }
            
        }
        .navigationBarTitle("Статистика")
        .navigationBarItems(leading: Button(action: { self.presentationMode.wrappedValue.dismiss() }) {
            Image(systemName: "chevron.left")
                .backButton()
        }, trailing: Text(mainViewModel.model.type))
    }
        .environment(\.colorScheme, .dark)
    }
}

struct Statistics_Previews: PreviewProvider {
    static var previews: some View {
        Statistics()
    }
}
