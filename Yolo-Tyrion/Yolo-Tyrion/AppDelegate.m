//
//  AppDelegate.m
//  Yolo-Tyrion
//
//  Created by mindworm on 15/11/14.
//  Copyright (c) 2014 aquaxp.tk. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()
- (void) updateDataFromiTunes:(NSNotification *) notification;
- (void) updateDataFromSpotify:(NSNotification *) notification;
@end

@implementation AppDelegate
- (void) updateDataFromiTunes:(NSNotification *) notification{
    // First, check that iTunes is running, if no, show logo and return
    if (![iTunes isRunning]){
        NSLog(@"No iTunes");
        [[statusItem button] setTitle:[NSString stringWithFormat:@"●∿"]];
        [_iTunesLaunchItem setHidden:NO];
        return;
    } else {
        NSLog(@"iTunes is running");
    }

    // Hide Launch Item
    [_iTunesLaunchItem setHidden:YES];

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
            [_iTunesLaunchItem setHidden:NO];
    }
}

- (void) updateDataFromSpotify:(NSNotification *) notification{
    // First, check that iTunes is running, if no, show logo and return
    if (![Spotify isRunning]){
        NSLog(@"No Spotify");
        [[statusItem button] setTitle:[NSString stringWithFormat:@"●∿"]];
        [_SpotifyLaunchItem setHidden:NO];
        return;
    } else {
        NSLog(@"Spotify is running");
    }

    [_SpotifyLaunchItem setHidden:YES];

    // state branches
    switch ([Spotify playerState]) {
        case SpotifyEPlSStopped:
            NSLog(@"Spotify state: Stopped(%d)", [Spotify playerState]);

            [[statusItem button] setTitle:[NSString stringWithFormat:@"◼"]];
            if (![Spotify isRunning]) {
                NSLog(@"No Spotify");
                [[statusItem button] setTitle:[NSString stringWithFormat:@"●∿"]];
                [_SpotifyLaunchItem setHidden:NO];
            }
            break;
        case SpotifyEPlSPaused:
            NSLog(@"Spotify state: Paused(%d)", [Spotify playerState]);
            NSLog(@"Current track %@ by %@",[[Spotify currentTrack] name], [[Spotify currentTrack] artist]);

            [[statusItem button] setTitle:[NSString stringWithFormat:@"❙❙ %@: %@",[[Spotify currentTrack] artist], [[Spotify currentTrack] name]]];
            break;
        case SpotifyEPlSPlaying:
            NSLog(@"Spotify state: Playing(%d)", [Spotify playerState]);
            NSLog(@"Current track %@ by %@",[[Spotify currentTrack] name], [[Spotify currentTrack] artist]);

            [[statusItem button] setTitle:[NSString stringWithFormat:@"► %@: %@",[[Spotify currentTrack] artist], [[Spotify currentTrack] name]]];
            break;
        default:
            NSLog(@"Spotify state: Unsupported(%d)", [Spotify playerState]);

            // In any other case - show logo
            [[statusItem button] setTitle:[NSString stringWithFormat:@"●∿"]];
            [_SpotifyLaunchItem setHidden:NO];
    }
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Adding iTunes observer
    [[NSDistributedNotificationCenter defaultCenter] addObserver:self selector:@selector(updateDataFromiTunes:) name:@"com.apple.iTunes.playerInfo" object:nil];

    // Adding Spotify observer
    [[NSDistributedNotificationCenter defaultCenter] addObserver:self selector:@selector(updateDataFromSpotify:) name:@"com.spotify.client.PlaybackStateChanged" object:nil];

    // Registering iTunes
    iTunes = [SBApplication applicationWithBundleIdentifier:@"com.apple.iTunes"];
    // Registering Spotify
    Spotify = [SBApplication applicationWithBundleIdentifier:@"com.spotify.client"];

    // Creating status item
    statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength];

    // Here we go!
    NSLog(@"Creating menu");
    [statusItem setMenu:statusMenu];

    // First data update
    [self updateDataFromiTunes:nil];
    [self updateDataFromSpotify:nil];
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // removing Observers
    [[NSDistributedNotificationCenter defaultCenter] removeObserver:self];
}

- (IBAction)launchITunes:(id)sender{
    // Open iTunes and Update status
    [iTunes activate];
    [self updateDataFromiTunes:nil];
}

- (IBAction)launchSpotify:(id)sender{
    // Open Spotify and Update status
    [Spotify activate];
    [self updateDataFromSpotify:nil];
}

@end
