//
//  ReferenceField.swift
//  finChurche
//
//  Created by Алексей Сухов on 17.08.2020.
//  Copyright © 2020 Алексей Сухов. All rights reserved.
//

import SwiftUI

struct ReferenceField: View {
    var name  : String
    var hint : String
    var destination : AnyView
    
    
    @Binding var selected : String
    
    func getTextSelected() -> String{
        if selected == "" {
            return "Выберите значение"
        }
        else{
            return selected
        }
        
    }
  
    var body: some View {
        
        HStack{
            Text(name).fontWeight(.ultraLight)
            NavigationLink(destination: self.destination){
                if selected == ""{
                    Text(getTextSelected()).foregroundColor(.secondary).frame(maxWidth : .infinity, alignment: .trailing)
                }
                else{
                    Text(getTextSelected()).foregroundColor(.primary).frame(maxWidth : .infinity, alignment: .trailing)
                }
            }
        }
            
        
    }
}


//struct ReferenceField_Previews: PreviewProvider {
//    static var previews: some View {
//        Form{
//            ReferenceField(name: "name", hint: "hint", destination: //AnyView(CategoryAddList()),  selected: .constant("red"))
//        }
//    }
//}
