//
//  AZalert.swift
//  ToDoScamList
//
//  Created by Денис Жестерев on 22.12.2022.
//

import SwiftUI

extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil) // для закрытия клавы коки
    }
}

struct AZalert: View {
    let screenSize = UIScreen.main.bounds
    var title: String = ""
    @Binding var isShown: Bool
    @Binding var text: String
    var onDone: (String) -> Void = { _ in }
    var onCancel: () -> Void = { }
    
    
    var body: some View {
        
        VStack(spacing: 20) {
            Text(title)
                .font(.system(size: 20, weight: .bold, design: .default))
                .foregroundColor(Color(.black))
            TextField("Введите свой тип", text: $text)
//                .background(Color(.white))
                .textFieldStyle(RoundedBorderTextFieldStyle())
            HStack(spacing: 20) {
                Button("Отмена") {
                    self.isShown = false
                    self.onCancel()
                }
                .font(.system(size: 18))
                .foregroundColor(.red)
                Button("Добавить") {
                    if text != "" {
                        self.isShown = false}
                    self.onDone(self.text)
                    UIApplication.shared.endEditing()
                }
                .font(.system(size: 18, weight: .bold, design: .default))
            }
        }
        .padding()
        .frame(width: screenSize.width * 0.65, height: screenSize.height * 0.25)
        .background(Color(#colorLiteral(red: 0.9268686175, green: 0.9416290522, blue: 0.9456014037, alpha: 1)))
        .clipShape(RoundedRectangle(cornerRadius: 20.0, style: .continuous))
        .offset(y: isShown ? 0 : screenSize.height)
        .animation(.spring())
        .shadow(radius: 6, x: 9, y: 9)
        
    }
}

struct AZAlert_Previews: PreviewProvider {
    static var previews: some View {
        AZalert(title: "Добавьте тип", isShown: .constant(true), text: .constant(""))
    }
}
