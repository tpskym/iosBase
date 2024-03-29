//
//  UniversalLightList.swift
//  MyFinance
//
//  Created by Алексей Сухов on 24.12.2021.
//

import SwiftUI
import CoreData




struct UniversalLightListTemplate: View {

    // NameOfClass replace this to your className

    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \NameOfClass.name, ascending: true)],
        animation: .default)
    private var items: FetchedResults<NameOfClass>
    @Binding var selectedItem: NameOfClass?


    var titleSelect = "Select item"
    var titleList = "Items"

    func createNewItem() {

        newItem = NameOfClass(context: viewContext)
        //newItem?.name = ""
    }

    struct noItems: View
    {
        var body: some View
        {
            Text("No items")
        }

    }

    struct viewItemInList: View
    {
        @ObservedObject var item: NameOfClass
        var body: some View {
            Text("")
        }
    }

    struct viewItemInListSelectMode: View
    {
        @ObservedObject var item: NameOfClass
        var body: some View {
            Text("")
        }
    }

    class viewModel: viewModelNSManagedObject {
        @Published var name: String
        {
            didSet {
                if oldValue != name {
                    //item.name = name
                    saveViewContext()
                }
            }
        }

        override init(itemParametr: NameOfClass, context: NSManagedObjectContext) {
            //_name = Published(initialValue: itemParametr.name ?? "")

            super.init(itemParametr: itemParametr, context: context)
        }

    }



    struct detailViewItem: View
    {

        @EnvironmentObject var model: viewModel
        var body: some View
        {
            Form {
                Text("")
            }
                .navigationTitle("Edit item")

        }
    }
    
    func getSearchOnItem(item: NameOfClass, text: String) -> Bool
    {
        //return item.name?.contains(text) ?? true
    }

    // // // // / / / // / / / / / // / /

    var isSelectMode: Bool

    @State var isAddToggle = false
    @State var newItem: NameOfClass? = nil

    @State var searchedText = ""
    
    func getSearchStatus(item: NameOfClass) -> Bool {
        if searchedText == "" {
            return true
        }
        else {
            return getSearchOnItem(item: item, text: searchedText)
        }
    }
    
    
    fileprivate func getFiltered() -> [FetchedResults<NameOfClass>.Element] {
        return items.filter { currentItem in
            getSearchStatus(item: currentItem)
        }
    }

    var body: some View {
        //NavigationView {
        VStack() {
            if items.count == 0 {
                noItems()
            }
            else {
                List {
                    if getFiltered().count == 0 {
                        noItems()
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .padding(.top, 50)
                            .padding(.bottom, 50)
                        
                    }
                    ForEach(getFiltered()) { item in

                        if isSelectMode {
                            itemInSelectMode(item: item, selected: $selectedItem)

                        }
                        else {
                            NavigationLink {
                                detailViewItem()
                                    .environmentObject(viewModel(itemParametr: item, context: viewContext))
                            } label: {
                                viewItemInList(item: item)
                            }
                        }

                    }
                        .onDelete(perform: deleteItems)
                }
                .searchable(text: $searchedText)
                if isAddToggle {
                    NavigationLink("",
                        destination: detailViewItem()
                            .environmentObject(viewModel(itemParametr: newItem!, context: viewContext))
                        , isActive: $isAddToggle)
                }

            }
        }
            .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                EditButton()
            }
            ToolbarItem {
                Button(action: addItem) {
                    Label("Add Item", systemImage: "plus")
                }
            }
        }
            .onAppear(perform: {
            if !isSelectMode {
                viewContext.refreshAllObjects()
            }

        })
            .navigationTitle(getTitle())
        //}

    }




    private func getTitle() -> String {
        if isSelectMode {
            return titleSelect
        }
        else {
            return titleList
        }
    }

    private func saveViewContext()
    {
        do {
            try viewContext.save()

        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }

    private func addItem() {

        withAnimation {
            createNewItem()
            isAddToggle.toggle()
            saveViewContext()
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { items[$0] }.forEach(viewContext.delete)

            saveViewContext()
        }
    }

    class viewModelNSManagedObject: ObservableObject {


        private var viewContext: NSManagedObjectContext
        var item: NameOfClass



        init(itemParametr: NameOfClass, context: NSManagedObjectContext) {
            viewContext = context
            item = itemParametr
        }

        func saveViewContext()
        {
            do {
                try viewContext.save()

            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }

    }


    struct itemInSelectMode: View
    {
        @Environment(\.managedObjectContext) private var viewContext
        @Environment(\.presentationMode) private var presMode

        var item: NameOfClass
        @Binding var selected: NameOfClass?

        @State var isContextMode = false

        var body: some View
        {
            VStack {
                HStack {

                    viewItemInListSelectMode(item: item)
                    Spacer()
                    if selected == item {
                        Image(systemName: "checkmark")
                            .foregroundColor(Color.blue)
                    }
                    if isContextMode {

                        NavigationLink (
                            isActive: $isContextMode,
                            destination: { detailViewItem().environmentObject(viewModel(itemParametr: item, context: viewContext))
                            },
                            label: {
                                EmptyView()
                            })
                    }
                }


            }
                .contentShape(Rectangle())
                .onTapGesture {
                selected = item
                presMode.wrappedValue.dismiss()
            }
                .contextMenu {
                Button(action: {
                    isContextMode.toggle()
                }, label: { Label("Edit", systemImage: "pencil") })

            }

        }


    }

}


