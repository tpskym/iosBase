//
//  DoubleField.swift
//  finChurche
//
//  Created by Алексей Сухов on 17.08.2020.
//  Copyright © 2020 Алексей Сухов. All rights reserved.
//

import SwiftUI

struct DoubleField: View {
    var countDigits = 2
    var onChange : ()->Void = {}
    var name : String
    var title : String
    @Binding var value : Double
    var body: some View {
        
        let temp = Binding<String>(
            get: {
                if self.value == 0.0{
                    return ""
                }
                let formatter = Formatter.DoubleFormatter(countDigits:  self.countDigits)
                
                if let valueToSet = formatter.string(for: self.value) {
                    return valueToSet
                }
                else{
                    return ""
                }
                
        },
            set: {
                print ("set")
                self.value = Formatter.DoubleValue(from: $0)
                
        })
        
        return HStack{
            Text(name).fontWeight(.ultraLight)
            TextFieldContainer(title, text: temp,  keyboartType: .decimalPad )
        }
    }
}

extension Formatter{
    static func DoubleFormatter(countDigits : Int) -> NumberFormatter
    {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = " "
        formatter.maximumFractionDigits = countDigits
        formatter.decimalSeparator = "."
        
        return formatter
    }
    static func string(countDigits: Int, from: Double, defaultString: String)-> String
    {
        return Formatter
            .DoubleFormatter(countDigits: countDigits)
            .string(from: from as NSNumber) ?? defaultString
    }
    static func DoubleValue(from : String) -> Double{
        
        var ret = ""
        for item in from {
            if item.isNumber {
                ret.append(item)
            }
            else if (item == ".")
            {
                ret.append(".")
            }
        }

        return Double(ret) ?? 0

    }
}

struct DoubleField_Previews: PreviewProvider {
    static var previews: some View {
        DoubleField(name: "name", title: "title", value: .constant(1.0))
    }
}
