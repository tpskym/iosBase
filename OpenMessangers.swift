//
//  OpenMessangers.swift
//  OrdersManagement
//
//  Created by Алексей Сухов on 24.08.2020.
//  Copyright © 2020 Алексей Сухов. All rights reserved.
//

import Foundation
import SwiftUI

class OpenMessangers {
    private func getPhoneForWhatsup(number : String)->String
    {
        var item = number
        var ret = ""
        var isFirstLetter = true
        for letter in item {
            
            if letter.isNumber
            {
                //                if isFirstLetter{
                //                    isFirstLetter = false
                //                    continue
                //                }
                ret.append(letter)
            }
        }
        return ret
    }
    func openPersonInCall(number : String)
    {
        
        var address = "tel:\(self.getPhoneForWhatsup( number : number  ))"
        //address = "https://www.hackingwithswift.com"
        var url  = URL(string: address)
        
        //Text which will be shared on WhatsApp is: "Hello Friends, Sharing some data here... !"
        if let url = url {
            // if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:]) { (success) in
                if success {
                    print("WhatsApp accessed successfully")
                } else {
                    print("Error accessing telegramm")
                }
            }
            //}
        }
    }
    
    func openPersonInTelegram(number : String)
    {
        
        var address = "tg://msg?to=\(self.getPhoneForWhatsup( number : number  ))"
        //address = "https://www.hackingwithswift.com"
        var url  = URL(string: address)
        
        //Text which will be shared on WhatsApp is: "Hello Friends, Sharing some data here... !"
        if let url = url {
            // if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:]) { (success) in
                if success {
                    print("WhatsApp accessed successfully")
                } else {
                    print("Error accessing telegramm")
                }
            }
            //}
        }
    }
    func openPersonInSMS(number: String)
    {
        
        var address = "SMS:\(self.getPhoneForWhatsup( number : number  ))"
        //address = "https://www.hackingwithswift.com"
        var url  = URL(string: address)
        
        //Text which will be shared on WhatsApp is: "Hello Friends, Sharing some data here... !"
        if let url = url {
            // if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:]) { (success) in
                if success {
                    print("WhatsApp accessed successfully")
                } else {
                    print("Error accessing sms")
                }
            }
            //}
        }
    }
    func openPersonInViber(number : String)
    {
        
        var address = "viber://add?number=\(self.getPhoneForWhatsup( number : number  ))"
        //address = "https://www.hackingwithswift.com"
        var url  = URL(string: address)
        
        //Text which will be shared on WhatsApp is: "Hello Friends, Sharing some data here... !"
        if let url = url {
            // if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:]) { (success) in
                if success {
                    print("WhatsApp accessed successfully")
                } else {
                    print("Error accessing Viber")
                }
            }
            //}
        }
    }
    func OpenPersonInWhatsup(number : String)
    {
        var address = "whatsapp://send/?phone=\(self.getPhoneForWhatsup( number : number  ))"
        //address = "https://www.hackingwithswift.com"
        var url  = URL(string: address)
        
        //Text which will be shared on WhatsApp is: "Hello Friends, Sharing some data here... !"
        if let url = url {
            // if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:]) { (success) in
                if success {
                    print("WhatsApp accessed successfully")
                } else {
                    print("Error accessing WhatsApp")
                }
            }
            //}
        }
    }
}
