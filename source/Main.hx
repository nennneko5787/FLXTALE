package;

#if desktop
import backends.Discord.DiscordClient;
#end
import flixel.FlxG;
import flixel.FlxGame;
import flixel.FlxState;
import flixel.tweens.FlxEase.EaseFunction;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween.TweenOptions;
import flixel.tweens.FlxTween;
import flixel.util.FlxTimer;
import lime.app.Application;
import openfl.Assets;
import openfl.Lib;
import openfl.display.FPS;
import openfl.display.Sprite;
import openfl.events.AsyncErrorEvent;
import openfl.events.Event;
import openfl.events.MouseEvent;
import openfl.events.NetStatusEvent;
import openfl.media.Video;
import openfl.net.NetConnection;
import openfl.net.NetStream;
import states.TitleState;

using StringTools;

// crash handler stuff
#if ErrorDialog
import haxe.CallStack;
import haxe.io.Path;
import openfl.events.UncaughtErrorEvent;
import sys.FileSystem;
import sys.io.File;
import sys.io.Process;
#end

class Main extends Sprite
{
	// This variable is copied from Friday Night Funkin': nekoEngine lol
	var game = {
		width: 640, // WINDOW width
		height: 480, // WINDOW height
		initialState: TitleState, // initial game state
		zoom: -1.0, // game state bounds
		framerate: 60, // default framerate
		skipSplash: false, // if the default flixel splash screen should be skipped
		startFullscreen: false // if the game should start at fullscreen mode
	};

	public static var fpsCounter:FPS;

	public function new()
	{
		trace("FLXTALE v" + Application.current.meta.get('version') + " is Initializing...");
		super();
		DiscordClient.initialize();

		#if !mobile
		fpsCounter = new FPS(10, 3, 0xFFFFFF);
		addChild(fpsCounter);
		#end

		#if ErrorDialog
		Lib.current.loaderInfo.uncaughtErrorEvents.addEventListener(UncaughtErrorEvent.UNCAUGHT_ERROR, onCrash);
		#end

		var stageWidth:Int = Lib.current.stage.stageWidth;
		var stageHeight:Int = Lib.current.stage.stageHeight;

		if (game.zoom == -1.0)
		{
			var ratioX:Float = stageWidth / game.width;
			var ratioY:Float = stageHeight / game.height;
			game.zoom = Math.min(ratioX, ratioY);
			game.width = Math.ceil(stageWidth / game.zoom);
			game.height = Math.ceil(stageHeight / game.zoom);
		}

		#if !debug
		// initialState = TitleState;
		#end

		addChild(new FlxGame(game.width, game.height, game.initialState, #if (flixel < "5.0.0") game.zoom, #end game.framerate, game.framerate,
			game.skipSplash, game.startFullscreen));
		trace("FLXTALE v" + Application.current.meta.get('version') + " is Ready!");
	}
}

// Code was entirely made by sqirra-rng for their fnf engine named "Izzy Engine", big props to them!!!
// very cool person for real they don't get enough credit for their work
#if ErrorDialog
function onCrash(e:UncaughtErrorEvent):Void
{
	var errMsg:String = "";
	var path:String;
	var callStack:Array<StackItem> = CallStack.exceptionStack(true);
	var dateNow:String = Date.now().toString();

	dateNow = dateNow.replace(" ", "_");
	dateNow = dateNow.replace(":", "'");

	path = "./crash/" + dateNow + ".txt";

	for (stackItem in callStack)
	{
		switch (stackItem)
		{
			case FilePos(s, file, line, column):
				errMsg += file + " (line " + line + ")\n";
			default:
				Sys.println(stackItem);
		}
	}

	errMsg += "\nUncaught Error: "
		+ e.error
		+ "\nPlease report this error to the GitHub page: https://github.com/nennneko5787/FNF-nekoEngine2\n\n> Crash Handler written by: sqirra-rng";

	if (!FileSystem.exists("./crash/"))
		FileSystem.createDirectory("./crash/");

	File.saveContent(path, errMsg + "\n");

	Sys.println(errMsg);
	Sys.println("Crash dump saved in " + Path.normalize(path));

	Application.current.window.alert(errMsg, "Error!");
	#if discord_rpc
	DiscordClient.shutdown();
	#end
	Sys.exit(1);
}
#end
