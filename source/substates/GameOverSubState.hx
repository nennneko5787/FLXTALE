package substates;

import backends.Paths;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.util.FlxTimer;
import states.PlayState;

class GameOverSubState extends FlxSubState
{
	var camOver:FlxCamera;

	override public function create()
	{
		super.create();

		FlxG.sound.music.stop();

		camOver = new FlxCamera();
		camOver.bgColor.alpha = 0;

		// FlxG.cameras.reset(camGame);
		FlxG.cameras.add(camOver, false);

		var heart:FlxSprite = PlayState.instance.heart;
		heart.cameras = [camOver];
		var camGame:FlxCamera = PlayState.instance.camGame;
		camGame.visible = false;

		new FlxTimer().start(0.5, (timer:FlxTimer) ->
		{
			heart.loadGraphic(Paths.sprite('heart-broken'));
		}, 1);
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);
	}
}
