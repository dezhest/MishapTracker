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
    @State var selection: Int = 1
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(entity: Scam.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Scam.selectedDate, ascending: false)]) var users: FetchedResults<Scam>
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

    var sorting: [Scam] {
        switch selection {
        case(1): return users.sorted(by: {$0.selectedDate > $1.selectedDate})
        case(2): return users.sorted(by: {$0.name < $1.name})
        case(3): return users.sorted(by: {$0.power > $1.power})
        default: return []
        }
    }

    var body: some View {
        ZStack {
            NavigationView {
                List {
                    ForEach(sorting, id: \.self) { item in
                        NavigationLink(destination: Image(uiImage: UIImage(data: item.imageD ?? Data()) ?? UIImage())
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .pinchToZoom
                        ) {
                            HStack(alignment: .center, spacing: 0) {
                                VStack(alignment: .leading, spacing: 5) {
                                    Text(item.name)
                                            .font(.system(size: 14, weight: .bold, design: .default))
                                    Text(item.type)
                                        .font(.system(size: 12, weight: .medium, design: .default))
                                }
                                Spacer()
                                Image(uiImage: UIImage(data: item.imageD ?? self.image) ?? UIImage())
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 50, height: 50)
                                    .clipShape(Circle())
                                Spacer()
                                Text("\(item.selectedDate, formatter: dateFormatter)")
                                    .font(.system(size: 12, weight: .medium, design: .default))
                                    .padding(3)
                                    .foregroundColor(.gray)
                                    .opacity(0.5)

                                Text("\(Int(item.power))")
                            }
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
                                editInput = item.name
                                editpower = item.power
                                if let unwrapped = sorting.firstIndex(of: item) {indexOfEditScam = unwrapped}
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
                                    sorting[indexOfEditScam].name = editInput
                                    sorting[indexOfEditScam].power = editpower
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
                                        Picker("Select number", selection: $selection) {
                    Text("Сортировка по дате").tag(1)
                    Text("Сортировка по алфавиту").tag(2)
                    Text("Сортировка по силе скама").tag(3)
                }
                    .pickerStyle(.menu)
                    .sheet(isPresented: $showingAddExpense) {
                        AddView()
                    }
                )}

            EditScam(isShown: $editIsShown, isCanceled: $editIsCanceled, text: $editInput, power: $editpower)
        }

    }
    // MARK: — Swipe to delete from list
    func deleteScam(item: Scam) {
        viewContext.delete(users[sorting.firstIndex(of: item)!])
        try? viewContext.save()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .previewInterfaceOrientation(.portrait)
    }
}
