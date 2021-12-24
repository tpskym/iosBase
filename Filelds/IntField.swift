//
//  IntField.swift
//  finChurche
//
//  Created by Алексей Сухов on 17.08.2020.
//  Copyright © 2020 Алексей Сухов. All rights reserved.
//

import SwiftUI

struct IntField: View {
    
    var name : String
    var title : String
    @Binding var value : Int
    var body: some View {
        
        let temp = Binding<String>(
            get: {
                if self.value == 0{
                    return ""
                }
                let formatter = Formatter.IntFormatter
                if let valueToSet = formatter.string(for: self.value) {
                    return valueToSet
                }
                else{
                    return ""
                }
            },
            set: {
                
                self.value = Formatter.IntValue(from: $0)
                 
            })
        
        return
            HStack{
                
                Text(name).fontWeight(.ultraLight)
                TextFieldContainer(title, text: temp, keyboartType: .numberPad )
        }
        
    }
}
extension Formatter{
    static var IntFormatter : NumberFormatter
    {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = " "
        return formatter
    }
    static func IntValue(from : String) -> Int{
       
        var ret = ""
        for item in from {
            if item.isNumber {
                ret.append(item)
            }
        }
        
        return Int(ret) ?? 0
        
    }
}
struct IntField_Previews: PreviewProvider {
    static var previews: some View {
        IntField(name: "name", title: "hint", value: .constant(3))
    }
}
