//
//  FPStringExtension.swift
//  FoodPointer
//
//  Created by Govind Sah on 31/05/19.
//  Copyright © 2019 Govind Sah. All rights reserved.
//

import Foundation

extension String {
    
    /**
     to remove spaces and hyphen from the phone string
 */
    func removeSpaceAndSpecialCharacter() -> String {
        var string = self.replacingOccurrences(of: " ", with: "").replacingOccurrences(of: "-", with: "").removingPercentEncoding!
        string = string.hasSuffix("") ? String(string.dropLast()) : string
        string = string.hasPrefix("") ? String(string.dropFirst()) : string
        return string
    }
    
    /// append next word to the existing word
    /// with comma and space in between
    func appendNextWord(_ nextWord: String?) -> String {
        
        // return self in case next word is not there
        guard let nextWord = nextWord, 0 != nextWord.count else {
            return self
        }
        
        var finalWord = self
        
        // in case the first word is empty or nil
        // the final word is the next word itself
        if self.count == 0 {
            finalWord = nextWord
        } else {
            // else append next word to existing word
            finalWord = self + ", " + nextWord
        }
        return finalWord
    }
}
