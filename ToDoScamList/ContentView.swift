//
//  ContentView.swift
//  ToDoScamList
//
//  Created by Денис Жестерев on 16.12.2022.
//

import SwiftUI
import CoreData

struct ExpenseItem: Identifiable, Hashable {
    let id = UUID()
    let name: String
    let type: String
    let amount: Double
    let selectedDate: Date
    let selectedImage: UIImage
    
}


class Expenses: ObservableObject {
    @Published var items = [ExpenseItem]()
}




struct ContentView: View {
    @ObservedObject var expenses = Expenses()
    @State private var showingAddExpense = false
    @State var selectionIndex: Int = 0
    @State var selection: Int = 1

    var sortByAll: Array<Scam> {
        switch selection {
        case(1): return users.sorted(by: {$0.selectedDate > $1.selectedDate})
        case(2): return users.sorted(by: {$0.name < $1.name})
        case(3): return users.sorted(by: {$0.amount > $1.amount})
        default: return []
        }
    }
    
    
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(entity: Scam.entity(), sortDescriptors: [NSSortDescriptor(keyPath:\Scam.selectedDate, ascending: false)]) var users: FetchedResults<Scam>
   
  
    
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
                    
                    //                        NavigationLink(destination: Image(uiImage: item.selectedImage)
                    //                            .resizable()
                    //                            .aspectRatio(contentMode: .fit)
                    //                        )
                    //                    {
                    HStack{
                        VStack(alignment: .leading){
                            Text(item.name)
                                .font(.headline)
                            Text(item.type)
                            
                        }
                        //                            Image(uiImage: item.selectedImage)
                        //                                .resizable()
                        //                                .aspectRatio(contentMode: .fit)
                        //                                .clipShape(Circle())
                        //                                .frame(width: 50, height: 50)
                        Spacer()
                        Text("\(item.selectedDate, formatter: dateFormatter)")
                            .padding(.horizontal)
                            .foregroundColor(.gray)
                            .opacity(0.5)
                        Text("\(Int(item.amount))")
                    }
                    //                    }
                }
                .onDelete(perform: deleteUser(at:))
                .onTapGesture {
                }
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
            moc.delete(user)
        }
        try? moc.save()
    }
    func sort() {
        expenses.items = expenses.items.sorted {$0.type < $1.type}
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
