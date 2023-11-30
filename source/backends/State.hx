package backends;

import flixel.FlxG;
import flixel.FlxState;
import flixel.text.FlxText;
import haxe.Timer;

class State extends FlxState
{
	public var currentFPS(default, null):Int;

	var overlayText:FlxText;
	@:noCompletion private var cacheCount:Int;
	@:noCompletion private var currentTime:Float;
	@:noCompletion private var times:Array<Float>;

	override public function create()
	{
		super.create();

		overlayText = new FlxText(12, 12, 0, "FPS: 0", 12);
		overlayText.font = Paths.font('Small');
		overlayText.scrollFactor.set();
		add(overlayText);
		currentFPS = 0;
		cacheCount = 0;
		currentTime = 0;
		times = [];

		if (FlxG.sound.music != null)
			FlxG.sound.music.stop();
		FlxG.mouse.useSystemCursor = true;
		FlxG.autoPause = false;
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);

		var now = Timer.stamp();

		times.push(now);

		while (times[0] < now - 1)
			times.shift();

		var currentCount = times.length;
		currentFPS = Math.round((currentCount + cacheCount) / 2);

		overlayText.text = "FPS: " + times.length;
	}
}
