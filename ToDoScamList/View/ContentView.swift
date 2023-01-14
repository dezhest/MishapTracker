//
//  ContentView.swift
//  ToDoScamList
//
//  Created by Денис Жестерев on 16.12.2022.
//

import SwiftUI
import CoreData

struct ContentView: View {
    // MARK: — Private properties
    @ObservedObject var scams = Scams()
    @State private var showingAddExpense = false
    @State var pickerSelection: Int = 1
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(entity: Scam.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Scam.selectedDate, ascending: false)]) var entity: FetchedResults<Scam>
    @State private var image: Data = .init(count: 0)
    @GestureState private var scale: CGFloat = 1.0
    @State private var editIsShown = false
    @State private var editIsCanceled = false
    @State private var editIsAdded = false
    @State private var editInput = ""
    @State private var editpower: Double = 0
    @State private var editOnChanged = false
    @State private var indexOfEditScam = -1
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.dateFormat = "dd.MM.yy"
        return formatter
    }()
    var sortedScams: [Scam] {
        switch pickerSelection {
        case(1): return entity.sorted(by: {$0.selectedDate > $1.selectedDate})
        case(2): return entity.sorted(by: {$0.title < $1.title})
        case(3): return entity.sorted(by: {$0.power > $1.power})
        default: return []
        }
    }
    var body: some View {
        ZStack {
            NavigationView {
                List {
                    ForEach(sortedScams, id: \.self) { item in
                        NavigationLink(destination: Image(uiImage: UIImage(data: item.imageD ?? Data()) ?? UIImage())
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .pinchToZoom
                        ) {
                                ZStack {
                                    Image(uiImage: UIImage(data: item.imageD ?? self.image) ?? UIImage())
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: 60, height: 60)
                                        .clipShape(Circle())
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                    VStack(alignment: .leading, spacing: 5) {
                                        Text(item.title)
                                            .font(.system(size: 14, weight: .bold, design: .default))
                                        Text("#\(item.type)")
                                            .font(.system(size: 10, weight: .medium, design: .default))
                                            .opacity(0.6)
                                        Text("\(Int(item.power))/10 скамов")
                                            .font(.system(size: 12, weight: .medium, design: .default))
                                            .foregroundColor(.black)
                                            .padding(3)
                                            .background(colorOfPower(power: Int(item.power)))
                                            .cornerRadius(20)
                                            .shadow(color: .gray, radius: 3, x: 2, y: 2)
                                    } .frame(maxWidth: .infinity, alignment: .center)
                                    .offset(x: 10)
                                    Text("\(item.selectedDate, formatter: dateFormatter)")
                                        .font(.system(size: 12, weight: .medium, design: .default))
                                        .padding(3)
                                        .foregroundColor(.gray)
                                        .opacity(0.5)
                                        .offset(x: 30, y: -30)
                                        .frame(maxWidth: .infinity, alignment: .trailing)
                                } .frame(maxWidth: .infinity)
                        }
                        .disabled(item.imageD == Data())
                        .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                            Button(role: .destructive, action: {
                                deleteScam(item: item)
                            }) {
                                Label("Delete", systemImage: "trash")
                            }
                        }
                        .swipeActions(edge: .leading) {
                            Button {
                                editInput = item.title
                                editpower = item.power
                                if let unwrapped = sortedScams.firstIndex(of: item) {indexOfEditScam = unwrapped}
                                withAnimation(.spring()) {
                                    editIsShown.toggle()
                                }
                            } label: {
                                Label("Edit", systemImage: "pencil")
                            }
                            .tint(.green)
                        }
                    }
                    .onChange(of: editIsShown) { _ in
                        sortedScams[indexOfEditScam].title = editInput
                        sortedScams[indexOfEditScam].power = editpower
                        try? viewContext.save()
                    }
                }
                .navigationBarTitle("Scam List")
                .navigationBarItems(trailing:
                                        Button(action: {
                    self.showingAddExpense = true
                }) {
                    Image(systemName: "plus")
                })
                .navigationBarItems(leading:
                                        Picker("Select number", selection: $pickerSelection) {
                    Text("Сортировка по дате").tag(1)
                    Text("Сортировка по алфавиту").tag(2)
                    Text("Сортировка по силе скама").tag(3)
                }
                    .pickerStyle(.menu)
                    .sheet(isPresented: $showingAddExpense) {
                        NewSheet()
                    }
                )}
            EditScam(isShown: $editIsShown, isCanceled: $editIsCanceled, text: $editInput, power: $editpower)
        } .environment(\.colorScheme, .light)
    }
    // MARK: — Swipe to delete from list
    func deleteScam(item: Scam) {
        viewContext.delete(entity[sortedScams.firstIndex(of: item)!])
        try? viewContext.save()
    }
    func colorOfPower(power: Int) -> Color {
        switch power {
        case 0:
            return Color(UIColor(red: 252/255, green: 191/255, blue: 41/255, alpha: 1.0))
        case 1:
            return Color(UIColor(red: 252/255, green: 178/255, blue: 43/255, alpha: 1.0))
        case 2:
            return Color(UIColor(red: 252/255, green: 164/255, blue: 45/255, alpha: 1.0))
        case 3:
            return Color(UIColor(red: 252/255, green: 153/255, blue: 47/255, alpha: 1.0))
        case 4:
            return Color(UIColor(red: 252/255, green: 141/255, blue: 48/255, alpha: 1.0))
        case 5:
            return Color(UIColor(red: 252/255, green: 127/255, blue: 49/255, alpha: 1.0))
        case 6:
            return Color(UIColor(red: 252/255, green: 114/255, blue: 50/255, alpha: 1.0))
        case 7:
            return Color(UIColor(red: 252/255, green: 102/255, blue: 51/255, alpha: 1.0))
        case 8:
            return Color(UIColor(red: 252/255, green: 88/255, blue: 51/255, alpha: 1.0))
        case 9:
            return Color(UIColor(red: 252/255, green: 72/255, blue: 51/255, alpha: 1.0))
        case 10:
            return Color(UIColor(red: 252/255, green: 55/255, blue: 51/255, alpha: 1.0))
        default:
           return Color(.black)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .previewInterfaceOrientation(.portrait)
    }
}
