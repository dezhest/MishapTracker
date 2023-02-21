//
//  MoreDetailed.swift
//  ToDoScamList
//
//  Created by Денис Жестерев on 17.01.2023.
//

import SwiftUI
import FancyScrollView
import CoreData

struct MoreDetailedView: View {
    @EnvironmentObject var viewModel: MainViewModel
    let textLimit = 280
    let screenSize = UIScreen.main.bounds
    let coloredNavAppearance = UINavigationBarAppearance()
   
    var body: some View {
        ZStack {
            Text(" ")
                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
                .background(Color.black)
                .edgesIgnoringSafeArea(.all)
            FancyScrollView(title: viewModel.model.title,
                            headerHeight: 350,
                            scrollUpHeaderBehavior: .sticky,
                            scrollDownHeaderBehavior: .sticky,
                            header: { viewModel.getImage().resizable().aspectRatio(contentMode: .fill) }) {
                ZStack(alignment: .top) {
                    ZStack(alignment: .top) {
                        Text("Описание:")
                            .font(.system(size: 35, weight: .medium, design: .default))
                            .frame(maxWidth: .infinity, maxHeight: 0, alignment: .leading)
                            .padding(.leading, 20)
                            .padding(.top, 70)
                        if viewModel.model.description.isEmpty {
                            ZStack(alignment: .top) {
                                Text("Добавить описание")
                                    .font(.system(size: 20, weight: .medium, design: .default))
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .foregroundColor(.gray)
                                    .padding(.leading, 20)
                                Image(systemName: "pencil")
                                    .resizable()
                                    .frame(width: 20, height: 20)
                                    .foregroundColor(.blue)
                                    .frame(maxWidth: .infinity, alignment: .trailing)
                                    .padding(.trailing, 20)
                            }
                            .padding(.top, 120)
                            .onTapGesture {
                                viewModel.mDtoggleEditIsShown()
                            }
                        } else {
                            ZStack(alignment: .top) {
                                Text(viewModel.model.description)
                                    .font(.system(size: 19, weight: .medium, design: .default))
                                    .foregroundColor(.gray)
                                    .frame(maxWidth: .infinity, alignment: .topLeading)
                                    .padding(.leading, 20)
                                Image(systemName: "pencil")
                                    .resizable()
                                    .frame(width: 20, height: 20)
                                    .foregroundColor(.blue)
                                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
                                    .padding(.trailing, 30)
                                    .offset(y: -30)
                                    .onTapGesture {
                                        viewModel.model.mDeditInput = viewModel.model.description
                                        viewModel.mDtoggleEditIsShown()
                                    }
                            }
                            .padding(.top, 120)
                        }
                        Text("Yo")
                            .opacity(0)
                            .padding(.top, 750)
                    }
                }
                .frame(maxHeight: .infinity)
            }
                            .fullScreenCover(isPresented: $viewModel.model.statIsShown) {
                                StatisticsView()}
            if viewModel.mDeditIsShown == true {
                Text(" ")
                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
                    .background(Color.black)
                    .edgesIgnoringSafeArea(.all)
                    .opacity(0.8)
                    .onTapGesture{
                        viewModel.mDeditIsShown = false
                    }
            }
            EditDescriptionView(isShown: $viewModel.mDeditIsShown, isCanceled: $viewModel.model.mDeditIsCanceled, text: $viewModel.model.mDeditInput)
            if !viewModel.mDeditIsShown {
                Text("Статистика")
                    .foregroundColor(.white)
                    .font(.system(size: 18, weight: .bold, design: .default))
                    .frame(width: 180, height: 5)
                    .foregroundColor(.white)
                    .padding()
                    .background(Color(.orange))
                    .cornerRadius(20)
                    .onTapGesture {
                        viewModel.model.statIsShown.toggle()
                    }
                    .frame(maxHeight: screenSize.height, alignment: .bottom)
                    .offset(y: -20)
            }
        }
        .environment(\.colorScheme, .dark)
    }
}

struct MoreDetailedView_Previews: PreviewProvider {
    static var previews: some View {
        MoreDetailedView()
    }
}
