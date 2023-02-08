//
//  AddView.swift
//  ToDoScamList
//
//  Created by Денис Жестерев on 26.09.2022.
//

import SwiftUI
import Combine

struct NewScam: View {
    @ObservedObject var form = NewScamViewModel()
    @Environment(\.dismiss) var dismiss

    
    var body: some View {
        ZStack {
            NavigationView {
                Form {
                  formAddScam()
                }
                .navigationBarItems(leading:  Button(action: { dismiss() }) {
                    Image(systemName: "chevron.left")
                        .backButton()
                }, trailing: Button("Сохранить") {
                    if form.saveScam() {
                        dismiss()
                        UserDefaults.standard.set(form.newScamModel.types, forKey: "typess")
                    }
                })
                .navigationBarTitle("Добавить скам")
                .onAppear {
                    form.newScamModel.types = UserDefaults.standard.stringArray(forKey: "typess") ?? ["Эмоциональный", "Финансовый", "Свой тип", "Очистить типы"]
                }
                .alert(isPresented: $form.newScamModel.showsAlertNameCount) {
                    Alert(title: Text("Название скама не может быть пустым или превышать 30 символов"))
                }
            }
            if form.newScamModel.showsAlertCustomType == true {
                Text(" ")
                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
                    .background(Color.black)
                    .edgesIgnoringSafeArea(.all)
                    .opacity(0.8)
                    .onTapGesture{
                        form.newScamModel.showsAlertCustomType = false
                    }
            }
            AddCustomType(title: "Добавьте тип", isShown: $form.newScamModel.showsAlertCustomType, text: $form.newScamModel.alertInput, onDone: {_ in
                form.customTypeOnDone()
            }, onCancel: {
                form.newScamModel.type = form.newScamModel.types[form.newScamModel.types.count - 3]
            })
        }.environment(\.colorScheme, .light)
    }
    
    @ViewBuilder
    private func formAddScam() -> some View {
        VStack {
            TextField("Название скама", text: $form.newScamModel.name)
                .padding(10)
                .padding(.top, 12)
            Spacer()
        }
        VStack {
            ZStack(alignment: .leading) {
                if form.newScamModel.description.isEmpty {
                    Text("Введите описание")
                        .font(.custom("Helvetica", size: 17))
                        .opacity(0.22)
                        .foregroundColor(.black)
                }
                TextEditor(text: $form.newScamModel.description)
                    .onReceive(Just(form.newScamModel.description)) { _ in form.limitText(form.textLimit) }
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
                    .mask(Slider(value: $form.newScamModel.power, in: 0...10))
                    Slider(value: $form.newScamModel.power, in: 0...10, step: 1)
                        .opacity(0.05)
                        .alignmentGuide(VerticalAlignment.center) { $0[VerticalAlignment.center]}
                        .padding(.top)
                        .overlay(GeometryReader { geom in
                            Text("\(form.newScamModel.power, specifier: "%.f")")
                                .offset(y: -7)
                                .font(.system(size: 18, weight: .bold))
                                .foregroundColor(.black)
                                .alignmentGuide(HorizontalAlignment.leading) {
                                    $0[HorizontalAlignment.leading] - (geom.size.width - $0.width) * form.newScamModel.power / 10
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
                        form.newScamModel.power = 10
                    }
                }
            }
            .padding(.top, 7)
        VStack {
            DatePicker("Дата скама", selection: $form.newScamModel.selectedDate, displayedComponents: .date)
                .datePickerStyle(.automatic)
                .id(form.newScamModel.calendarId)
                .onChange(of: form.newScamModel.selectedDate, perform: { _ in
                    form.newScamModel.calendarId += 1
                })
        }
        VStack {
            Picker("Тип скама", selection: $form.newScamModel.type) {
                ForEach(form.newScamModel.types, id: \.self) {
                    Text($0)
                        .foregroundColor($0 == "Свой тип" ? .blue : $0 == "Очистить типы" ? .red : .black)
                }
            }
            .onChange(of: form.newScamModel.type) { _ in
                if form.newScamModel.type == "Свой тип" {
                    withAnimation(.spring()) {
                        form.newScamModel.showsAlertCustomType.toggle()
                    }
                }
                if form.newScamModel.type == "Очистить типы" {
                    form.newScamModel.types = ["Эмоциональный", "Финансовый", "Свой тип", "Очистить типы"]
                    UserDefaults.standard.set(form.newScamModel.types, forKey: "typess")
                    form.newScamModel.type = "Финансовый"
                }
            }
        }
        VStack {
            HStack {
                Text("Фото скама")
                    .fullScreenCover(isPresented: $form.newScamModel.showsImagePicker) {
                        ImagePicker(show: $form.newScamModel.showsImagePicker, image: $form.newScamModel.imageData, source: form.newScamModel.source)
                    }
                Spacer()
                if form.newScamModel.imageData.count != 0 {
                    Image(uiImage: UIImage(data: form.newScamModel.imageData)!)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 50, height: 50)
                        .clipShape(Circle())
                        .onTapGesture {
                            form.newScamModel.showImageDialog.toggle()
                        }
                        .confirmationDialog("Выберите фото скама", isPresented: $form.newScamModel.showImageDialog, titleVisibility: .visible) {
                            Button("Камера") {
                                form.newScamModel.source = .camera
                                form.newScamModel.showsImagePicker.toggle()
                            }
                            Button("Галерея") {
                                form.newScamModel.source = .photoLibrary
                                form.newScamModel.showsImagePicker.toggle()
                            }
                        }
                } else {
                    Image(systemName: "photo.fill")
                        .resizable()
                        .frame(width: 50, height: 50)
                        .cornerRadius(5)
                        .foregroundColor(.gray)
                        .onTapGesture {
                            form.newScamModel.showImageDialog.toggle()
                        }
                        .confirmationDialog("Выберите фото скама", isPresented: $form.newScamModel.showImageDialog, titleVisibility: .visible) {
                            Button("Камера") {
                                form.newScamModel.source = .camera
                                form.newScamModel.showsImagePicker.toggle()
                            }
                            Button("Галерея") {
                                form.newScamModel.source = .photoLibrary
                                form.newScamModel.showsImagePicker.toggle()
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
