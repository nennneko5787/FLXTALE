# FLXTALE
* We have not decided how you should read this. Read it any way you like.
## How to build
* First, download and install [haxe](https://haxe.org/download/)  
* Second, execute the following command at command prompt / PowerShell / Terminal.  
* [(If you do not have Git installed, download it from here and install it.)](https://git-scm.com/)
```
haxelib install lime 8.0.1
haxelib install openfl 9.2.1
haxelib install flixel 5.2.2
haxelib run lime setup flixel
haxelib run lime setup
haxelib install flixel-tools 1.5.1
haxelib run flixel-tools setup
haxelib install flixel-addons 3.0.2
haxelib install flixel-ui 2.5.0
haxelib git discord_rpc https://github.com/Aidan63/linc_discord-rpc
haxelib set lime 8.0.1
haxelib set openfl 9.2.1
haxelib set flixel 5.2.2
haxelib set flixel-tools 1.5.1
haxelib set flixel-addons 3.0.2
haxelib set flixel-ui 2.5.0
```
(For Windows) Download [visual studio build tools](https://aka.ms/vs/17/release/vs_BuildTools.exe)  
On the Visual Studio installer screen, go to the "Individual components" tab and only select those options:
- MSVC v143 VS 2022 C++ x64/x86 build tools.
- Windows 10/11 SDK.

The game can be built with `lime build windows` if you're on windows, `lime build mac` if you're on MacOS or `lime build linux` if you're on a linux distro. 
