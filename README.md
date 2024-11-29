why no readme‽
documentation is essential to any project!

This can be a place holder for Project Nexus: A GoDot Project;

# Getting Started

## Arch Linux

I would assume the process is the same across any linux distribution and probably even Windows, or Mac.  Although zero testing has been allocated to mac functionality.
* Clone this project where you plan to work on it.
* Open Godot. Doing so should bring up the Project Manager.
* Find and press the import button, and select the ProjectNexus folder you just finished cloning
BADA BING BADA BOOM! you are up and running


# Bringing in your game

So I am not sure how rayool brought in DodgeTheJareds, but I created an Audio folder in the root directory, and then created DodgeDeezNuts folders in Art, Audio, and Scenes/Games to import all of my files. I then opened each file and it managed to find the artwork automatically, but it would have "dependency issues" from not finding the files. The interface allows you to teach it the path to all the files.

Now I am trying to find the button and how to teach it to grab my main scene. I wouldn't be surprise if there is a better way to import it into our project.

## Input map WARNING!

when bringing in your game, you may want to change the codebase to the convention of this input map or find a way to import yours, or sneak a peak at how super_main_menu.gd dynamically adds and removes your entry into the input map.

# Untitled Game 

A place to start developing our next big game. We've figured out TileMapLayers in this bitch

# Manic Messenger

Based on discord convo with Tanawat to make a Crazy Taxi clone but as a bicycle messenger.
Map Scene has been created. The map has been created as multiple TileMapLayers.
The bottom layer Labeled "OOB" is just water. There might be too much water at the moment.
The amount of water is to insure the camera doesn't show an empty map tile.
Ground Layer is kind of just defining the island at the moment with grass.
The ground could be expanded considering that there is so much water at the moment.
This is mostly a proof of concept type thing anyway.
If this were to become more fleshed out, we'd probably want our own custom artwork.
