//
//  SyncViewController.m
//  SiMYOn
//
//  Created by Haroldo Gondim on 23/02/15.
//
//

#import "SyncViewController.h"
#import "Constants.h"
#import "Util.h"
#import "Myo.h"
#import "GameViewController.h"
#import <MyoKit/MyoKit.h>

@interface SyncViewController ()

    @property (weak, nonatomic) IBOutlet UIImageView *imgBackground;

    @property (nonatomic) BOOL playSound;

@end

@implementation SyncViewController

- (id)initIsPlaySound:(BOOL)isPlaySound
{    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        self = [super initWithNibName:[Util selectNibNameByModel:NIB_SYNC]
                               bundle:nil];
    } else {
        self = [super init];
    }
    
    if(self) {
        self.playSound = isPlaySound;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self prepareMyoForSync];
    [self checkIfConnected];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)returnAction:(id)sender {
    [[NSNotificationCenter defaultCenter] removeObserver:self];

    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (IBAction)syncMyoAction:(id)sender {
    [self configureMyo];
}

- (IBAction)noMyoAction:(id)sender {
    [self goToGameUsingMyo:NO];
}

- (void) goToGameUsingMyo:(BOOL)yesOrNo {
    GameViewController *gameViewController = [[GameViewController alloc]init];
    gameViewController.playSound = self.playSound;
    gameViewController.usingMyo = yesOrNo;
    [self.navigationController pushViewController:gameViewController animated:YES];
}

- (void) prepareMyoForSync {
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didReceivePoseChange:)
                                                 name:TLMMyoDidReceivePoseChangedNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didConnectDevice)
                                                 name:TLMHubDidConnectDeviceNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didDisconnectDevice)
                                                 name:TLMHubDidDisconnectDeviceNotification
                                               object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didSyncArm:)
                                                 name:TLMMyoDidReceiveArmSyncEventNotification
                                               object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didUnsyncArm)
                                                 name:TLMMyoDidReceiveArmUnsyncEventNotification
                                               object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didUnlockDevice:)
                                                 name:TLMMyoDidReceiveUnlockEventNotification
                                               object:nil];
}

- (void) checkIfConnected {
    if([Myo isConnected]) {
        [self didConnectDevice];
    }
}

- (void) configureMyo {
    UINavigationController *controller = [TLMSettingsViewController settingsInNavigationController];
    [self presentViewController:controller animated:YES completion:nil];
}

- (void) configureMyoIfDisconneted {
    if(![Myo isConnected]) {
        [self configureMyo];
    }
}

- (void)didReceivePoseChange:(NSNotification*)notification {
    TLMPose *pose = notification.userInfo[kTLMKeyPose];
    [pose.myo unlockWithType:TLMUnlockTypeHold];
}

- (void)didConnectDevice {
    self.imgBackground.image = [UIImage imageNamed:IMG_SYNC2];
}

- (void)didDisconnectDevice {
    self.imgBackground.image = [UIImage imageNamed:IMG_SYNC1];

}

- (void)didSyncArm:(NSNotification *)notification {
    TLMArmSyncEvent *armEvent = notification.userInfo[kTLMKeyArmSyncEvent];

    BOOL isLeftArm = (armEvent.arm == TLMArmLeft);

    [[NSUserDefaults standardUserDefaults] setBool:isLeftArm forKey:IS_LEFT_ARM];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)didUnsyncArm {
    self.imgBackground.image = [UIImage imageNamed:IMG_SYNC1];
}

- (void)didUnlockDevice:(NSNotification *)notification {
    TLMPose *pose = notification.userInfo[kTLMKeyPose];
    [pose.myo unlockWithType:TLMUnlockTypeHold];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];

    [self goToGameUsingMyo:YES];
}

@end