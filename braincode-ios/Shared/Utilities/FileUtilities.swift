//
//  FileUtilities.swift
//  braincode-ios
//
//  Created by Kacper Harasim on 18.03.2016.
//  Copyright © 2016 Kacper Harasim. All rights reserved.
//

import Foundation


func documentsDirectoryPath() ->String?
{
    // fetch our paths
    let paths = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)

    if paths.count > 0
    {
        // return our docs directory path if we have one
        let docsDir = paths[0]
        return docsDir
    }
    return nil
}