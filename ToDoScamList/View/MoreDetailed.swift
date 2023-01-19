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
    var body: some View {
        VStack {
            Text(title)
            Group{
                Text("Общая сила скама - \(allPower)")
                Text("Средняя сила - \(medianaPowerOfAll)")
                Text("Средняя сила таких же типов - \(medianaPowerSameType)")
                Text("Самый популярный в этом типе - \(mostFrequentType), используется: \(mostFrequentTypeCount) раз")
            }
            Group{
                Text("Общая сила за последние 30 дней - \(last30dayPower)")
                Text("Вы скамились в этом типе за последние 30 дней - \(last30daySameTypeCount)")
                Text("Средняя сила скама за последние 30 дней - \(medianaPowerOfLast30day)")
            }
            Group {
                Text("На этой неделе в этом типе вы скамились - \(currentWeekSameTypeCount)")
                Text("Общая сила на этой неделе - \(currentWeekPower)")
            }
        }
    }
}

struct MoreDetailed_Previews: PreviewProvider {
    static var previews: some View {
        MoreDetailed(title: .constant(""), allPower: .constant(0.0), medianaPowerOfAll: .constant(0.0), medianaPowerSameType: .constant(0.0), mostFrequentTypeCount: .constant(0), mostFrequentType: .constant(""), last30dayPower: .constant(0), last30daySameTypeCount: .constant(0), medianaPowerOfLast30day: .constant(0.0), currentWeekSameTypeCount: .constant(0), currentWeekPower: .constant(0), previosOneWeekPower: .constant(0), previosTwoWeekPower: .constant(0), previosThreeWeekPower: .constant(0), previosFourWeekPower: .constant(0), previosFiveWeekPower: .constant(0))
    }
}
