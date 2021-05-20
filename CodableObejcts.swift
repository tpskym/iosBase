//
//  CodableObejcts.swift
//  OrdersManagement
//
//  Created by Алексей Сухов on 28.08.2020.
//  Copyright © 2020 Алексей Сухов. All rights reserved.
//

import Foundation
class CodableWork
{
//    open func encode<T>(_ value: T) throws -> Data where T : Encodable
    static func getStringFromCodable<T>(_ encodable : T)-> String? where T : Encodable
    {
        //do {
            let data =  try? JSONEncoder().encode(encodable)
            if let data = data {
                return String(data: data, encoding: .utf8)!
            }
            else
            {
                return nil
            }
            
//        } catch  {
//            print(error)
//            return nil
//            
//        }
        
    }
    
    static func getCodableFromString<T>(_ type: T.Type , str : String) ->T? where T : Decodable
    {
        if str.trimmingCharacters(in: .whitespacesAndNewlines) == ""
        {
            return nil
        }
       
        if let strValue = str.data(using: .utf8) {
            do {
                let value = try JSONDecoder().decode( type , from: strValue)
                return value
            } catch  {
                print(error)
                return nil
            }
        }
        else
        {
            return nil
        }
    }
    
    
    
}
