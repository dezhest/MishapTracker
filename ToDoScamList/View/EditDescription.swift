//
//  DescriptionEdit.swift
//  ToDoScamList
//
//  Created by Denis Zhesterev on 27.01.2023.
//

import SwiftUI
import Foundation
import Combine

struct EditDescription: View {
    let screenSize = UIScreen.main.bounds
    @Binding var isShown: Bool
    @Binding var isCanceled: Bool
    @Binding var text: String
    var onDone: (String) -> Void = { _ in }
    var onCancel: () -> Void = { }
    @State private var alertTextCountError = false
    let textLimit = 280
    var body: some View {
        VStack {
            ZStack {
                Text("Редактировать описание")
                    .fontWeight(.bold)
                    .font(.system(size: 18))
                    .frame(width: screenSize.width * 0.92, height: 15)
                    .foregroundColor(.white)
                    .padding()
                    .background(Color(.orange))
                    .cornerRadius(10)
                .offset(y: -17)
            }
            VStack {
                ZStack(alignment: .leading) {
                    TextEditor(text: $text)
                        .onReceive(Just(text)) { _ in limitText(textLimit) }
                        .font(.custom("Helvetica", size: 17))
                        .offset(x: 10)
                        .padding(5)

                    if text.isEmpty {
                        Text("Введите описание")
                            .font(.custom("Helvetica", size: 17))
                            .opacity(0.22)
                            .foregroundColor(.black)
                            .offset(x: 20, y: -45)
                    }
                }
                .overlay(
                         RoundedRectangle(cornerRadius: 25)
                           .stroke(Color.gray)
                         )
                .padding(5)
            }
            VStack {
                Button("Сохранить и выйти") {
                        self.isShown = false
                        self.onDone(self.text)
                        UIApplication.shared.endEditing()
                }
                .font(.system(size: 18))
                .frame(width: 180, height: 5)
                .foregroundColor(.white)
                .padding()
                .background(Color(.orange))
                .cornerRadius(20)
            }
        }
        .environment(\.colorScheme, .light)
        .padding()
        .frame(width: screenSize.width * 0.92, height: 280)
        .background(Color(.white))
        .clipShape(RoundedRectangle(cornerRadius: 20.0, style: .continuous))
        .offset(y: isShown ? 0 : screenSize.height)
        .shadow(radius: 6)
        .alert(isPresented: $alertTextCountError) {
            Alert(title: Text("Длина типа не может превышать 30 символов"))
        }
    }
    func limitText(_ upper: Int) {
        if text.count > upper {
            text = String(text.prefix(upper))
        }
    }
}

struct DescriptionEdit_Previews: PreviewProvider {
    static var previews: some View {
        EditDescription(isShown: .constant(true), isCanceled: .constant(false), text: .constant(""))
    }
}
