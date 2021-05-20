//
//  MultilineText.swift
//  OrdersManagement
//
//  Created by Алексей Сухов on 22.09.2020.
//  Copyright © 2020 Алексей Сухов. All rights reserved.
//

import SwiftUI

struct MultilineText: View {
    var name : String
    @Binding var text : String
    
    var body: some View {
        VStack{
            if !name.isEmpty{
                Text(self.name)
            }
            TextEditor(text: self.$text)
        }
    }
}

struct MultilineText_Previews: PreviewProvider {
    static var previews: some View {
        MultilineText(name: "Заметки", text: .constant("несколько строк должно поместиться тут многострочный текст"))
    }
}
