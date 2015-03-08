//
//  Constants.h
//  SiMYOn
//
//  Created by Haroldo Gondim on 08/03/15.
//
//

#ifndef SiMYOn_Constants_h
#define SiMYOn_Constants_h

//Enum
typedef enum {
    TopMovement    = 0,
    LeftMovement   = 1,
    RightMovement  = 2,
    BottomMovement = 3
} Movement;

//Application
#define APP_IDENTIFIER @"br.ufpe.cin.SiMYOn"

//Strings
#define SIMYON          @"SiMYOn"
#define EXIT_GAME_ALERT @"Are you sure to exit the game?"
#define BACK_MENU_ALERT @"Are you sure to go back to menu?"
#define STR_YES         @"Yes"
#define STR_NO          @"No"

//Keys
#define SOUND_CONFIGURED @"soundConfigured"
#define PLAY_SOUND       @"playSound"
#define IS_LEFT_ARM      @"isLeftArm"
#define TURN             @"turn"
#define NAME             @"name"
#define SCORE            @"score"
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
#define TEST_CONNECTION  @"http://www.parse.com"
#define RANKING          @"ranking"
#define CREATED_AT       @"createdAt"
#define USING_MYO        @"using_myo"

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

//Parse
#define PARSE_APPLICATION_ID @"mxVK7rpNAZjBeIzkJ2qojoALb3aPb2Vate5X4I6Q"
#define PARSE_CLIENT_KEY     @"IzHTVKmzOUZQFz5rkRi1VReErvmbFyvLgwf2DOjF"

#endif