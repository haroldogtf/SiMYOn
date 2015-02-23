//
//  SyncViewController.h
//  SiMYOn
//
//  Created by Haroldo Gondim on 23/02/15.
//
//

#import <UIKit/UIKit.h>
#import <MyoKit/MyoKit.h>
#import "GameViewController.h"

@interface SyncViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIImageView *imgBackground;

- (IBAction)syncMyoAction:(id)sender;
- (IBAction)noMyoAction:  (id)sender;

@end