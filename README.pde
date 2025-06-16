/*
 IMAGES I DREW MYSELF:
 - Instruction page arrows and space bar symbols (MADE THEM IN FIGMA)
 - HEALTH TOKEN IMAGE (MADE THEM IN FIGMA)
 
 
 IN LEVEL 01: PLAYER'S SPEED IS FAST, TEHRE ARE NO ENEMIES ON BLOCKS.. AND PLAYERS EASILY SECURES A KEY
 IN LEVEL 02: PLAYER'S SPEED IS A BIT SLOWER(INDICATING HE'S GETTING TIRED), THERE ARE ENEMIES ON BLOCKS, PLAYER NEEDS TO LOCATE THE  TREASURE
 IN LEVEL 03: PLAYER'S SPEED IS EVEN MORE SLOWER, THERE ARE MORE ENEMIES ON THE BLOCK.. MAKING IT HARDER TO REACH JASMINE
 
 
 SOME SPECIAL FEATURES I INCLUDED:
 - SEQUENCE ANIMATION OF ALADDIN
 - RANDOM POSITION OF BLOCKS EVERYTIME
 - SEQUENCE ANIMATION FOR ENEMY SNAKES
 - SEQUENCE ANIMATION FOR JASMINE
 - MAKING THE TRESURE AND PRINCESS JASMINE APPEAR AFTER A FEW SECONDS
 
 
 -------------------- oop requirements - fulfilled :) --------------------
INHERITANCE
- i made 2 main superclasses – Token and Block – and each has multiple subclasses like
- Coin, Key, Treasure, Health, MovingBlock, and SlipperyBlock
- also have a sub-subclass: Coin extends Token, and Coin's drawMe() overrides and adds its own logic

OVERRIDING POLYMORPHISM
- i have more than 4 methods that override their parent class methods – for example:
- Coin.drawMe()
- Key.drawMe()
- Treasure.drawMe()
- Health.drawMe()
- SlipperyBlock.drawMe()


INCLUSION POLYMORPHISM
- i use an ArrayList<Token> to store all kinds of tokens (coins, key, treasure, etc)


CONTATINMENT
- my Token class has a Block field, so every token is attached to a block(has a relationship)


 --------------------------------------------------------------------------------------------------------------------------------------
 
 

 
 
 
 
 OTHER IMAGES REFERENCES:
 
 ALADDIN GIF (WHICH I USED FOR SEQUENCE ANIMATION) - https://gamehistory.org/aladdin-source-code/
 COIN SPINNING SEQUENCE - https://opengameart.org/content/spinning-coin-anim
 BACKGROUND - https://www.artstation.com/artwork/8bOKKG
 KEY IMAGE - https://opengameart.org/content/key-icons
 ALADDIN AND JASMINE IMAGE: https://toppng.com/show_download/195118/aladdin-aladdin-e-jasmine-3-png-aladdin-and-jasmine
 JINN IMAGE: https://ladygeekgirl.wordpress.com/2015/02/23/magical-mondays-omniscience-and-aladdins-genie/
 PRINCESS JASMINE SEQUENCE ANIMATION: https://tenor.com/en-CA/view/disney-princess-jasmine-aladdin-sad-gif-16982856564758729798
 TREASURE IMAGE: https://www.shutterstock.com/image-vector/isometric-icon-open-wooden-chest-full-2031447185
 
 
 AUDIO REFERNCES:
 TITLE SCREEN BG MUSIC:  https://www.youtube.com/watch?v=hkKeIHJMBpU&list=PLy_Q-5e78AnwwFIjwYiDNdPS4BXsBSCkq&index=7
 MAIN GAME BG MUSIC: https://www.youtube.com/watch?v=YkLKhKT8X6I
 ALADDIN JUMP SOUND: https://freesound.org/people/kfatehi/sounds/363921/
 COIN COLLECT SOUND: https://freesound.org/people/SoundDesignForYou/sounds/646672/
 GAME OVER SOUND: https://freesound.org/people/DodgeCreator/sounds/761384/
 LEVEL CHANGE SOUND: https://freesound.org/people/Ranner/sounds/534797/
 
 
 
 
 */
