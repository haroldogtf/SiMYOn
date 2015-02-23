//
//  GameOverViewController.h
//  SiMYOn
//
//  Created by Haroldo Gondim on 21/02/15.
//
//

#import <UIKit/UIKit.h>
#import "GameOverViewController.h"

@interface GameOverViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel   *lblFinalScore;
@property (nonatomic)                NSInteger  score;

- (IBAction)returnAction:(id)sender;

@end