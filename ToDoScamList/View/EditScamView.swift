//
//  EditScam.swift
//  ToDoScamList
//
//  Created by Денис Жестерев on 28.12.2022.
//

import Foundation
import SwiftUI

struct EditScamView: View {
    let screenSize = UIScreen.main.bounds
    @Binding var isShown: Bool
    @Binding var isCanceled: Bool
    @Binding var text: String
    var onDone: (String) -> Void = { _ in }
    var onCancel: () -> Void = { }
    @Binding var power: Double
    @State private var alertTextCountError = false
    var body: some View {
        VStack {
            ZStack {
                Text("Редактировать")
                    .fontWeight(.bold)
                    .font(.system(size: 18))
                    .frame(width: screenSize.width * 0.92, height: 15)
                    .foregroundColor(.white)
                    .padding()
                    .background(Color(.orange))
                    .cornerRadius(10)
                .offset(y: -17)
            }
            TextField("", text: $text)
                .placeholder(when: text.isEmpty) {
                    Text("Название события").foregroundColor(.gray)}
                .padding(10)
                .overlay(RoundedRectangle(cornerRadius: 20).stroke(Color.gray))
                .background(Color(.white))
                .foregroundColor(.black)
                .offset(y: -7)
            VStack {
                ZStack {
                    LinearGradient(
                        gradient: Gradient(colors: [.yellow, .red]),
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                    .mask(Slider(value: $power, in: 0...10))
                    Slider(value: $power, in: 0...10, step: 1)
                        .opacity(0.05)
                        .alignmentGuide(VerticalAlignment.center) { $0[VerticalAlignment.center]}
                        .padding(.top)
                        .overlay(GeometryReader { geom in
                            Text("\(power, specifier: "%.f")")
                                .offset(y: -10)
                                .font(.system(size: 18, weight: .bold))
                                .foregroundColor(.black)
                                .alignmentGuide(HorizontalAlignment.leading) {
                                    $0[HorizontalAlignment.leading] - (geom.size.width - $0.width) * power / 10
                                }
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }, alignment: .top)
                }
                Button("Сохранить и выйти") {
                    if text.count > 30 {
                        self.alertTextCountError.toggle()
                    } else {
                        self.isShown = false
                        self.onDone(self.text)
                        UIApplication.shared.endEditing()
                    }
                }
                .font(.system(size: 18))
                .frame(width: 180, height: 5)
                .foregroundColor(.white)
                .padding()
                .background(Color(.orange))
                .cornerRadius(20)
            }
        }
        .padding()
        .frame(width: 300, height: 250)
        .background(Color(.white))
        .clipShape(RoundedRectangle(cornerRadius: 20.0, style: .continuous))
        .offset(y: isShown ? 0 : screenSize.height * 2)
        .shadow(radius: 6)
        .alert(isPresented: $alertTextCountError) {
            Alert(title: Text("Длина типа не может превышать 30 символов"))
        }
    }
}

struct EditScamView_Previews: PreviewProvider {
    static var previews: some View {
        EditScamView(isShown: .constant(true), isCanceled: .constant(false), text: .constant(""), power: .constant(0.00))
    }
}
