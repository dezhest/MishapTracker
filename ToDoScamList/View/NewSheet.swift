//
//  AddView.swift
//  MyCash
//
//  Created by Денис Жестерев on 26.09.2022.
//

import SwiftUI

struct NewSheet: View {
    @Environment(\.presentationMode) private var presentationMode
    @Environment(\.dismiss) private var dismiss
    @State private var name = ""
    @State private var power: Double = 0
    @State private var selectedDate = Date()
    @State private var calendarId: Int = 0
    @State private var typeName = ""
    @State private var showsAlert = false
    @State private var showsAlertNameCount = false
    @State private var alertInput = ""
    @State private var imageData: Data = .init(capacity: 0)
    @State private var show = false
    @State private var imagePicker = false
    @State private var source: UIImagePickerController.SourceType = .photoLibrary
    @State private var selection = "None"
    @Environment(\.managedObjectContext) private var moc
    @FetchRequest(entity: Scam.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Scam.selectedDate, ascending: false)]) var users: FetchedResults<Scam>
    @State var types: [String] = [""]
    @State private var type = "Финансовый"
    var body: some View {
        ZStack {
            NavigationView {
                Form {
                    VStack {
                        TextField("Как вы заскамились?", text: $name)
                            .padding(10)
                        Spacer()
                        VStack(alignment: .leading) {
                            Text("Сила скама:")
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
                                            .offset(y: -7)
                                            .font(.system(size: 18, weight: .bold))
                                            .foregroundColor(.black)
                                            .alignmentGuide(HorizontalAlignment.leading) {
                                                $0[HorizontalAlignment.leading] - (geom.size.width - $0.width) * power / 10
                                            }
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                    }, alignment: .top)
                                VStack {
                                    Text("Max Scam")
                                        .font(.system(size: 12, weight: .medium, design: .default))
                                        .foregroundColor(.white)
                                        .padding(3)
                                        .background(Color(.red))
                                        .cornerRadius(20)
                                        .padding(.bottom, 3)
                                        .offset(y: -50)
                                    }
                                        .frame(maxWidth: .infinity, alignment: .topTrailing)
                                        .onTapGesture {
                                            self.power = 10
                                }
                            }
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
                                    .foregroundColor($0 == "Свой тип" ? .blue : $0 == "Очистить типы" ? .red : .black)
                            }
                        }
                        .onChange(of: type) { _ in
                            if type == "Свой тип" {
                                withAnimation(.spring()) {
                                    self.showsAlert.toggle()
                                }
                            }
                            if type == "Очистить типы" {
                                types = ["Эмоциональный", "Финансовый", "Свой тип", "Очистить типы"]
                                UserDefaults.standard.set(types, forKey: "types")
                                type = "Финансовый"
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
                            }) {
                                Image(uiImage: UIImage(data: self.imageData)!)
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 50, height: 50)
                                    .clipShape(Circle())
                            }
                        } else {
                            Button(action: {
                                self.show.toggle()
                            }) {
                                Image(systemName: "photo.fill")
                                    .resizable()
                                    .frame(width: 50, height: 50)
                                    .cornerRadius(5)
                                    .foregroundColor(.gray)
                            }
                            .confirmationDialog("Выберите фото скама", isPresented: self.$show, titleVisibility: .visible) {
                                Button("Камера") {
                                    self.source = .camera
                                    self.imagePicker.toggle()
                                }
                                Button("Галерея") {
                                    self.source = .photoLibrary
                                    self.imagePicker.toggle()
                                }
                            }
                        }
                    }
                }
                .navigationBarItems(trailing: Button("Сохранить") {
                    if name.count >= 30 || name.isEmpty {
                        self.showsAlertNameCount.toggle()
                    } else {
                        let userInfo = Scam(context: self.moc)
                        userInfo.type = self.type
                        userInfo.power = self.power
                        userInfo.selectedDate = self.selectedDate
                        userInfo.imageD = self.imageData
                        userInfo.title = self.name
                        do {
                            try self.moc.save()
                        } catch {
                            print("whoops \(error.localizedDescription)")
                        }
                        UserDefaults.standard.set(types, forKey: "types")
                        self.presentationMode.wrappedValue.dismiss()
                    }
                })
                .navigationBarTitle("Добавить скам")
                .onAppear {
                    types = UserDefaults.standard.stringArray(forKey: "types") ?? ["Эмоциональный", "Финансовый", "Свой тип", "Очистить типы"]
                }
                .alert(isPresented: self.$showsAlertNameCount) {
                    Alert(title: Text("Название скама не может быть пустым или превышать 30 символов"))
                }
            }
            AddType(title: "Добавьте тип", isShown: $showsAlert, text: $alertInput, onDone: {_ in
                if types.filter({$0 == alertInput}).count == 0 {
                    types.insert(alertInput, at: 0)
                    type = alertInput
                } else {
                    type = alertInput
                }
            }, onCancel: {
                type = types[types.count - 3]
            })
        }.environment(\.colorScheme, .light)
    }
    private func endEditing() {
        UIApplication.shared.endEditing()
    }
}

struct AddView_Previews: PreviewProvider {
    static var previews: some View {
        NewSheet()
    }
}
