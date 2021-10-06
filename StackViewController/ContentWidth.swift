//
//  ContentWidth.swift
//  StackViewController
//
//  Created by Devin McKaskle on 10/4/21.
//  Copyright © 2021 Seed Platform, Inc. All rights reserved.
//

@objc public enum ContentWidth: Int {
    case matchScrollViewWidth
    case matchReadableContentGuideWidth
    
    public mutating func toggle() {
        self = ContentWidth(rawValue: rawValue + 1) ?? .matchScrollViewWidth
    }
}
