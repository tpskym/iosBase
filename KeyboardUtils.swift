//
//  keyboardUtils.swift
//  invest
//
//  Created by Алексей Сухов on 07.08.2020.
//  Copyright © 2020 Алексей Сухов. All rights reserved.
//

import SwiftUI

final class KeyboardResponder: ObservableObject {
    private var notificationCenter: NotificationCenter
    @Published private(set) var currentHeight: CGFloat = 0
    
    init(center: NotificationCenter = .default) {
        notificationCenter = center
        notificationCenter.addObserver(self, selector: #selector(keyBoardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(keyBoardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    deinit {
        notificationCenter.removeObserver(self)
    }
    
    @objc func keyBoardWillShow(notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            currentHeight = keyboardSize.height
        }
    }
    
    @objc func keyBoardWillHide(notification: Notification) {
        currentHeight = 0
    }
}



//
//struct ExampleUse : View{
//    @ObservedObject private var keyboard = KeyboardResponder()
//    var body: some View
//    {
//        VStack{
//            Text("ddd")
//        }.padding(.bottom, keyboard.currentHeight + 20)
//            .edgesIgnoringSafeArea(.bottom)
//            .animation(.easeOut(duration: 0.16))
//    }
//}
// Для закрытия формы
//@Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
// и по кнопке self.presentationMode.wrappedValue.dismiss()
