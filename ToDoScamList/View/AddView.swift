//
//  AddView.swift
//  MyCash
//
//  Created by Денис Жестерев on 26.09.2022.
//

import SwiftUI


struct AddView: View {
    @Environment(\.presentationMode) private var presentationMode
    @Environment(\.dismiss) private var dismiss
    @State private var name = ""
    @State private var power: Double = 0
    @State private var selectedDate = Date()
    @State private var calendarId: Int = 0
    @State private var typeName = ""
    @State private var showsAlert = false
    @State private var alertInput = ""
    @State private var imageData: Data = .init(capacity: 0)
    @State private var show = false
    @State private var imagePicker = false
    @State private var source: UIImagePickerController.SourceType = .photoLibrary
    @Environment(\.managedObjectContext) private var moc
    @FetchRequest(entity: Scam.entity(), sortDescriptors: [NSSortDescriptor(keyPath:\Scam.selectedDate, ascending: false)]) var users: FetchedResults<Scam>
    @State var types: [String] = ["Эмоциональный", "Финансовый", "Свой тип"]
    @State private var type = "Финансовый"
    
    
    var body: some View {
        
        ZStack {
            NavigationView {
                Form {
                    VStack {
                        TextField("Как вы заскамились?", text: $name)
                            .padding()
                        Spacer()
                        VStack(alignment: .leading) {
                            Text("Сила скама")
                            Slider(value: $power, in: 0...10)
                            Text("\(Int(power))")
                        }
                        DatePicker("Когда был скам?", selection: $selectedDate, displayedComponents: .date)
                            .datePickerStyle(.automatic)
                            .id(calendarId)
                            .onChange(of: selectedDate, perform: { _ in
                                calendarId += 1
                            })
                        Spacer()
                    }
                    VStack {
                        Picker("Тип", selection: $type) {
                            ForEach(types, id: \.self) {
                                Text($0)
                            }
                        }
                        .onChange(of: type) { tag in print("Color tag: \(tag)");
                            if type == "Свой тип" {
                                self.showsAlert.toggle()
                            }
                        }
                    }
                    
                    HStack {
                        Text("Фото скама")
                            .fullScreenCover(isPresented: $imagePicker) {
                                ImagePicker(show: $imagePicker, image: $imageData, source: source)
                            } 
                        Spacer()
                        if imageData.count != 0 {
                            Button(action: {
                                self.show.toggle()
                            }){
                                Image(uiImage: UIImage(data: self.imageData)!)
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 50, height: 50)
                                    .clipShape(Circle())
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
                    userInfo.type = self.type
                    userInfo.power = self.power
                    userInfo.selectedDate = self.selectedDate
                    userInfo.imageD = self.imageData
                    userInfo.name = self.name
                    do {
                        try self.moc.save()
                    } catch {
                        print("whoops \(error.localizedDescription)")
                    }
                    UserDefaults.standard.set(types, forKey: "types")
                    self.presentationMode.wrappedValue.dismiss()
                    
                })
                .navigationBarTitle("Добавить скам")
                
                .onAppear{
                    types = UserDefaults.standard.stringArray(forKey: "types") ?? ["Эмоциональный", "Финансовый", "Свой тип"]
                }
                
                .actionSheet(isPresented: self.$show){
                    ActionSheet(title: Text("Сделайте фото скама или выберите из галереи"), message: Text(""), buttons:
                                    [.default(Text("Галерея"), action: {
                        self.source = .photoLibrary
                        self.imagePicker.toggle()
                    }),.default(Text("Камера"), action: {
                        self.source = .camera
                        self.imagePicker.toggle()
                    })
                                    ])
                }
            }
            AZalert(title: "Добавьте тип", isShown: $showsAlert, text: $alertInput, onDone: {_ in
                if alertInput != ""{
                    types.insert(alertInput, at: 0)
                }
                type = alertInput
            })
        }
        
        
        
    }
}

struct AddView_Previews: PreviewProvider {
    static var previews: some View {
        AddView()
    }
}
