//
//  AddView.swift
//  ToDoScamList
//
//  Created by Денис Жестерев on 26.09.2022.
//

import SwiftUI
import Combine

struct NewScam: View {
    @ObservedObject var form = AddNewScamForm()
    @Environment(\.presentationMode) var presentationMode
    @State private var showsAlertCustomType = false
    @State private var showsAlertNameCount = false
    @State private var alertInput = ""
    @State private var showImageDialog = false
    @State private var showsImagePicker = false
    @State private var source: UIImagePickerController.SourceType = .photoLibrary
    @Environment(\.managedObjectContext) private var moc
    let textLimit = 280
    var body: some View {
        ZStack {
            NavigationView {
                Form {
                  formAddScam()
                }
                .navigationBarItems(leading:  Button(action: { self.presentationMode.wrappedValue.dismiss() }) {
                    Image(systemName: "chevron.left")
                        .backButton()
                }, trailing: Button("Сохранить") {
                    if form.name.count >= 30 || form.name.isEmpty {
                        self.showsAlertNameCount.toggle()
                    } else {
                        saveToData()
                        self.presentationMode.wrappedValue.dismiss()
                    }
                })
                .navigationBarTitle("Добавить скам")
                .onAppear {
                    form.types = UserDefaults.standard.stringArray(forKey: "types") ?? ["Эмоциональный", "Финансовый", "Свой тип", "Очистить типы"]
                }
                .alert(isPresented: self.$showsAlertNameCount) {
                    Alert(title: Text("Название скама не может быть пустым или превышать 30 символов"))
                }
            }
            if showsAlertCustomType == true {
                Text(" ")
                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
                    .background(Color.black)
                    .edgesIgnoringSafeArea(.all)
                    .opacity(0.8)
                    .onTapGesture{
                        showsAlertCustomType = false
                    }
            }
            AddCustomType(title: "Добавьте тип", isShown: $showsAlertCustomType, text: $alertInput, onDone: {_ in
                if form.types.filter({$0 == alertInput}).count == 0 {
                    form.types.insert(alertInput, at: 0)
                    form.type = alertInput
                } else {
                    form.type = alertInput
                }
            }, onCancel: {
                form.type = form.types[form.types.count - 3]
            })
        }.environment(\.colorScheme, .light)
    }
    private func endEditing() {
        UIApplication.shared.endEditing()
    }
    func limitText(_ upper: Int) {
        if form.description.count > upper {
            form.description = String(form.description.prefix(upper))
        }
    }
    func saveToData() {
        let scamInfo = Scam(context: self.moc)
        scamInfo.type = form.type
        scamInfo.power = form.power
        scamInfo.selectedDate = form.selectedDate
        scamInfo.imageD = form.imageData
        scamInfo.title = form.name
        scamInfo.scamDescription = form.description
        do {
            try self.moc.save()
        } catch {
            print("whoops \(error.localizedDescription)")
        }
        UserDefaults.standard.set(form.types, forKey: "types")

    }
    @ViewBuilder
    private func formAddScam() -> some View {
        VStack {
            TextField("Название скама", text: $form.name)
                .padding(10)
                .padding(.top, 12)
            Spacer()
        }
        VStack {
            ZStack(alignment: .leading) {
                if form.description.isEmpty {
                    Text("Введите описание")
                        .font(.custom("Helvetica", size: 17))
                        .opacity(0.22)
                        .foregroundColor(.black)
                }
                TextEditor(text: $form.description)
                    .onReceive(Just(form.description)) { _ in limitText(textLimit) }
                    .font(.custom("Helvetica", size: 17))
                    .offset(x: 10)
                    .offset(x: -14)
            }
            .padding(15)
            .offset(x: -4)
        }
            VStack(alignment: .leading) {
                Text("Сила скама:")
                ZStack {
                    LinearGradient(
                        gradient: Gradient(colors: [.yellow, .red]),
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                    .mask(Slider(value: $form.power, in: 0...10))
                    Slider(value: $form.power, in: 0...10, step: 1)
                        .opacity(0.05)
                        .alignmentGuide(VerticalAlignment.center) { $0[VerticalAlignment.center]}
                        .padding(.top)
                        .overlay(GeometryReader { geom in
                            Text("\(form.power, specifier: "%.f")")
                                .offset(y: -7)
                                .font(.system(size: 18, weight: .bold))
                                .foregroundColor(.black)
                                .alignmentGuide(HorizontalAlignment.leading) {
                                    $0[HorizontalAlignment.leading] - (geom.size.width - $0.width) * form.power / 10
                                }
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }, alignment: .top)
                    VStack {
                        Text("Max Scam")
                            .foregroundColor(.white)
                            .padding(3)
                            .background(Color(.red))
                            .cornerRadius(20)
                            .padding(.bottom, 3)
                            .offset(y: -50)
                    }
                    .frame(maxWidth: .infinity, alignment: .topTrailing)
                    .onTapGesture {
                        form.power = 10
                    }
                }
            }
            .padding(.top, 7)
        VStack {
            DatePicker("Дата скама", selection: $form.selectedDate, displayedComponents: .date)
                .datePickerStyle(.automatic)
                .id(form.calendarId)
                .onChange(of: form.selectedDate, perform: { _ in
                    form.calendarId += 1
                })
        }
        VStack {
            Picker("Тип скама", selection: $form.type) {
                ForEach(form.types, id: \.self) {
                    Text($0)
                        .foregroundColor($0 == "Свой тип" ? .blue : $0 == "Очистить типы" ? .red : .black)
                }
            }
            .onChange(of: form.type) { _ in
                if form.type == "Свой тип" {
                    withAnimation(.spring()) {
                        self.showsAlertCustomType.toggle()
                    }
                }
                if form.type == "Очистить типы" {
                    form.types = ["Эмоциональный", "Финансовый", "Свой тип", "Очистить типы"]
                    UserDefaults.standard.set(form.types, forKey: "types")
                    form.type = "Финансовый"
                }
            }
        }
        VStack {
            HStack {
                Text("Фото скама")
                    .fullScreenCover(isPresented: $showsImagePicker) {
                        ImagePicker(show: $showsImagePicker, image: $form.imageData, source: source)
                    }
                Spacer()
                if form.imageData.count != 0 {
                    Image(uiImage: UIImage(data: form.imageData)!)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 50, height: 50)
                        .clipShape(Circle())
                        .onTapGesture {
                            self.showImageDialog.toggle()
                        }
                        .confirmationDialog("Выберите фото скама", isPresented: self.$showImageDialog, titleVisibility: .visible) {
                            Button("Камера") {
                                self.source = .camera
                                self.showsImagePicker.toggle()
                            }
                            Button("Галерея") {
                                self.source = .photoLibrary
                                self.showsImagePicker.toggle()
                            }
                        }
                } else {
                    Image(systemName: "photo.fill")
                        .resizable()
                        .frame(width: 50, height: 50)
                        .cornerRadius(5)
                        .foregroundColor(.gray)
                        .onTapGesture {
                            self.showImageDialog.toggle()
                        }
                        .confirmationDialog("Выберите фото скама", isPresented: self.$showImageDialog, titleVisibility: .visible) {
                            Button("Камера") {
                                self.source = .camera
                                self.showsImagePicker.toggle()
                            }
                            Button("Галерея") {
                                self.source = .photoLibrary
                                self.showsImagePicker.toggle()
                            }
                        }
                }
            }
        }
    }
    
}

struct AddView_Previews: PreviewProvider {
    static var previews: some View {
        NewScam()
    }
}
