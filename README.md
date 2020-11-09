# FP-Risky-Brain

A 2D game made in Godot by kade-d and adamgack.

[Play Risky Brain](https://bsu-cs315.github.io/FP-Risky-Brain/)

## Instructions

Use `W` `A` `S` `D` to move your player. Use `left-click` to shoot. Use `R` to reload. Use `E` to interact with objects. Use `1` to change to primary weapon. Use `2` to change to secondary weapon.

## Project Report

### Reflection

This iteration was great fun to work through. We accomplished much more than we originally assigned in our plan. At the beginning of the iteration, we dedicated our work to consist largely of pair programming. All in all, over half of our programming sessions were paired which helped us to keep the structure of our code maintainable, as we were critiquing each other's choices in implementation. As a team, we were successful in sticking to our plan and completing features in order. We struggled with maintaining the warnings in the source code continuously. It seemed that after a few commits, we would have a pile of warnings that would all be addressed at once. In future iterations, we plan on refraining from git committing until the source code is free from warnings. Overall, this iteration presented new and interesting challenges that required a great deal of effort to work through.


### Self-Evaluation

- [X] D-1: The repository link is submitted to Canvas before the project deadline.
- [X] D-2: The repository contains a <code>README.md</code> file in its top-level directory.
- [X] D-3: The project content is eligible for an <a href="https://www.esrb.org/ratings-guide/">ESRB Rating</a> of M or less.
- [X] C-1: Your repository is well-formed, with an appropriate <code>.gitignore</code> file and no unnecessary files tracked.
- [X] C-2: Your release is tagged using <a href="https://semver.org/">semantic versioning</a> where the major version is zero, the minor version is the iteration number, and the patch version is incremented as usual for each change made to the minor version, and the release name matches the release tag.
- [X] C-3: You have a clear legal right to use all incorporated assets, and the licenses for all third-party assets are tracked in the <code>README.md</code> file.
- [X] C-4: The <code>README.md</code> contains instructions for how to play the game or such instructions are incorporated into the game itself.
- [X] C-5: The project content is eligible for an <a href="https://www.esrb.org/ratings-guide/">ESRB Rating</a> of T or less.
- [X] C-6: The release demonstrates the core gameplay loop: the player can take action that moves them toward a goal.
- [X] B-1: The <code>README.md</code> file contains a personal reflection on the iteration and self-evaluation, as defined above.
- [X] B-2: The game runs without errors or warnings.
- [X] B-3: The playable game is published to GitHub Pages and linked from the <code>README.md</code> file, or executable builds are provided for download as part of the GitHub release.
- [X] B-4: The source code and project structure comply with our adopted style guides.
- [X] B-5: Clear progress has been made on the game with respect to the project plan.
- [X] A-1: The source code contains no warnings: all warnings are properly addressed, not just ignored.
- [X] A-2: The game includes the conventional player experience loop of title, gameplay, and ending.
- [X] A-3: Earn <em>N</em>*&lceil;<em>P</em>/2&rceil; stars, where <em>N</em> is the iteration number and <em>P</em> is the number of people on the team.
- [ ] ⭐ Include a dynamic (non-static) camera
- [ ] ⭐ Incorporate parallax background scrolling
- [ ] ⭐ Use paper doll animations
- [ ] ⭐ Incorporate smooth transitions between title, game, and end states, rather than jumping between states via <code>change_scene</code>
- [ ] ⭐ Support both touch and mouse/keyboard input in the Web build
- [ ] ⭐ Allow the user to control the volume of music and sound effects independently.
- [X] ⭐ Incorporate juiciness and document it in the <code>README.md</code>
- [ ] ⭐ Incorporate another kind of juiciness and document it in the <code>README.md</code>
- [X] ⭐ Use particle effects
- [X] ⭐ Use different layers and masks to manage collisions and document this in the <code>README.md</code>
- [ ] ⭐ Incorporate pop into your HUD or title screen using <code>Tween</code> or <code>AnimationPlayer</code>
- [X] ⭐ Include an AI-controlled characters
- [ ] ⭐ Include an AI-controlled character controlled with a different AI
- [ ] ⭐ Add a pause menu that includes, at minimum, the ability to resume or return to the main menu
- [ ] ⭐ The game is released publicly on <code>itch.io</code>, with all the recommended accompanying text, screenshots, gameplay videos, <i>etc.</i>

As denoted by the requirements above, this project has earned the grade of A.


## Star Explanations
>⭐ Use different layers and masks to manage collisions and document this in the <code>README.md</code>
>
We used layers and masks to manage many collisions in the game. One example of this is the bullets fired from the player. These bullets have a mask that collides only with zombies and not players. This is so the player can not shoot themself.
>⭐ Incorporate juiciness and document it in the <code>README.md</code>
>
One example of juiciness from this game is the player's firing animation when they shoot the shotgun or the assault rifle.



## Third-Party Assets
[Assault Rifle Fire Sound](licenses/assault_rifle_fire.txt)<br>
[Shotgun Fire Sound](licenses/shotgun_fire.txt)<br>
[Staatliches Font](licenses/OFL.txt)<br>