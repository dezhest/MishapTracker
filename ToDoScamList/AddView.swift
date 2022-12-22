//
//  AddView.swift
//  MyCash
//
//  Created by Денис Жестерев on 26.09.2022.
//

import SwiftUI

struct AddView: View {
    @Environment(\.presentationMode) var presentationMode // для закрытия шита
    @Environment(\.managedObjectContext) var moc //core date
    @ObservedObject var expenses : Expenses
    @State private var name = ""
    @State private var amount: Double = 0
    @State private var selectedDate = Date()
    @State private var calendarId: Int = 0
    @State private var typeName = ""
    @State private var showsAlert = false
    @State private var alertInput = ""
    @State private var sourceType: UIImagePickerController.SourceType = .photoLibrary
    @State private var selectedImage: UIImage?
    @State private var isImagePickerDisplay = false
    @FetchRequest(entity: Scam.entity(), sortDescriptors: [NSSortDescriptor(keyPath:\Scam.selectedDate, ascending: false)]) var users: FetchedResults<Scam>
    @State var types: [String] = ["Эмоциональный", "Финансовый", "Свой тип"]
    @State private var type = "Финансовый"
    
    var body: some View {
        VStack {
            NavigationView {
                Form {
                    TextField("Что случилось?", text: $name)
                    
                    VStack(alignment: .leading) {
                        Text("Сила скама")
                        Slider(value: $amount, in: 0...10)
                        Text("\(Int(amount))")
                    }
                    DatePicker("Когда был скам?", selection: $selectedDate, displayedComponents: .date)
                        .datePickerStyle(.compact)
                        .id(calendarId)
                        .onChange(of: selectedDate, perform: { _ in
                          calendarId += 1
                        })
                        .onTapGesture {
                          calendarId += 1
                        }
                        
                    Picker("Тип", selection: $type) {
                        ForEach(types, id: \.self) {
                            Text($0)
                        }
                        //                        checkSelfType()
                    }
                    .onChange(of: type) { tag in print("Color tag: \(tag)");  checkSelfType()}
                    .alert("Добавить тип", isPresented: $showsAlert, actions: {
                        TextField("Тип скама", text: $alertInput)
                        Button("Добавить", action: {
                            types.insert(alertInput, at: 0)
                            type = alertInput
                            
                        })
                        Button("Отмена", role: .cancel, action: {})
                    }, message: {
                        Text("Пожалуйста введите ваш тип скама")
                    })
                }
                .navigationBarItems(trailing: Button("Сохранить"){
                    let userInfo = Scam(context: self.moc)
                    userInfo.name = self.name
                    userInfo.type = self.type
                    userInfo.amount = self.amount
                    userInfo.selectedDate = self.selectedDate
                    do {
                        try self.moc.save()
                    } catch {
                        print("whoops \(error.localizedDescription)")
                    }
                    UserDefaults.standard.set(types, forKey: "types")
                    self.presentationMode.wrappedValue.dismiss()
                })
                .navigationBarTitle("Добавить скам")
            }
            
            
            //            VStack {
            //
            //                if selectedImage != nil {
            //                    Image(uiImage: selectedImage!)
            //                        .resizable()
            //                        .aspectRatio(contentMode: .fit)
            //                        .clipShape(Circle())
            //                        .frame(width: 120, height: 120)
            //                } else {
            //                    Image(systemName: "snow")
            //                        .resizable()
            //                        .aspectRatio(contentMode: .fit)
            //                        .clipShape(Circle())
            //                        .frame(width: 120, height: 120)
            //                }
            //
            //                Button("Camera") {
            //                    self.sourceType = .camera
            //                    self.isImagePickerDisplay.toggle()
            //                }
            //
            //                Button("Photo") {
            //                    self.sourceType = .photoLibrary
            //                    self.isImagePickerDisplay.toggle()
            //                }.padding()
            //            }
            //            .sheet(isPresented: self.$isImagePickerDisplay) {
            //                ImagePickerView(selectedImage: self.$selectedImage, sourceType: self.sourceType)
            //            }
            
        }
        
        .onAppear{
            types = UserDefaults.standard.stringArray(forKey: "types") ?? ["Эмоциональный", "Финансовый", "Свой тип"]
        }
    }
    func showAlert() {
        self.showsAlert.toggle()
    }
    func checkSelfType() {
        if type == "Свой тип" {
            showAlert()
        }
    }
    
}


struct AddView_Previews: PreviewProvider {
    static var previews: some View {
        AddView(expenses: Expenses())
    }
}
