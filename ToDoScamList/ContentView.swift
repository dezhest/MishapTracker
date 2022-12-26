//
//  ContentView.swift
//  ToDoScamList
//
//  Created by Денис Жестерев on 16.12.2022.
//

import SwiftUI
import CoreData
import PDFKit

struct ExpenseItem: Identifiable, Hashable {
    let id = UUID()
    let name: String
    let type: String
    let amount: Double
    let selectedDate: Date
    let image: Date
    
}


class Expenses: ObservableObject {
    @Published var items = [ExpenseItem]()
}




struct ContentView: View {
    @ObservedObject var expenses = Expenses()
    @State private var showingAddExpense = false
    @State var selectionIndex: Int = 0
    @State var selection: Int = 1
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(entity: Scam.entity(), sortDescriptors: [NSSortDescriptor(keyPath:\Scam.selectedDate, ascending: false)]) var users: FetchedResults<Scam>
    @State private var image: Data = .init(count: 0)
    @GestureState private var scale: CGFloat = 1.0
    
    var sortByAll: Array<Scam> {
        switch selection {
        case(1): return users.sorted(by: {$0.selectedDate > $1.selectedDate})
        case(2): return users.sorted(by: {$0.name < $1.name})
        case(3): return users.sorted(by: {$0.amount > $1.amount})
        default: return []
        }
    }
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.dateFormat = "dd.MM.yy"
        return formatter
    }()
    
    var body: some View {
        NavigationView {
            List {
                ForEach(sortByAll, id: \.self) { item in
                    NavigationLink(destination: Image(uiImage: UIImage(data: item.imageD ?? Data()) ?? UIImage())
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .pinchToZoom
                    ) {
                        
                        HStack(alignment: .center, spacing: 0){
                            VStack(alignment: .leading, spacing: 5){
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
                            
                            Text("\(Int(item.amount))")
                        }
                    }
                }
                .onDelete(perform: deleteUser(at:))
            }
            .navigationBarTitle("Scam List")
            .navigationBarItems(trailing:
                                    Button(action: {
                self.showingAddExpense = true
            }) {
                Image(systemName: "plus")
            }
            )
            .navigationBarItems(leading:
                                    Picker("Select number", selection: $selection){
                Text("Сортировка по дате").tag(1)
                Text("Сортировка по алфавиту").tag(2)
                Text("Сортировка по силе скама").tag(3)
            }
                .pickerStyle(.menu)
                .sheet(isPresented: $showingAddExpense) {
                    AddView(expenses: self.expenses)
                }
            )}
       

    }
    func deleteUser(at offsets: IndexSet) {
        for index in offsets {
            let user = users[index]
            viewContext.delete(user)
        }
        try? viewContext.save()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .previewInterfaceOrientation(.portrait)
    }
}
