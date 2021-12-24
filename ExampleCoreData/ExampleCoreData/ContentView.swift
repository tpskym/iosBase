//
//  ContentView.swift
//  ExampleCoreData
//
//  Created by Алексей Сухов on 24.12.2021.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Wallet.name, ascending: true)],
        animation: .default)
    private var items: FetchedResults<Wallet>

    @State var isAddMode = false
    @State var newItem : Wallet? = nil
    
    var body: some View {
        NavigationView {
            VStack{
                if items.count == 0 {
                    Text("No items")
                }
                else {
                    List {
                        ForEach(items) { item in
                            NavigationLink {
                                WalletDetail().environmentObject(WalletModel(wallet: item, context: viewContext))
                            } label: {
                                Text(item.name!)
                            }
                        }
                        .onDelete(perform: deleteItems)
              
                    }
                }
                if isAddMode {
                    NavigationLink(isActive: $isAddMode,
                                   destination:   { WalletDetail().environmentObject(WalletModel(wallet: newItem!, context: viewContext))} , label: {EmptyView()})
                }
            }
            .navigationTitle("Wallets")
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
        }
    }

    private func addItem() {
        withAnimation {
            newItem = Wallet(context: viewContext)
            newItem!.name = ""

            do {
                try viewContext.save()
                isAddMode.toggle()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { items[$0] }.forEach(viewContext.delete)

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
}

class WalletModel : ObservableObject
{
    @Published var name : String {
        didSet {
            if oldValue != name {
                item.name = name
            }
        }
    }

    @Published var currency : Currency? {
        didSet {
            if oldValue != currency {
                item.relationshipCurrency = currency
                
            }
        }
    }
    
    private var viewContext : NSManagedObjectContext
    private var item : Wallet
    
    init (wallet : Wallet, context: NSManagedObjectContext){
        item = wallet
        viewContext = context
        _name = Published(initialValue: wallet.name ?? "")
        _currency = Published(initialValue: wallet.relationshipCurrency)
    }
    
    func saveViewContext()
    {
        do  {
            try viewContext.save()
        }
        catch {
            let err = error as NSError
            fatalError("\(err.localizedDescription) \(err.userInfo)")
        }
    }
        
    
}

struct WalletDetail : View
{
    @EnvironmentObject var walletModel : WalletModel
    
    var body: some View
    {
        Form{
            HStack{
                Text("name")
                Spacer()
                TextField("name", text: $walletModel.name).multilineTextAlignment(.trailing)
            }
            NavigationLink {
                CurrencyList(isSelectMode: true, selected: $walletModel.currency)
            } label: {
                HStack{
                    Text("Currency")
                    Spacer()
                    Text("\(walletModel.currency?.name ?? "")")
                }
            }
        }
        .navigationTitle("Edit wallet")
    
    }
}


struct CurrencyList : View
{
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Currency.name, ascending: true)],
        animation: .default)
    private var items: FetchedResults<Currency>
    
    @State private var isAddMode = false
    @State private var newItem : Currency? = nil
    
    var isSelectMode = false
    @Binding var selected : Currency?
    
    var body: some View
    {
        VStack{
            if items.count == 0 {
                Text("No items")
            }
            else {
                List {
                    ForEach(items) { item in
                        if isSelectMode {
                            itemCurrencyInSelectMode(item: item, selected: $selected)
                        }
                        else {
                            NavigationLink {
                                CurrencyDetail().environmentObject(CurrencyModel(currency: item, context: viewContext))
                            } label: {
                                Text(item.name!)
                            }
                        }
                    }
                    .onDelete(perform: deleteItems)
                    
                }
            }
            if isAddMode {
                NavigationLink(isActive: $isAddMode, destination: {
                    CurrencyDetail().environmentObject(CurrencyModel(currency: newItem!, context: viewContext))
                }, label: {
                    EmptyView()
                })
            }
        }
        .navigationTitle(getTitle())
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
    }
    
    private func getTitle() -> String
    {
        if isSelectMode {
            return "Select currency"
        }
        else{
            return "Currency list"
        }
    }
    private func addItem() {
        withAnimation {
            newItem = Currency(context: viewContext)
            newItem!.name = ""
            
            do {
                try viewContext.save()
                isAddMode.toggle()
            } catch {
                    // Replace this implementation with code to handle the error appropriately.
                    // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
    
    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { items[$0] }.forEach(viewContext.delete)
            
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
}

struct itemCurrencyInSelectMode : View
{
    @Environment(\.managedObjectContext) private var viewContext
    
    var item : Currency
    @Binding var selected : Currency?
    
    @State var isContextMode = false
    
    var body: some View
    {
        VStack{
            HStack{
                
                Text(item.name ?? "")
                Spacer()
                if selected == item {
                    Image(systemName: "checkmark")
                        .foregroundColor(Color.blue)
                }
                if isContextMode{
                    
                    NavigationLink (
                        isActive: $isContextMode,
                        destination : { CurrencyDetail().environmentObject(CurrencyModel(currency: item, context: viewContext))
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
        }
        .contextMenu{
            Button(action: {
                isContextMode.toggle()
            }, label: { Label("Edit", systemImage: "pencil") })
           
        }
    
    }
    
}

class CurrencyModel : ObservableObject
{
    @Published var name : String {
        didSet {
            if oldValue != name {
                item.name = name
                saveViewContext()
            }
        }
    }
    
   
    
    private var viewContext : NSManagedObjectContext
    private var item : Currency
    
    init (currency : Currency, context: NSManagedObjectContext){
        item = currency
        viewContext = context
        _name = Published(initialValue: currency.name ?? "")
        
    }
    
    func saveViewContext()
    {
        do  {
            try viewContext.save()
        }
        catch {
            let err = error as NSError
            fatalError("\(err.localizedDescription) \(err.userInfo)")
        }
    }
    
    
}

struct CurrencyDetail : View
{
    @EnvironmentObject var currencyModel : CurrencyModel
    
    var body: some View
    {
        Form{
            TextField("name", text: $currencyModel.name)
        }
        .navigationTitle("Edit currency")
    
    }
}
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
