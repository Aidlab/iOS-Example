//
//  Utilities.swift
//  iOS-Example
//
//  Created by J Domaszewicz on 04.11.2016.
//  Copyright © 2016 Aidlab. MIT License.
//

func toU2( _ byteA: Int, byteB: Int, byteC: Int ) -> Int {
    
    var out: Int = ((byteA & 0x7F) << 16) | byteB << 8 | byteC
    
    if byteA & 0x80 == 0x80 { // If negative
        
        out -= 0x80 << 16
    }
    
    return out
}
