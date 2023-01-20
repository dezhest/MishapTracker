//
//  MoreDetailed.swift
//  ToDoScamList
//
//  Created by Денис Жестерев on 17.01.2023.
//

import SwiftUI
import SwiftUICharts

struct MoreDetailed: View {
    @Binding var title: String
    @Binding var type: String
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
    let data: BarChartData = weekOfData()
    let screenSize = UIScreen.main.bounds
    var body: some View {
        NavigationView {
                List {
                    HStack {
                        Group {
                            Text("Количество скамов типа ")
                                .font(.system(size: 18, weight: .bold, design: .default))
                                .font(.system(size: 14, weight: .medium, design: .default))
                            + Text("#\(type)")
                                .font(.system(size: 14, weight: .medium, design: .default))
                                .foregroundColor(.orange)
                        }
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
                        Group {
                            Text("Средняя сила типа ")
                                .font(.system(size: 18, weight: .bold, design: .default))
                            + Text("#\(type)")
                                .font(.system(size: 14, weight: .medium, design: .default))
                                .foregroundColor(.orange)
                        }
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
                            Group {
                                Text("Количество скамов типа ")
                                    .font(.system(size: 14, weight: .medium, design: .default))
                                + Text("#\(type)")
                                    .font(.system(size: 14, weight: .medium, design: .default))
                                    .foregroundColor(.orange)
                            }
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
                            Group {
                                Text("Количество скамов типа ")
                                    .font(.system(size: 14, weight: .medium, design: .default))
                                + Text("#\(type)")
                                    .font(.system(size: 14, weight: .medium, design: .default))
                                    .foregroundColor(.orange)
                            }
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
                    BarChart(chartData: data)
                        .extraLine(chartData: data,
                                   legendTitle: "Test",
                                   datapoints: extraLineData,
                                   style: extraLineStyle)
                        .touchOverlay(chartData: data)
                        .xAxisGrid(chartData: data)
                        .yAxisGrid(chartData: data)
                        .xAxisLabels(chartData: data)
                        .extraYAxisLabels(chartData: data, colourIndicator: .style(size: 12))
                        .headerBox(chartData: data)
                        .id(data.id)
                        .frame(minWidth: screenSize.width * 0.9, maxWidth: screenSize.width * 0.9, minHeight: 150, idealHeight: 300, maxHeight: 300, alignment: .leading)
                        
                }
            
            .navigationBarTitle(Text("Статистика"))
            .navigationBarItems(leading: Text("\(title)"))
        }.environment(\.colorScheme, .dark)
    }
    private var extraLineData: [ExtraLineDataPoint] {
        [
            ExtraLineDataPoint(value: 200),
            ExtraLineDataPoint(value: 90),
            ExtraLineDataPoint(value: 700),
            ExtraLineDataPoint(value: 175),
            ExtraLineDataPoint(value: 60),
            ExtraLineDataPoint(value: 100),
            ExtraLineDataPoint(value: 600)
        ]
    }

    private var extraLineStyle: ExtraLineStyle {
        ExtraLineStyle(lineColour: ColourStyle(colour: .blue),
                       lineType: .curvedLine,
                       lineSpacing: .bar,
                       yAxisTitle: "Bob",
                       yAxisNumberOfLabels: 7,
                       animationType: .raise,
                       baseline: .zero)
    }
    
    static func weekOfData() -> BarChartData {
        let data: BarDataSet =
            BarDataSet(dataPoints: [
                BarChartDataPoint(value: 200, xAxisLabel: "Laptops"   , description: "Laptops"   , colour: ColourStyle(colour: .purple)),
                BarChartDataPoint(value: 90 , xAxisLabel: "Desktops"  , description: "Desktops"  , colour: ColourStyle(colour: .blue)),
                BarChartDataPoint(value: 700, xAxisLabel: "Phones"    , description: "Phones"    , colour: ColourStyle(colour: .green)),
                BarChartDataPoint(value: 175, xAxisLabel: "Tablets"   , description: "Tablets"   , colour: ColourStyle(colour: .orange)),
                BarChartDataPoint(value: 60 , xAxisLabel: "Watches"   , description: "Watches"   , colour: ColourStyle(colour: .yellow)),
            ],
            legendTitle: "Data")

        let metadata = ChartMetadata(title: "Общая сила скама", subtitle: "по неделям")

        let gridStyle = GridStyle(numberOfLines: 7,
                                   lineColour: Color(.lightGray).opacity(0.25),
                                   lineWidth: 1)

        let chartStyle = BarChartStyle(infoBoxPlacement: .header,
                                       markerType: .bottomLeading(),
                                       xAxisGridStyle: gridStyle,
                                       xAxisLabelPosition: .bottom,
                                       xAxisLabelsFrom: .dataPoint(rotation: .degrees(-90)),
                                       xAxisTitle: "Недели",
                                       yAxisGridStyle: gridStyle,
                                       yAxisLabelPosition: .leading,
                                       yAxisNumberOfLabels: 5,
                                       yAxisTitle: "Units sold (x 1000)",
                                       baseline: .zero,
                                       topLine: .maximumValue)

        return BarChartData(dataSets: data,
                            metadata: metadata,
                            xAxisLabels: ["One", "Two", "Three"],
                            barStyle: BarStyle(barWidth: 0.5,
                                               cornerRadius: CornerRadius(top: 10, bottom: 0),
                                               colourFrom: .dataPoints,
                                               colour: ColourStyle(colour: .blue)),
                            chartStyle: chartStyle)
    }
}

struct MoreDetailed_Previews: PreviewProvider {
    static var previews: some View {
        MoreDetailed(title: .constant(""), type: .constant(""), allPower: .constant(0.0), medianaPowerOfAll: .constant(0.0), medianaPowerSameType: .constant(0.0), mostFrequentTypeCount: .constant(0), mostFrequentType: .constant(""), sameTypeCount: .constant(0), last30dayPower: .constant(0), last30daySameTypeCount: .constant(0), medianaPowerOfLast30day: .constant(0.0), currentWeekSameTypeCount: .constant(0), currentWeekPower: .constant(0), previosOneWeekPower: .constant(0), previosTwoWeekPower: .constant(0), previosThreeWeekPower: .constant(0), previosFourWeekPower: .constant(0), previosFiveWeekPower: .constant(0))
    }
}
