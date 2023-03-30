//
//  AddView.swift
//  ToDoScamList
//
//  Created by Денис Жестерев on 26.09.2022.
//

import SwiftUI
import Combine

struct NewScamView: View {
    @StateObject var viewModel = NewScamViewModel()
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack {
            NavigationView {
                Form {
                    NewScamFormView()
                }
                .navigationBarItems(leading:  Button(action: { dismiss() }) {
                    Image(systemName: "chevron.left")
                        .backButton()
                }, trailing: Button("Сохранить") {
                    if viewModel.tryToSave() {
                        dismiss()
                    }
                })
                .navigationBarTitle("Добавить")
                .onAppear {
                    viewModel.onAppearSavedOrDefaultTypes()
                }
                .alert(isPresented: $viewModel.newScamModel.showsAlertNameCount) {
                    Alert(title: Text("Название не может быть пустым или превышать 30 символов"))
                }
            }
            if viewModel.newScamModel.showsAddCustomType {
                Text(" ")
                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
                    .background(Color.black)
                    .edgesIgnoringSafeArea(.all)
                    .opacity(0.8)
                    .onTapGesture{
                        viewModel.toggleAddCustomTypeIsShown()
                    }
            }
            AddCustomTypeView(title: "Добавьте тип", isShown: $viewModel.newScamModel.showsAddCustomType, text: $viewModel.newScamModel.alertInput, onDone: {_ in
                viewModel.checkSameTypes()
            }, onCancel: {
                viewModel.newScamModel.type = viewModel.newScamModel.types[viewModel.newScamModel.types.count - 3]
            })
        }
        .environment(\.colorScheme, .light)
        .environmentObject(viewModel)
    }
}

struct NewScamView_Previews: PreviewProvider {
    static var previews: some View {
        NewScamView()
    }
}
