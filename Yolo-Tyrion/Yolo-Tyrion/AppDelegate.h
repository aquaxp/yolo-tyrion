//
//  AppDelegate.h
//  Yolo-Tyrion
//
//  Created by mindworm on 15/11/14.
//  Copyright (c) 2014 aquaxp.tk. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "iTunes.h"

@interface AppDelegate : NSObject <NSApplicationDelegate>{
    NSStatusItem *statusItem;
    iTunesApplication* iTunes;
    IBOutlet NSMenu *statusMenu;
    IBOutlet NSMenuItem *_launchItem;
}

@end

