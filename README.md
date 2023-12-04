# FLXTALE
* We have not decided what to call this. Please call it whatever you like.
## How to build
* First, download and install [haxe](https://haxe.org/download/)  
* Second, execute the following command at command prompt / PowerShell / Terminal.  
* [(If you do not have Git installed, download it from here and install it.)](https://git-scm.com/)
```
haxelib install hmm
haxelib run hmm install
haxelib run lime setup flixel
haxelib run lime setup
haxelib run flixel-tools setup
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
