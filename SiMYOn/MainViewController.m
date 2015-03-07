//
//  MainViewController.m
//  SiMYOn
//
//  Created by Haroldo Gondim on 07/02/15.
//
//

#import "MainViewController.h"

@interface MainViewController ()

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self updateSoundStatus];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void) openViewController:(UIViewController *) viewController {
    [self.navigationController pushViewController:viewController animated:YES];
}

- (IBAction)gameStarterAction:(id)sender {
    
    BOOL playSound = [self getSoundStatus];
    
    if([[TLMHub sharedHub] myoDevices].count == 0) {
        [self openViewController:[[SyncViewController alloc]initIsPlaySound:playSound]];
    } else {
        [self openViewController:[[GameViewController alloc]initIsPlaySound:playSound]];
    }
}

- (IBAction)intructionsAction:(id)sender {
    [self openViewController:[[InstructionsViewController alloc]init]];
}

- (IBAction)bestScoresAction:(id)sender {
    BestScoresViewController *bestScoresViewController = [[BestScoresViewController alloc]init];
    [self openViewController:bestScoresViewController];
}

- (IBAction)creditsAction:(id)sender {
    [self openViewController:[[CreditsViewController alloc]init]];
}

- (IBAction)soundAction:(id)sender {
    BOOL playSound = [self getSoundStatus];
    [[NSUserDefaults standardUserDefaults] setBool:!playSound forKey:@"playSound"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [self updateSoundStatus];
}

- (BOOL) getSoundStatus {
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"playSound"];
}

- (void) updateSoundStatus {
    if([self getSoundStatus]) {
        [self.btnSound setImage:[UIImage imageNamed:@"btn_sound_on.png"] forState:UIControlStateNormal];
    } else {
        [self.btnSound setImage:[UIImage imageNamed:@"btn_sound_off.png"] forState:UIControlStateNormal];
    }
}

- (IBAction)exitAction:(id)sender {
    UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"SiMYOn"
                                                      message:@"Are you sure to exit the game?"
                                                     delegate:self
                                            cancelButtonTitle:@"No"
                                            otherButtonTitles:@"Yes", nil];
    [message show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger *)buttonIndex
{
    if(buttonIndex) {
        exit(0);
    }
}

@end