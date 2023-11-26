package backends;

import backends.Paths;
import flixel.group.FlxSpriteGroup;
import haxe.Json;
import openfl.utils.Assets;

typedef MonsterData =
{
	name:String,
	health:Int,
	maxHealth:Int,
	attack:Float,
	defense:Float,
	xpReward:Int,
	goldReward:Int
};

class Monster extends FlxSpriteGroup
{
	public var data(default, null):MonsterData;

	public function new(x:Float = 0, y:Float = 0, name:String):Void
	{
		super(x, y);
		data = {
			name: name,
			health: 50,
			maxHealth: 50,
			attack: 0,
			defense: 0,
			xpReward: 0,
			goldReward: 0
		};
	}
}
