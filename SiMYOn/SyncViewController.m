//
//  SyncViewController.m
//  SiMYOn
//
//  Created by Haroldo Gondim on 23/02/15.
//
//

#import "SyncViewController.h"

@interface SyncViewController ()

@end

@implementation SyncViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self prepareMyoForSync];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)syncMyoAction:(id)sender {
    [self configureMyo];
}

- (IBAction)noMyoAction:(id)sender {
    [self goToGameUsingMyo:NO];
}

- (void) goToGameUsingMyo:(BOOL)yesOrNo {
    GameViewController *gameViewController = [[GameViewController alloc]init];
    gameViewController.useMyo = yesOrNo;
    [self.navigationController pushViewController:gameViewController animated:YES];
}

- (void) prepareMyoForSync {
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didReceivePoseChange:)
                                                 name:TLMMyoDidReceivePoseChangedNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didConnectDevice:)
                                                 name:TLMHubDidConnectDeviceNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didDisconnectDevice:)
                                                 name:TLMHubDidDisconnectDeviceNotification
                                               object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didUnsyncArm:)
                                                 name:TLMMyoDidReceiveArmUnsyncEventNotification
                                               object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didUnlockDevice:)
                                                 name:TLMMyoDidReceiveUnlockEventNotification
                                               object:nil];
}

- (void) configureMyo {
    UINavigationController *controller = [TLMSettingsViewController settingsInNavigationController];
    [self presentViewController:controller animated:YES completion:nil];
}

- (void) ConfigureMyoIfDisconneted {
    if([[TLMHub sharedHub] myoDevices].count == 0) {
        [self configureMyo];
    }
}

- (void)didReceivePoseChange:(NSNotification*)notification {
//    TLMPose *pose = notification.userInfo[kTLMKeyPose];
//    [pose.myo unlockWithType:TLMUnlockTypeHold];
    
    NSLog(@"pose");
}

- (void)didConnectDevice:(NSNotification *)notification {
    self.imgBackground.image = [UIImage imageNamed:@"sync2.png"];
}

- (void)didDisconnectDevice:(NSNotification *)notification {
    self.imgBackground.image = [UIImage imageNamed:@"sync1.png"];
    
    NSLog(@"disconnet");

}

- (void)didUnsyncArm:(NSNotification *)notification {
    self.imgBackground.image = [UIImage imageNamed:@"sync1.png"];
    
    NSLog(@"unsync");

}

- (void)didUnlockDevice:(NSNotification *)notification {
    TLMPose *pose = notification.userInfo[kTLMKeyPose];
    [pose.myo unlockWithType:TLMUnlockTypeHold];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];

    [self goToGameUsingMyo:YES];
}

@end