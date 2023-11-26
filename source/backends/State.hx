package backends;

import flixel.FlxG;
import flixel.FlxState;

class State extends FlxState
{
	override public function create()
	{
		super.create();
		if (FlxG.sound.music != null)
			FlxG.sound.music.stop();
		FlxG.mouse.useSystemCursor = true;
		FlxG.autoPause = false;
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);
	}
}
