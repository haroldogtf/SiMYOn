//
//  Myo.m
//  SiMYOn
//
//  Created by Haroldo Gondim on 18/04/15.
//
//

#import "Myo.h"
#import "Constants.h"
#import <MyoKit/MyoKit.h>

@implementation Myo

BOOL isConnected = NO;
BOOL isSynced    = NO;

+ (void)setSynced:(BOOL)synced;
{
    isSynced = synced;
}

+ (BOOL)isSynced
{
    return isSynced;
}

+ (void)setConnected:(BOOL)connected;
{
    isConnected = connected;
}

+ (BOOL)isConnected
{
    return isConnected;
}

+ (void) configureMyo {
    
    [[TLMHub sharedHub] setApplicationIdentifier:APP_IDENTIFIER];
    [[TLMHub sharedHub] setShouldSendUsageData:NO];
    [[TLMHub sharedHub] setShouldNotifyInBackground:YES];
    [[TLMHub sharedHub] setLockingPolicy:TLMLockingPolicyNone];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didConnectDevice)
                                                 name:TLMHubDidConnectDeviceNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didDisconnectDevice)
                                                 name:TLMHubDidDisconnectDeviceNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didSyncArm)
                                                 name:TLMMyoDidReceiveArmSyncEventNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didUnsyncArm)
                                                 name:TLMMyoDidReceiveArmUnsyncEventNotification
                                               object:nil];
}

+ (void) didConnectDevice {
    [Myo setConnected:YES];
}

+ (void) didDisconnectDevice {
    [Myo setConnected:NO];
}

+ (void) didSyncArm {
    [Myo setSynced:YES];
    NSLog(@"sync");
}

+ (void) didUnsyncArm {
    [Myo setSynced:NO];
    NSLog(@"unsync");
}

@end