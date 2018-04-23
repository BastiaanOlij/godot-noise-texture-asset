Godot Noise Textures
====================

Introduction
------------
This repository contains a number of scenes that allow you to create fast random generated noise textures in Godot. 
Just add the appropriate scene from ```addons/noise-textures``` as a subscene in your project and it will add a viewport node into which the noise texture will be rendered. The noise texture is only rendered if any of its settings change.

You can then use the noise texture in your shaders or on your materials by using a ViewportTexture and assigning the viewport.
Note that if the texture renders black you may need to turn on "local to scene" on your material.

(note, at the time of writing this only worley noise has been added, I'm working on porting open simplex and hope to add this soon)

Example project
---------------
In the root of this project you will find an example of using the noise functions. This is a really simple example that shows the different colour channels of the generated texture and applies the noise to a very simple heightfield.

License
-------
This project is MIT licensed, see the license file. 
I would appreciate a mention if you find this useful and end up using it in your project however this is not a requirement.
