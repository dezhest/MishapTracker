//
//  AddView.swift
//  MyCash
//
//  Created by Денис Жестерев on 26.09.2022.
//

import SwiftUI


struct AddView: View {
    @Environment(\.presentationMode) private var presentationMode // для закрытия шита
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var expenses : Expenses
    @State private var name = ""
    @State private var amount: Double = 0
    @State private var selectedDate = Date()
    @State private var calendarId: Int = 0
    @State private var typeName = ""
    @State private var showsAlert = false
    @State private var alertInput = ""
    @State private var sourceType: UIImagePickerController.SourceType = .photoLibrary
    @State private var image: Data = .init(count: 0)
    @State private var isImagePickerDisplay = false
    @State private var show: Bool = false // show image
    @Environment(\.managedObjectContext) private var moc //core date
    @FetchRequest(entity: Scam.entity(), sortDescriptors: [NSSortDescriptor(keyPath:\Scam.selectedDate, ascending: false)]) var users: FetchedResults<Scam>
    @State var types: [String] = ["Эмоциональный", "Финансовый", "Свой тип"]
    @State private var type = "Финансовый"
    
    
    var body: some View {
        ZStack {
            VStack {
                NavigationView {
                    Form {
                        VStack {
                            TextField("Что случилось?", text: $name) 
                            Spacer()
                            VStack(alignment: .leading) {
                                Text("Сила скама")
                                Slider(value: $amount, in: 0...10)
                                Text("\(Int(amount))")
                            }
                            DatePicker("Когда был скам?", selection: $selectedDate, displayedComponents: .date)
                                .datePickerStyle(.automatic)
                                .id(calendarId)
                                .onChange(of: selectedDate, perform: { _ in
                                    calendarId += 1
                                })
                                Spacer()
                            Picker("Тип", selection: $type) {
                                ForEach(types, id: \.self) {
                                    Text($0)
                                }
                            }
                            .onChange(of: type) { tag in print("Color tag: \(tag)");  checkSelfType()}
                        }
                        HStack {
                            Text("Фото скама")
                            Spacer()
                            if self.image.count != 0 {
                                Button(action: {
                                    self.show.toggle()
                                }){
                                    Image(uiImage: UIImage(data: self.image)!)
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 100, height: 100)
                                        .cornerRadius(20)
                                        .shadow(radius: 8, x: 5, y: 5)
                                        .padding()
                                }
                            } else {
                                Button(action: {
                                    self.show.toggle()
                                }) {
                                    Image(systemName: "photo.fill")
                                        .resizable()
                                        .frame(width: 30, height: 30)
                                        .cornerRadius(5)
                                        .shadow(radius: 8, x: 5, y: 5)
                                        .foregroundColor(.gray)
                                }
                            }
                        }
                    }
                    .navigationBarItems(trailing: Button("Сохранить"){
                        let userInfo = Scam(context: self.moc)
                        userInfo.name = self.name
                        userInfo.type = self.type
                        userInfo.amount = self.amount
                        userInfo.selectedDate = self.selectedDate
                        userInfo.imageD = self.image
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
                    .sheet(isPresented: self.$show){
                        ImagePicker(images: self.$image, show: self.$show)
                    }
                .onAppear{
                    types = UserDefaults.standard.stringArray(forKey: "types") ?? ["Эмоциональный", "Финансовый", "Свой тип"]
                }
                .gesture(DragGesture().onChanged{_ in UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)}) // для закрытия клавы коки при прокручивании навигатион вью
            }
            AZalert(title: "Добавьте тип", isShown: $showsAlert, text: $alertInput, onDone: {_ in
                if alertInput != ""{
                    types.insert(alertInput, at: 0)
                }
                type = alertInput
            })
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
