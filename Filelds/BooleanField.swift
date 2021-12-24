//
//  BooleanField.swift
//  finChurche
//
//  Created by Алексей Сухов on 17.08.2020.
//  Copyright © 2020 Алексей Сухов. All rights reserved.
//

import SwiftUI

struct BooleanField: View {
    var name : String = ""
    
    @Binding var value : Bool
    var body: some View {
        
        Toggle(isOn: $value) {
            Text(name).fontWeight(.ultraLight)
        }
    }
}

struct BooleanField_Previews: PreviewProvider {
    static var previews: some View {
        BooleanField(name: "name", value: .constant(false))
    }
}
