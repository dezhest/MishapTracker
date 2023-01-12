//
//  AZalert.swift
//  ToDoScamList
//
//  Created by Денис Жестерев on 22.12.2022.
//

import SwiftUI

extension View {
    func placeholder<Content: View>(
        when shouldShow: Bool,
        alignment: Alignment = .leading,
        @ViewBuilder placeholder: () -> Content) -> some View {

        ZStack(alignment: alignment) {
            placeholder().opacity(shouldShow ? 1 : 0)
            self
        }
    }
}

struct AZalert: View {
    enum FocusedField: Hashable {
            case text
        }

    let screenSize = UIScreen.main.bounds
    var title: String = ""
    @Binding var isShown: Bool
    @Binding var text: String
    var onDone: (String) -> Void = { _ in }
    var onCancel: () -> Void = { }

    var body: some View {

        VStack(spacing: 25) {
            ZStack {
                Text("Редактировать")
                    .fontWeight(.bold)
                    .font(.system(size: 18))
                    .frame(width: screenSize.width * 0.92, height: 15)
                    .foregroundColor(.white)
                    .padding()
                    .background(Color(.systemBlue))
                    .cornerRadius(10)
                .offset(y: -20)
            }

                TextField("", text: $text)
                    .placeholder(when: text.isEmpty) {
                        Text("Введите свой тип").foregroundColor(.gray)}
                    .padding(5)
                    .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.gray))
                    .background(Color(.white))
                    .foregroundColor(.black)

            HStack(spacing: 80) {
                Button("Отмена") {
                    self.isShown = false
                    self.onCancel()
                }
                .font(.system(size: 18, weight: .bold, design: .default))
                .foregroundColor(.red)
                Button("Добавить") {
                    if text != "" {
                        self.isShown = false}
                    self.onDone(self.text)
                    UIApplication.shared.endEditing()
                }
                .font(.system(size: 18))
            }
        }
        .padding()
        .frame(width: screenSize.width * 0.92, height: 180)
        .background(Color(.white))
        .clipShape(RoundedRectangle(cornerRadius: 20.0, style: .continuous))
        .offset(y: isShown ? 0 : screenSize.height)
        .shadow(radius: 6)

    }
}

struct AZAlert_Previews: PreviewProvider {
    static var previews: some View {
        AZalert(title: "", isShown: .constant(true), text: .constant(""))
    }
}
