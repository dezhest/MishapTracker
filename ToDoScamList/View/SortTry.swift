//import SwiftUI
//import CoreData
//
//struct ContentView: View {
//    @Environment(\.managedObjectContext) var managedObjectContext
//    @State private var sortType: SortType = .title
//
//    var fetchRequest: FetchRequest<ScamCoreData>
//
//    init(sort: SortType) {
//        sortType = sort
//        let sortDescriptor = NSSortDescriptor(keyPath: \ScamCoreData.title, ascending: sortType == .title)
//        fetchRequest = FetchRequest<ScamCoreData>(entity: ScamCoreData.entity(), sortDescriptors: [sortDescriptor])
//    }
//
//    var body: some View {
//        VStack {
//            Picker(selection: $sortType, label: Text("Sort By")) {
//                Text("Name").tag(SortType.title)
//                Text("Age").tag(SortType.age)
//            }
//            .pickerStyle(SegmentedPickerStyle())
//
//            List {
//                ForEach(fetchRequest.wrappedValue, id: \.self) { person in
//                    Text("\(person.title) - \(person.description) years old")
//                }
//            }
//        }
//    }
//}
//
//enum SortType {
//    case title
//    case age
//}
//
