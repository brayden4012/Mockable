//
//  Array+MockableConformance.swift
//  TSCore
//
//  Created by Brayden Harris on 3/21/22.
//  Copyright © 2022 TradeStation. All rights reserved.
//

import Foundation

extension Array: Mockable where Element: Mockable { }
