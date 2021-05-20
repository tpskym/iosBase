//
//  CategoryAddList.swift
//  finChurche
//
//  Created by Алексей Сухов on 14.08.2020.
//  Copyright © 2020 Алексей Сухов. All rights reserved.
//

import SwiftUI

class GroupDataBaselist : DataBaseList
{
    
    final override func filList() -> [BaseModel]
    {
        return [BaseModel]()
    }
    
    func fillDictionary() -> Dictionary<String, [BaseModel]>
    {
        return Dictionary<String, [BaseModel]>()
    }
    
    func getViewSection(key : String) -> AnyView
    {
        return AnyView(EmptyView())
    }
}

class DataBaseList {
    
    
    init(idSelected : Binding<Int>, showedText : Binding<String>, isSelect : Bool) {
       
        _baseModelIdSelected = idSelected
        _baseModelIdSelectedShowerText = showedText
        self.isSelect = isSelect
    }
    
    func getDestination(isNewItem : Bool, item : BaseModel?) -> AnyView
    {
        return AnyView(EmptyView())
    }
    func getIsDescendingSort() -> Bool{
        return false
    }
    func getViewRow(item: BaseModel) -> AnyView
    {
        return AnyView(EmptyView())
    }
    
    var isSelect : Bool
    
    @Binding var baseModelIdSelected : Int
    @Binding var baseModelIdSelectedShowerText : String
    
    func getTextNoItems() -> String
    {
        return "No items"
    }
    func filList() -> [BaseModel]
    {
        return [BaseModel]()
    }
    
    func getTitleList()-> String{
        return ""
    }
    
    func getTitleSelectList()-> String{
        return ""
    }
}

struct BaseList: View {
    
    func getTitle()-> String
    {
        if isSelectForm{
            return dataBaseList.getTitleSelectList()
        }
        else{
            return dataBaseList.getTitleList()
        }
        
    }
    
    @State var dataBaseList  : DataBaseList
    var isPlain : Bool
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    private var isSelectForm = false
    @State private var list = [BaseModel]()
    @State private var dictionary :Dictionary<String,[BaseModel]>  = Dictionary<String,[BaseModel]>()
    @State var isContextMenuSelect = false
    @State var itemContextMenuSelected : BaseModel = BaseModel()
    
    @State var isAddMode = false
    
    init(data : DataBaseList){
        self.isPlain = true
        _dataBaseList = State(initialValue: data)
        
        self.isSelectForm = data.isSelect
        let list = self.dataBaseList.filList()
        
        self.list = list
        
    }
    
    init(data: GroupDataBaselist)
    {
        self.isPlain = false
        _dataBaseList = State(initialValue: data)
        self.isSelectForm = data.isSelect
        self.dictionary =  data.fillDictionary()
        
        
    }
    private var add : some View{
        Button(action: {
            self.isAddMode = true
        }) {
            HStack {
                Image(systemName: "plus.circle")
                Text("Добавить")
            }.foregroundColor(.blue)
        }
    }
    
    private var addLink : some View{
        NavigationLink(destination: self.dataBaseList.getDestination(isNewItem: true, item: nil), isActive : self.$isAddMode ) {
            EmptyView()
        }.frame(maxWidth: 0, maxHeight: 0)
    }
    
  
    
    func getListView()-> AnyView
    {
        if isPlain {
            return getViewForPlainList()
        } else {
            return getViewForGrouppedList()
        }
    }
    func getViewForGrouppedList() -> AnyView{
        let ret = VStack{
            
            if self.isContextMenuSelect{
                contextMenuNavigationLink
            }
            
            if dictionary.count > 0 {
                listDictionary
            }
            else{
                noItemsView
            }
        }
        
        return AnyView(ret)
    }
    
    var contextMenuNavigationLink : AnyView
    {
        return
            AnyView(NavigationLink(destination:  AnyView(self.dataBaseList.getDestination(isNewItem: false, item: itemContextMenuSelected) ), isActive: self.$isContextMenuSelect )
            {
                EmptyView()
            }
            .frame(maxWidth: 0))
    }
    
    var noItemsView : AnyView {
        return AnyView(VStack {
            Text( self.dataBaseList.getTextNoItems() ).padding()
            add
        })
    }
    
    var listDictionary : AnyView {
        let keys = dictionary.keys.map { (String) -> String in
            return String
        }.sorted { (one, two) -> Bool in
            if self.dataBaseList.getIsDescendingSort()
            {
                return one > two
            }
            else
            {
                return one < two
            }
            
        }
        func getArr(_ key : String) -> [BaseModel]
        {
            let arr = dictionary[key]
            if let arr = arr {
                return arr
            }
            return [BaseModel]()
        }
        let view =
            List{
                ForEach(keys, id: \.self) { key in
                    
                    Section(header:
                        AnyView( (self.dataBaseList as! GroupDataBaselist).getViewSection(key: key))
                    , content: {
                        ForEach( getArr(key), id: \.id) { baseModel in
                            VStack {
                                
                                if self.isSelectForm  {
                                    rowBase(item: baseModel,
                                            baseModelIdSelected:  self.dataBaseList.$baseModelIdSelected,
                                            baseModelIdSelectedShowerText:  self.dataBaseList.$baseModelIdSelectedShowerText,
                                            viewRow: AnyView(self.dataBaseList.getViewRow(item: baseModel)),
                                            isContextMenuSelect: self.$isContextMenuSelect,
                                            itemSelectedContextMenu: self.$itemContextMenuSelected)
                                }
                                else{
                                    NavigationLink(destination:  self.dataBaseList.getDestination(isNewItem: false, item: baseModel) )
                                    {
                                        self.dataBaseList.getViewRow(item: baseModel)
                                    }
                                }
                            }
                        }
                    })
                }
            }
        return AnyView(view)
    }
    
    
    
    var listPlain : AnyView {
        return AnyView(
            List {
                ForEach(list, id: \.id){ item in
                    VStack{
                        // лист не прыгает если plain style
                        if self.isSelectForm  {
                            rowBase(item: item,
                                    baseModelIdSelected:  self.dataBaseList.$baseModelIdSelected,
                                    baseModelIdSelectedShowerText:  self.dataBaseList.$baseModelIdSelectedShowerText,
                                    viewRow: AnyView(self.dataBaseList.getViewRow(item: item)),
                                    isContextMenuSelect: self.$isContextMenuSelect,
                                    itemSelectedContextMenu: self.$itemContextMenuSelected)
                        }
                            
                        else{
                            NavigationLink(destination:  self.dataBaseList.getDestination(isNewItem: false, item: item) )
                            {
                                self.dataBaseList.getViewRow(item: item)
                            }
                        }
                    }
                    
                    
                }
            }.listStyle(PlainListStyle()) // так лист не прыгает
        )
    }
    func getViewForPlainList() -> AnyView
    {
        let ret = VStack{
            
            if self.isContextMenuSelect{
                contextMenuNavigationLink
            }
            
            if list.count > 0 {
                listPlain
            }
            else{
                noItemsView
            }
        }
        
        return AnyView(ret)
    }
    
    var body: some View {
        
        return HStack{
                    getListView()
                    addLink
                }
        .navigationBarItems( trailing: add )
        .navigationBarTitle( Text( getTitle() ), displayMode: .large )
        .onAppear(){
            if self.isPlain {
                self.list = self.dataBaseList.filList()
            }
            else{
                self.dictionary = (self.dataBaseList as! GroupDataBaselist).fillDictionary()
            }
        }
    }
}

struct rowBase : View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    var item : BaseModel
    @Binding var baseModelIdSelected : Int
    @Binding var baseModelIdSelectedShowerText : String
    var viewRow : AnyView
    @Binding var isContextMenuSelect : Bool
    @Binding var itemSelectedContextMenu : BaseModel
    
    var body : some View{
        VStack{
            
            Button(action:{
                
                self.baseModelIdSelected = self.item.id
                self.baseModelIdSelectedShowerText = self.item.anyModel?.getShowerTextInAttribut() ?? ""
                self.presentationMode.wrappedValue.dismiss()
            }) {
                viewRow.contextMenu {
                    Button(action: {
                        self.isContextMenuSelect = true
                        self.itemSelectedContextMenu = self.item
                    }){
                        Text("Изменить")
                    }
                }
            }
           
        }
        

    }
}

//struct BaseList_Previews: PreviewProvider {
//    @State static var id = -1
//    static var previews: some View {
//
//        BaseList( baseModelIdSelected: $id )
//    }
//}
struct testView  : View
{
    var body: some View
    {
        Text("gjnghg")
    }
    
}
