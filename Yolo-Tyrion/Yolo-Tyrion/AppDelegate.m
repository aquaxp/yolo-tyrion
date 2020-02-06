//
//  AppDelegate.m
//  Yolo-Tyrion
//
//  Created by mindworm on 15/11/14.
//  Copyright (c) 2014 aquaxp.tk. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()
@end

@implementation AppDelegate
- (void) updateData:(NSNotification *) notification{
    // First, check that iTunes is running, if no, show logo and return
    if (![iTunes isRunning]){
        NSLog(@"No iTunes");
        [[statusItem button] setTitle:[NSString stringWithFormat:@"●∿"]];
        [_launchItem setHidden:NO];
        return;
    } else {
        NSLog(@"iTunes is running");
    }

    // Hide Launch Item
    [_launchItem setHidden:YES];

    // state branches
    switch ([iTunes playerState]) {
        case iTunesEPlSFastForwarding:
            NSLog(@"iTunses state: FastForwarding(%d)", [iTunes playerState]);
            break;
        case iTunesEPlSRewinding:
            NSLog(@"iTunses state: Rewinding(%d)", [iTunes playerState]);
            NSLog(@"Unused iTunses state");
            break;
        case iTunesEPlSStopped:
            NSLog(@"iTunses state: Stopped(%d)", [iTunes playerState]);

            [[statusItem button] setTitle:[NSString stringWithFormat:@"◼"]];
            break;
        case iTunesEPlSPaused:
            NSLog(@"iTunses state: Paused(%d)", [iTunes playerState]);
            NSLog(@"Current track %@ by %@",[[iTunes currentTrack] name], [[iTunes currentTrack] artist]);

            [[statusItem button] setTitle:[NSString stringWithFormat:@"❙❙ %@: %@",[[iTunes currentTrack] artist], [[iTunes currentTrack] name]]];
            break;
        case iTunesEPlSPlaying:
            NSLog(@"iTunses state: Playing(%d)", [iTunes playerState]);
            NSLog(@"Current track %@ by %@",[[iTunes currentTrack] name], [[iTunes currentTrack] artist]);

            [[statusItem button] setTitle:[NSString stringWithFormat:@"► %@: %@",[[iTunes currentTrack] artist], [[iTunes currentTrack] name]]];
            break;
        default:
            NSLog(@"iTunses state: Unsupported(%d)", [iTunes playerState]);

            // In any other case - show logo
            [[statusItem button] setTitle:[NSString stringWithFormat:@"●∿"]];
            [_launchItem setHidden:NO];
    }
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Adding itunes observer
    [[NSDistributedNotificationCenter defaultCenter] addObserver:self selector:@selector(updateData:) name:@"com.apple.iTunes.playerInfo" object:nil];

    // Registering iTunes
    iTunes = [SBApplication applicationWithBundleIdentifier:@"com.apple.iTunes"];

    // Creating status item
    statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength];

    // Here we go!
    NSLog(@"Creating menu");
    [statusItem setMenu:statusMenu];

    // First data update
    [self updateData:nil];
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // removing iTunes Observer
    [[NSDistributedNotificationCenter defaultCenter] removeObserver:self];
}

- (IBAction)launchITunes:(id)sender{
    // Open iTunes and Update status
    [iTunes activate];
    [self updateData:nil];
}

@end
