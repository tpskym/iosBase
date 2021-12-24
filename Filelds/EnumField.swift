//
//  EnumField.swift
//  finChurche
//
//  Created by Алексей Сухов on 17.08.2020.
//  Copyright © 2020 Алексей Сухов. All rights reserved.
//

import SwiftUI



struct EnumField: View {
    var name = ""
    var listItems : [String]
    @Binding var selected : String
    
    func row(index : Int) -> AnyView {
        return AnyView( Text(self.listItems[ index ]).tag(self.listItems[ index ]) )
    }
    var body: some View {
        VStack{
            Text(name).fontWeight(.ultraLight).frame( maxWidth: .infinity, alignment:.leading)
            Picker(selection: $selected, label: Text(name)) {
               
                ForEach(0 ..< listItems.count) {
                    self.row(index : $0)
                    
                }
            }.pickerStyle(SegmentedPickerStyle())
        }

    }
}

//struct EnumField_Previews: PreviewProvider {
//    static var previews: some View {
//
//    }
//}
