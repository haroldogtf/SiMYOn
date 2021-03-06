//
//  Constants.h
//  SiMYOn
//
//  Created by Haroldo Gondim on 08/03/15.
//
//

#ifndef SiMYOn_Constants_h
#define SiMYOn_Constants_h

//Enums
typedef enum {
    TopMovement    = 0,
    LeftMovement   = 1,
    RightMovement  = 2,
    BottomMovement = 3
} Movement;

typedef enum {
    IPHONE_5_5C_5S_MODEL,
    IPHONE_6_MODEL,
    IPHONE_6_PLUS_MODEL,
    IPHONE_X_MODEL,
    IPHONE_NOT_SUPPORTED_MODEL
} IPhoneModel;

typedef enum {
    IPAD_9_7_MODEL,
    IPAD_10_5_MODEL,
    IPAD_12_9_MODEL,
    IPAD_NOT_SUPPORTED_MODEL
} IPadModel;

//Application
#define APP_IDENTIFIER [[NSBundle mainBundle] bundleIdentifier]

//Configuration
#define OFFLINE_RANKING 8

//Util
#define IPHONE_5_5C_5S_HEIGHT 568
#define IPHONE_6_HEIGHT       667
#define IPHONE_6_PLUS_HEIGHT  736
#define IPHONE_X_HEIGHT       812
#define IPAD_9_7_HEIGHT       1024
#define IPAD_10_5_HEIGHT      1112
#define IPAD_12_9_HEIGHT      1366

//Nibs
#define NIB_MENU           @"MainViewController"
#define NIB_SYNC           @"SyncViewController"
#define NIB_GAME           @"GameViewController"
#define NIB_GAMEOVER       @"GameOverViewController"
#define NIB_BESTSCORES     @"BestScoresViewController"
#define NIB_NOT_SUPPORTED  @"NotSupportedViewController"
#define NIB_IPHONE_5_5C_5S @""
#define NIB_IPHONE_6       @"_6"
#define NIB_IPHONE_6_PLUS  @"_6Plus"
#define NIB_IPHONE_X       @"_X"
#define NIB_IPAD_9_7       @"_iPad_9.7"
#define NIB_IPAD_10_5      @"_iPad_10.5"
#define NIB_IPAD_12_9      @"_iPad_12.9"

//Strings
#define SIMYON           @"SiMYOn"
#define BACK_MENU_ALERT  @"Are you sure to go back to menu?"
#define CONNECT_ALERT    @"Try to connect again?"
#define PERMISSION_ALERT @"To use Facebook data you must go to \"Settings > Facebook\" and allow SiMYOn to use your account"
#define STR_YES          @"Yes"
#define STR_NO           @"No"
#define STR_OK           @"Ok"
#define LOADING          @"Loading"
#define PLAY_WITH_MYO    @"Play with Myo"
#define PLAY_WITHOUT_MYO @"Play without Myo"
#define BEST_SCORES      @"Best Scores"

//Keys
#define SOUND_CONFIGURED @"soundConfigured"
#define PLAY_SOUND       @"playSound"
#define IS_LEFT_ARM      @"isLeftArm"
#define TURN             @"turn"
#define NAME             @"name"
#define SCORE            @"score"
#define DATE_TIME        @"date_time"
#define PLAYER_NAME      @"playerName"
#define PLAYER           @"player"
#define PLAYER_1         @"player1"
#define PLAYER_2         @"player2"
#define PLAYER_3         @"player3"
#define PLAYER_4         @"player4"
#define PLAYER_5         @"player5"
#define PLAYER_6         @"player6"
#define PLAYER_7         @"player7"
#define PLAYER_8         @"player8"
#define SCORE_PLAYER     @"scorePlayer"
#define SCORE_PLAYER_1   @"scorePlayer1"
#define SCORE_PLAYER_2   @"scorePlayer2"
#define SCORE_PLAYER_3   @"scorePlayer3"
#define SCORE_PLAYER_4   @"scorePlayer4"
#define SCORE_PLAYER_5   @"scorePlayer5"
#define SCORE_PLAYER_6   @"scorePlayer6"
#define SCORE_PLAYER_7   @"scorePlayer7"
#define SCORE_PLAYER_8   @"scorePlayer8"
#define INITAL_NAME      @"Player"
#define INITIAL_SCORE    @"0"
#define IN_ANIMATION     @"inAnimation"
#define RANKING          @"ranking"
#define CREATED_AT       @"createdAt"
#define USING_MYO        @"using_myo"

//Tags
#define RETURN_TO_MENU 0
#define CONFIGURE_MYO  1

//Assets
#define BTN_SOUND_ON                  @"btn_sound_on.png"
#define BTN_SOUND_OFF                 @"btn_sound_off.png"
#define IMG_SYNC1                     @"sync1.png"
#define IMG_SYNC2                     @"sync2.png"
#define IMG_GAME                      @"game.png"
#define IMG_GAME_TOP                  @"game_top.png"
#define IMG_GAME_LEFT                 @"game_left.png"
#define IMG_GAME_RIGHT                @"game_right.png"
#define IMG_GAME_BOTTOM               @"game_bottom.png"
#define IMG_BEST_SCORES               @"best_scores.png"
#define IMG_BEST_SCORES_NO_CONNECTION @"best_scores_no_connection.png"

//Sounds
#define SOUND_TOP    @"blip1.mp3"
#define SOUND_LEFT   @"blip2.mp3"
#define SOUND_RIGHT  @"blip3.mp3"
#define SOUND_BOTTOM @"blip4.mp3"
#define SOUND_GO     @"go.mp3"
#define SOUND_MISS   @"miss.mp3"

//Times
#define MOVEMENT_TIME  1
#define GO_TIME        2
#define NEW_TURN_TIME  .25
#define CLEAN_TIME     .5
#define ANIMATION_TIME .35

//Ranking
#define TOP_RANKING          12

#endif
