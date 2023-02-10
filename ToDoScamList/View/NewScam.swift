//
//  AddView.swift
//  ToDoScamList
//
//  Created by Денис Жестерев on 26.09.2022.
//

import SwiftUI
import Combine

struct NewScam: View {
    @StateObject var viewModel = NewScamViewModel()
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
                    viewModel.tryToSave()
                })
                .navigationBarTitle("Добавить скам")
                .onAppear {
                    viewModel.onAppearSavedOrDefaultTypes()
                }
                .alert(isPresented: $viewModel.newScamModel.showsAlertNameCount) {
                    Alert(title: Text("Название скама не может быть пустым или превышать 30 символов"))
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
            AddCustomType(title: "Добавьте тип", isShown: $viewModel.newScamModel.showsAddCustomType, text: $viewModel.newScamModel.alertInput, onDone: {_ in
                viewModel.checkSameTypes()
            }, onCancel: {
                viewModel.newScamModel.type = viewModel.newScamModel.types[viewModel.newScamModel.types.count - 3]
            })
        }.environment(\.colorScheme, .light)
//            .onAppear {
//                self.viewModel.performBusinessLogic()
//            }
            .onReceive(viewModel.viewDismissal) { shouldDismiss in
                if shouldDismiss {
                    dismiss()
                }
            }
    }
    
    @ViewBuilder
    private func formAddScam() -> some View {
        VStack {
            TextField("Название скама", text: $viewModel.newScamModel.name)
                .padding(10)
                .padding(.top, 12)
            Spacer()
        }
        VStack {
            ZStack(alignment: .leading) {
                if viewModel.newScamModel.description.isEmpty {
                    Text("Введите описание")
                        .font(.custom("Helvetica", size: 17))
                        .opacity(0.22)
                        .foregroundColor(.black)
                }
                TextEditor(text: $viewModel.newScamModel.description)
                    .onReceive(Just(viewModel.newScamModel.description)) { _ in viewModel.limitText(viewModel.textLimit) }
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
                .mask(Slider(value: $viewModel.newScamModel.power, in: 0...10))
                Slider(value: $viewModel.newScamModel.power, in: 0...10, step: 1)
                    .opacity(0.05)
                    .alignmentGuide(VerticalAlignment.center) { $0[VerticalAlignment.center]}
                    .padding(.top)
                    .overlay(GeometryReader { geom in
                        Text("\(viewModel.newScamModel.power, specifier: "%.f")")
                            .offset(y: -7)
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(.black)
                            .alignmentGuide(HorizontalAlignment.leading) {
                                $0[HorizontalAlignment.leading] - (geom.size.width - $0.width) * viewModel.newScamModel.power / 10
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
                    viewModel.newScamModel.power = 10
                }
            }
        }
        .padding(.top, 7)
        VStack {
            DatePicker("Дата скама", selection: $viewModel.newScamModel.selectedDate, displayedComponents: .date)
                .datePickerStyle(.automatic)
                .id(viewModel.newScamModel.calendarId)
                .onChange(of: viewModel.newScamModel.selectedDate, perform: { _ in
                    viewModel.newScamModel.calendarId += 1
                })
        }
        VStack {
            Picker("Тип скама", selection: $viewModel.newScamModel.type) {
                ForEach(viewModel.newScamModel.types, id: \.self) {
                    Text($0)
                        .foregroundColor($0 == "Свой тип" ? .blue : $0 == "Очистить типы" ? .red : .black)
                }
            }
            .onChange(of: viewModel.newScamModel.type) { _ in
                viewModel.customTypeTapped()
                viewModel.clearTypeTapped()
            }
        }
        VStack {
            HStack {
                Text("Фото скама")
                    .fullScreenCover(isPresented: $viewModel.newScamModel.showsImagePicker) {
                        ImagePicker(show: $viewModel.newScamModel.showsImagePicker, image: $viewModel.newScamModel.imageData, source: viewModel.newScamModel.source)
                    }
                Spacer()
                if viewModel.newScamModel.imageData.count != 0 {
                    Image(uiImage: UIImage(data: viewModel.newScamModel.imageData)!)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 50, height: 50)
                        .clipShape(Circle())
                        .onTapGesture {
                            viewModel.newScamModel.showImageDialog.toggle()
                        }
                        .confirmationDialog("Выберите фото скама", isPresented: $viewModel.newScamModel.showImageDialog, titleVisibility: .visible) {
                            Button("Камера") {
                                viewModel.newScamModel.source = .camera
                                viewModel.newScamModel.showsImagePicker.toggle()
                            }
                            Button("Галерея") {
                                viewModel.newScamModel.source = .photoLibrary
                                viewModel.newScamModel.showsImagePicker.toggle()
                            }
                        }
                } else {
                    Image(systemName: "photo.fill")
                        .resizable()
                        .frame(width: 50, height: 50)
                        .cornerRadius(5)
                        .foregroundColor(.gray)
                        .onTapGesture {
                            viewModel.newScamModel.showImageDialog.toggle()
                        }
                        .confirmationDialog("Выберите фото скама", isPresented: $viewModel.newScamModel.showImageDialog, titleVisibility: .visible) {
                            Button("Камера") {
                                viewModel.newScamModel.source = .camera
                                viewModel.newScamModel.showsImagePicker.toggle()
                            }
                            Button("Галерея") {
                                viewModel.newScamModel.source = .photoLibrary
                                viewModel.newScamModel.showsImagePicker.toggle()
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
