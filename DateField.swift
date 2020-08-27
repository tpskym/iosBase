//
//  DateField.swift
//  finChurche
//
//  Created by Алексей Сухов on 17.08.2020.
//  Copyright © 2020 Алексей Сухов. All rights reserved.
//

import SwiftUI

struct DateField: View {
    var name : String
    @Binding var date : Date
    var showTimeOnly : types = .date
    
    func getPicker()-> AnyView
    {
        switch showTimeOnly {
            case .date:
                return AnyView(
                    DatePicker(selection: self.$date, displayedComponents: .date){
                        Text(name).fontWeight(.ultraLight)
                })
//            case .DateAndTime:
//                return AnyView(
//                    DatePicker(selection: self.$date, in: ...Date(), displayedComponents: .){
//                        Text(name).fontWeight(.ultraLight)
//                })
            case .time:
                return AnyView(
                    DatePicker(selection: self.$date, displayedComponents: .hourAndMinute){
                        Text(name).fontWeight(.ultraLight)
                })
        }
       
    }
    
    var body: some View {
        getPicker()
    }
}
enum types{
    //case DateAndTime
    case date
    case time
}
struct DateField_Previews: PreviewProvider {
    static var previews: some View {
        DateField(name: "name", date: .constant(Date()))
    }
}
