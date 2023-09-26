
# Godot 3D Base Project

This is a base Godot project with simple 3D FPS controller which you can use as a starting project for your game jams. Of course, feel free to use it as a starting project for your feature complete game as well.
This project should be complying with the Ludum Dare *Compo* rules as well, which state: "You’re free to start with **any** base-code you may have." This is a project that can help you to start very rapidly, but only contains the necessary busywork that has no effect on the gameplay.


## How to start

Clone this repository into your working folder and open `project.godot` in some text editor. Once open, edit these lines:

```
config/name="Base 3D Sample Project"
config/description="Base project for your needs."
```

The first line contains the name your project and the second line contains the description of your project.

Once you do that, just import the project into Godot. Eventually, you can import this project right away and rename it in the `Project` -> `Project settings` -> `Application` -> `Config`.


## Scene order

Project starts with a Splash scene (`SplashScene.tscn`), which displays two logos — one of them is usually used as your logo, second is usually used as a logo of the game jam you are participating in or as a logo of your game. 

Once both logos are displayed, the Splash scene automatically loads the Main menu scene (`MainMenuScene.tscn`). You can start a new game, which starts the `GameSceneOne.tscn` scene, you can switch between On/Off modes for sounds and music, display Credits (which starts the `CreditsScene.tscn` scene) or quit the game. *Quit game* button contains an extra check that disables it in case your game is running in HTML5, because quitting a HTML5 game would just unload it from the embed.


## Player controller

Project contains a very basic FPS controller. The player can:

* look around with the mouse
* move with `WASD`
* jump with `Space`
* sprint with `Shift` — this also increases FOV slightly for more dynamic feel
* pause with `Escape`

Key bindings contain some settings for gamepads as well, but this would have to be tested, so do not count on that (at least yet). Player scene also contains a RayCast which is outputting the current object that the player is looking at into the console. Feel free to uncomment it once you get a hang of it.

Player scene contains three additional screens, which are important to know about:

* `PauseScene` — if the player presses `Escape`, the Pause screne is displayed. Player can either continue, turn the music/sounds off (or on) or go to the main menu 
* `GameWonScene` — if the player wins, `is_game_won` turns to `true` and this scene is displayed. Once displayed, the player is unable to move
* `GameOverScene` — if the player loses, `is_game_over` turns to `true` and this scene is displayed. Once displayed, the player is unable to move 
* `TypewriterDialog` — used to display dialogs with `typewriter_dialog.start_dialog([dialog_array], delta)` (described below)


## Global scene

You can see that there is a `GlobalScene.tscn` scene in the project. This scene is autoloaded as a global right at the beginning, and contains `SfxPlayer`, which is set to play sounds and `MusicPlayer`, which is set to play music.

Sounds can be played by `play_sound(sfx_name)` and stopped by `stop_sound(sfx_name)`. 

Music can be played by `play_music()` and stopped by `stop_music()`. 


## Transition overlay

There is a global scene called Transition overlay (`TransitionOverlay.tscn`). This scene is taking care of "fade in" and "fade out" effects. Use this for smooth transitions between screens. You can simply call

```
transition_overlay.fade_in()
```

or

```
transition_overlay.fade_out()
```

from any code anywhere in order to display it. If you want to do something in your code after the fade in/out is complete, wait for the `transition_overlay.transition_completed` varible to turn `true`. It will turn `true` once the effect is played fully.


## Typewriter dialog

Player contains a Typewriter dialog node, which is assigned through the `typewriter_dialog` variable. In order to trigger a dialog, use this function in the Player code: 

```
typewriter_dialog.start_dialog(["First message.", "Second message."], delta)
```

The first parameter is an array of strings — those are separate dialogs that you want to display right after each other. This array can contain as many strings as you want. The other parameter of the function is `delta`, which should be self-explanatory and takes care of the dialog countdown (the time before another line is displayed automatically). If you do not have a delta available in your function, you can use `get_process_delta_time()`.


## Scripts

Scripts are separated in their separate `scripts` folder. Apart from `buttons` folder, they generally follow the same structure as their scene counterparts, so there is not much to describe here.


## Assets

This project contains `assets` folder with the following structure:

* **external** — this folder contains placeholders for covers and banners for *itch.io* & *Ludum Dare*.
* **fonts** — this folder contains a font package from Kenney, which are licenced as CC0.
* **music** — this folder contains a placeholder for your game music
* **sfx** — this folder contains a placeholder for your game sounds
* **visual** — this is a folder for your visual assets
  * **game_env** — this folder contains placeholders for the skybox and cubemap
  * **ui** — this folder contains placeholders for UI elements
    * **dialogue** — this folder contains placeholders for dialog character sprite and dialog text background
    * **logos** — this folder contains two placeholders for the Jam logo and your logo
    * **main_menu** — this folder contains placeholders for all menu buttons
    * **transition** — this folder contains black 1 x 1 px sprite used by `TransitionOverlay.tscn`. Transition overlay just scales the sprite according to the window resolution