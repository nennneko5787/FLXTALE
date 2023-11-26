# FLXTALE
We have not decided how to read it. Read it any way you like.
## Build
First, download and install [haxe](https://haxe.org/download/)  
Second, execute the following command at command prompt / PowerShell / Terminal.  
[(If you do not have Git installed, download it from here and install it.)](https://git-scm.com/)
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
```
(For Windows) Download [visual studio build tools](https://aka.ms/vs/17/release/vs_BuildTools.exe)  
On the Visual Studio installer screen, go to the "Individual components" tab and only select those options:
- MSVC v143 VS 2022 C++ x64/x86 build tools.
- Windows 10/11 SDK.

Games can be built with `lime test windows` or `lime test mac` or `lime test linux`. 