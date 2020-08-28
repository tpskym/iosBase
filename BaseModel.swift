//
//  BaseModel.swift
//  finChurche
//
//  Created by Алексей Сухов on 14.08.2020.
//  Copyright © 2020 Алексей Сухов. All rights reserved.
//



import Foundation
import SwiftUI

//example
//class testModel : BaseModel, AnyModel{
//
//}

protocol AnyModel {
    func getNameSaved() -> String
    func fillDict(dict:inout Dictionary<String, Any>)
    func fillFromDict(dict: Dictionary<String, Any>)
    func getInstance() -> BaseModel
    func getShowerTextInAttribut() -> String
    func getShowerViewInRowOrNillIfStandart() -> AnyView?
    
    func getTitleList()->String
    func getTitleListSelect() ->String
    func getTextListNoItems()-> String
    func getDetailViewNew() -> AnyView
    func getDetailViewItem(item: BaseModel)->AnyView
    
    
}


class BaseModel: Identifiable
{
    
    init()  {
        if self is AnyModel{
            self.anyModel = self as? AnyModel
        }
        else{
            self.anyModel = nil
            print("wrong implementation")
        }
    }
   
    var anyModel : AnyModel?
    
    var id = -1
    var uuid = UUID()

    private func getDataBaseList(idSelected: Binding<Int>, showedText: Binding<String>, isSelect : Bool) -> DataBaseList
    {
        class temp : DataBaseList
        {
            init(idSelected: Binding<Int>, showedText: Binding<String>, isSelect: Bool, anyModel : AnyModel) {
                self.anyModel = anyModel
                super.init(idSelected: idSelected, showedText: showedText, isSelect: isSelect)
            }
            var anyModel : AnyModel
            
            override func getDestination(isNewItem : Bool, item : BaseModel?) -> AnyView
            {
                if isNewItem {
                    
                    return AnyView( BaseElementForm(detailView: anyModel.getDetailViewNew()))
                }
                else{
                    if let item = item {
                        return AnyView( BaseElementForm(detailView: anyModel.getDetailViewItem(item: item ) ))
                    }
                    else{
                        return AnyView(EmptyView())
                    }
                    
                }
                
            }
            
            override func getViewRow(item: BaseModel) -> AnyView
            {
                
                if item.anyModel?.getShowerViewInRowOrNillIfStandart() == nil {
                    return AnyView(Text(item.anyModel?.getShowerTextInAttribut() ?? ""))
                }
                else
                {
                    return AnyView( item.anyModel?.getShowerViewInRowOrNillIfStandart() )
                }
                
            }
            
            
            override func getTextNoItems() -> String
            {
                return self.anyModel.getTextListNoItems()
            }
            
            override func filList() -> [BaseModel]
            {
                return anyModel.getInstance().loadAll()
            }
            
            override func getTitleList() -> String {
                return anyModel.getTitleList()
            }
            
            override func getTitleSelectList() -> String
            {
                return anyModel.getTitleListSelect()
            }
            
        }
        let tempValue = temp(idSelected: idSelected, showedText: showedText, isSelect: isSelect, anyModel:  self.anyModel!)
        
        return tempValue
    }
    
    func getListForSelectItem(idSelected: Binding<Int>, showedText: Binding<String>)->AnyView
    {
        let dataParam : DataBaseList = getDataBaseList(idSelected: idSelected, showedText: showedText, isSelect: true)
        return AnyView(BaseList(data: dataParam))
    }
    
    func getList() -> AnyView
    {
        let dataParam : DataBaseList = getDataBaseList(idSelected: .constant(-1), showedText: .constant(""), isSelect: false)
        return AnyView(BaseList(data: dataParam))
    }
    
    private func getDict()-> Dictionary<String,Any>
    {
        var dictOneItem = Dictionary<String, Any>()
        dictOneItem.updateValue(id, forKey: "id")
        
        anyModel?.fillDict(dict: &dictOneItem)
        
        return dictOneItem
        
    }
    
    
    private func loadFromDict(dict : Dictionary<String, Any>)
    {
        self.id = dict["id"] as! Int
        anyModel?.fillFromDict(dict: dict)
        
        
    }
    

    
    func loadAll() -> [BaseModel]
    {
        var list = [BaseModel]()
        let max = UserDefaults.standard.integer(forKey: (anyModel?.getNameSaved() ?? "" ) + "_max")
        if max <= 0 {
            return [BaseModel]()
        }
        else{
            for i in 1..<(max + 1) {
                let  item = UserDefaults.standard.value(forKey: (anyModel?.getNameSaved() ?? "") + "_" + String(i))
                if item != nil {
                    
                    if let anyModel = anyModel{
                        var itemToList = anyModel.getInstance()
                        itemToList.loadFromDict(dict: item as! Dictionary<String,Any>)
                        list.append(itemToList)
                    }
                    
                }
            }
        }
        
        
        return list
    }
    
    func load(){
        let  item = UserDefaults.standard.value(forKey: (anyModel?.getNameSaved() ?? "" ) + "_" + String(id))
        if item != nil {
            //let itemFromList = getInstance()
            self.loadFromDict(dict: item as! Dictionary<String,Any>)
            
            
        }
        
    }
   
    func remove()
    {
        UserDefaults.standard.removeObject(forKey: (anyModel?.getNameSaved() ?? "") + "_" + String(id))
    }
    func save()
    {
     
        if id == -1 {
            let max = UserDefaults.standard.integer(forKey: (anyModel?.getNameSaved() ?? "" ) + "_max")
            id = max + 1
            UserDefaults.standard.set(id, forKey:( anyModel?.getNameSaved() ?? "") + "_max")
        }
        let dict = getDict()
        UserDefaults.standard.setValue(dict, forKey: (anyModel?.getNameSaved() ?? "") + "_" + String(id))
        
    }
    func saveMaxAfterLoadData(countLoaded  : Int){
        UserDefaults.standard.set(countLoaded, forKey:( anyModel?.getNameSaved() ?? "") + "_max")
    }
    func clear()
    {
        var items = loadAll()
        for item in items
        {
            item.remove()
        }
        UserDefaults.standard.removeObject(forKey: ( anyModel?.getNameSaved() ?? "") + "_max")
        
        
    }
    
}



