//
//  FrameWorkhandelCode.swift
//  FireBaseChatEncription
//
//  Created by Matrix Marketers on 03/09/19.
//  Copyright © 2019 pawan. All rights reserved.
//

import Foundation
import Firebase
import CryptoSwift


let FrameWorkCode = CodeHandler()
public class CodeHandler{


    //MARK: - JsonConvert Inot String
    public func JsonConvertIntoString(Json : Dictionary<String, Any>) -> String{
        var Json : String!
        let dictionary = Json
        if let theJSONData = try? JSONSerialization.data(
            withJSONObject: dictionary as Any,
            options: []) {
            let theJSONText = String(data: theJSONData,encoding: .utf8)
            Json = theJSONText
        }
        return Json
    }
    //MARK: - String Convert into Json
   public func StringconvertToDictionary(text: String) -> [String: Any]? {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
    
    //MARK: - Encription & Decription
    func AESEncrypt(KEY : String,IV : String,StringForEncription : String) throws -> String {
        let encrypted = try AES(key: KEY, iv: IV, padding: .pkcs7).encrypt([UInt8](StringForEncription.data(using: .utf8)!))
        return Data(encrypted).base64EncodedString()
    }
    
    func AESDecrypt(KEY : String,IV : String,StringForDescription : String) throws -> String {
        guard let data = Data(base64Encoded: StringForDescription) else { return "" }
        let decrypted = try AES(key: KEY, iv: IV, padding: .pkcs7).decrypt([UInt8](data))
        return String(bytes: decrypted, encoding: .utf8) ?? StringForDescription
    }
    
}
