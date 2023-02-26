//
//  CardScamView.swift
//  ToDoScamList
//
//  Created by Denis Zhesterev on 20.02.2023.
//

import SwiftUI

struct CardScamView: View {
    let powerColor = PowerColor()
    var body: some View {
        Text("")
    }
    @ViewBuilder
   func cardScamView(item: ScamCoreData) -> some View {
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
                        .background(powerColor.chooseColor(power: Int(item.power)))
                        .cornerRadius(20)
                        .padding(.bottom, 3)
                        .frame(maxWidth: .infinity, maxHeight: 60, alignment: .leading)
                    Text("\(item.selectedDate, format: Date.FormatStyle(date: .numeric, time: .omitted))")
                        .font(.system(size: 10, weight: .medium, design: .default))
                        .padding(3)
                        .padding(.bottom, -1)
                        .foregroundColor(.gray)
                        .opacity(0.7)
                        .frame(maxHeight: .infinity, alignment: .bottomTrailing)
                        .offset(x: -50, y: -1)
                }
            }
//            .frame(maxWidth: .infinity, maxHeight: 60, alignment: .leading)
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

struct CardScamView_Previews: PreviewProvider {
    static var previews: some View {
        CardScamView()
    }
}
