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
    @State var isAdded: Bool = false
    @Binding var text: String
    var onDone: (String) -> Void = { _ in }
    var onCancel: () -> Void = { }
    @Binding var amount: Double
   
    
    
    var body: some View {
        
        VStack(spacing: 20) {
            Text(title)
                .font(.system(size: 20, weight: .bold, design: .default))
                .foregroundColor(Color(.black))
            
                TextField("", text: $text)
                    .placeholder(when: text.isEmpty) {
                        Text("Название скама").foregroundColor(.gray)}
                    .padding(5)
                    .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.gray))
                    .background(Color(.white))
                    .foregroundColor(.black)
            VStack(alignment: .leading) {
                Text("Сила скама")
                Slider(value: $amount, in: 0...10)
                Text("\(Int(amount))")
            }

            
            HStack(spacing: 20) {
                Button("Отмена") {
                    self.isShown = false
                    self.onCancel()
                }
                .font(.system(size: 18, weight: .bold, design: .default))
                .foregroundColor(.red)
                Button("Добавить") {
                    if text != "" {
                        self.isShown = false}
                    isAdded = true
                    self.onDone(self.text)
                    UIApplication.shared.endEditing()
                }
                .font(.system(size: 18))
            }
        }
        .padding()
        .frame(width: screenSize.width * 0.92, height: screenSize.height * 0.35)
        .background(Color(.white))
        .clipShape(RoundedRectangle(cornerRadius: 20.0, style: .continuous))
        .offset(y: isShown ? 0 : screenSize.height)
        .animation(.spring())
        .shadow(radius: 6)
        
    }
}

struct EditScam_Previews: PreviewProvider {
    static var previews: some View {
        EditScam(title: "Внести изменения", isShown: .constant(true), text: .constant(""), amount: .constant(0.00))
    }
}
