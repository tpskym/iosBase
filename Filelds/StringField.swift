//
//  StringField.swift
//  finChurche
//
//  Created by Алексей Сухов on 16.08.2020.
//  Copyright © 2020 Алексей Сухов. All rights reserved.
//

import SwiftUI

struct StringField: View {
    var name : String
    var title : String
    @Binding var text : String
    var body: some View {
        
        HStack{
            Text(name).fontWeight(.ultraLight)
            TextField(title, text: $text)
                .multilineTextAlignment(.trailing)
            
        }
        
    }
}

struct StringField_Previews: PreviewProvider {
    static var previews: some View {
        Form{
            StringField(name: "Название", title: "Подсказка", text: .constant("Значение"))
            StringField(name: "Название", title: "Подсказка", text: .constant("Значение"))
            StringField(name: "Название", title: "Подсказка", text: .constant("Значение"))
            StringField(name: "Название", title: "Подсказка", text: .constant(""))
        }
    }
}
