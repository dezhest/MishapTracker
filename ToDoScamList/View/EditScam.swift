//
//  EditScam.swift
//  ToDoScamList
//
//  Created by Денис Жестерев on 28.12.2022.
//

import Foundation
import SwiftUI

struct EditScam: View {

    let screenSize = UIScreen.main.bounds
    var title: String = ""
    @Binding var isShown: Bool
    @Binding var isCanceled: Bool
    @Binding var text: String
    var onDone: (String) -> Void = { _ in }
    var onCancel: () -> Void = { }
    @Binding var power: Double

    var body: some View {

        VStack {
            Text("Внести изменения")
                .font(.system(size: 20, weight: .bold, design: .default))
                .foregroundColor(Color(.black))

            TextField("", text: $text)
                .placeholder(when: text.isEmpty) {
                    Text("Название скама").foregroundColor(.gray)}
                .padding(5)
                .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.gray))
                .background(Color(.white))
                .foregroundColor(.black)

            VStack {
                Text("Сила скама")
                    .foregroundColor(.black)
                Slider(value: $power, in: 0...10)
                Text("\(Int(power))")
                    .font(.system(size: 25, weight: .bold))
                    .foregroundColor(.black)
            }
                Button("Сохранить и выйти") {
                    if text != "" {
                        self.isShown = false}
                    self.onDone(self.text)
                    UIApplication.shared.endEditing()
                }
                .font(.system(size: 18))
        }
        .padding()
        .frame(width: screenSize.width * 0.92, height: 260)
        .background(Color(.white))
        .clipShape(RoundedRectangle(cornerRadius: 20.0, style: .continuous))
        .offset(y: isShown ? 0 : screenSize.height)
        .animation(.spring())
        .shadow(radius: 6)

    }
}

struct EditScam_Previews: PreviewProvider {
    static var previews: some View {
        EditScam(title: "Внести изменения", isShown: .constant(true), isCanceled: .constant(false), text: .constant(""), power: .constant(0.00))
    }
}
