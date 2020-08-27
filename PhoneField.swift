//
//  PhoneField.swift
//  OrdersManagement
//
//  Created by Алексей Сухов on 24.08.2020.
//  Copyright © 2020 Алексей Сухов. All rights reserved.
//

import Foundation
import SwiftUI

struct PhoneField : View
{
    var name : String
    var hint : String
    @Binding var phone : String
    var body: some View
    {
        
        var binding = Binding(get: {
            
            return Formatter.PhoneFormat(with: "+X (XXX) XXX-XX-XX", phone: self.phone)
            
        }, set: {
            self.phone = $0
        })
        
        return HStack{
            Text(name).fontWeight(.ultraLight)
            TextFieldContainer(hint, text: binding, keyboartType: .phonePad)
                
        }
        
    }
    
}


struct TextFieldContainer: UIViewRepresentable {
    private var placeholder : String
    private var text : Binding<String>
    var keyboard : UIKeyboardType
    
    init(_ placeholder:String, text:Binding<String>, keyboartType : UIKeyboardType) {
        self.placeholder = placeholder
        self.text = text
        self.keyboard = keyboartType
    }
    
    func makeCoordinator() -> TextFieldContainer.Coordinator {
        Coordinator(self)
    }
    
    func makeUIView(context: UIViewRepresentableContext<TextFieldContainer>) -> UITextField {
        
        let innertTextField = UITextField(frame: .zero)
        innertTextField.placeholder = placeholder
        innertTextField.text = text.wrappedValue
        innertTextField.delegate = context.coordinator
        innertTextField.textAlignment = .right
        innertTextField.keyboardType = keyboard
        
        context.coordinator.setup(innertTextField)
        
        return innertTextField
    }
    
    func updateUIView(_ uiView: UITextField, context: UIViewRepresentableContext<TextFieldContainer>) {
        uiView.text = self.text.wrappedValue
    }
    
    class Coordinator: NSObject, UITextFieldDelegate {
        var parent: TextFieldContainer
        
        init(_ textFieldContainer: TextFieldContainer) {
            self.parent = textFieldContainer
        }
        
        func setup(_ textField:UITextField) {
            textField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        }
        
        @objc func textFieldDidChange(_ textField: UITextField) {
            self.parent.text.wrappedValue = textField.text ?? ""
            
            let newPosition = textField.endOfDocument
            textField.selectedTextRange = textField.textRange(from: newPosition, to: newPosition)
        }
    }
}


extension Formatter{
    /// mask example: `+X (XXX) XXX-XXXX`
    static func PhoneFormat(with mask: String, phone: String) -> String {
        let numbers = phone.replacingOccurrences(of: "[^0-9]", with: "", options: .regularExpression)
        var result = ""
        var index = numbers.startIndex // numbers iterator
        
        // iterate over the mask characters until the iterator of numbers ends
        for ch in mask where index < numbers.endIndex {
            if ch == "X" {
                // mask requires a number in this place, so take the next one
                result.append(numbers[index])
                
                // move numbers iterator to the next index
                index = numbers.index(after: index)
                
            } else {
                result.append(ch) // just append a mask character
            }
        }
        return result
    }
}
