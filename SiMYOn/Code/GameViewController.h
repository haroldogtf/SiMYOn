//
//  GameViewController.h
//  SiMYOn
//
//  Created by Haroldo Gondim on 07/02/15.
//
//

#import <UIKit/UIKit.h>

@interface GameViewController : UIViewController

@property (nonatomic) BOOL playSound;
@property (nonatomic) BOOL usingMyo;

- (id)initIsPlaySound:(BOOL)isPlaySound andUseMyo:(BOOL)useMyo;

@end