package states;

import backends.Global;
import backends.Monster;
import backends.Paths;
import backends.State;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.display.shapes.FlxShapeBox;
import flixel.addons.text.FlxTypeText;
import flixel.addons.util.FlxAsyncLoop;
import flixel.group.FlxGroup;
import flixel.input.keyboard.FlxKey;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.tweens.FlxTween;
import flixel.ui.FlxBar;
import flixel.util.FlxAxes;
import flixel.util.FlxColor;
import flixel.util.FlxSpriteUtil;
import flixel.util.FlxTimer;
import substates.GameOverSubState;

class PlayState extends State
{
	public static var instance:PlayState;

	public var selected:Int = 0;

	final choices:Array<String> = ['Fight', 'Talk', 'Item', 'Spare'];

	public var items:FlxTypedGroup<FlxSprite>;

	public var stats:FlxText;
	public var hpName:FlxSprite;
	public var hpBar:FlxBar;
	public var hpInfo:FlxText;

	public var box:FlxShapeBox;
	public var heart:FlxSprite;

	public var targetSpr:FlxSprite;
	public var targetChoiceSpr_0:FlxSprite;
	public var targetChoiceSpr_1:FlxSprite;
	public var targetChoiceTween:FlxTween;

	public var attacked:Bool = false;
	public var isDanmaku:Bool = false;

	public var dialogText:FlxTypeText;
	public var defaultText:String;

	public var choiceSelected:Bool = false;
	public var choiceChoiced:Bool = false;

	public var monster:Monster;

	public var camGame:FlxCamera;

	override public function create()
	{
		super.create();

		instance = this;

		camGame = new FlxCamera();
		camGame.bgColor.alpha = 0;

		// FlxG.cameras.reset(camGame);
		FlxG.cameras.add(camGame, false);

		// Characters set
		monster = new Monster(0, 0, "Sans");

		stats = new FlxText(30, 400, 0, Global.name + '   LV ' + Global.lv, 22);
		stats.font = Paths.font('Small');
		stats.scrollFactor.set();
		stats.cameras = [camGame];
		add(stats);

		hpName = new FlxSprite(stats.x + 210, stats.y + 5, Paths.sprite('hpname'));
		hpName.scrollFactor.set();
		hpName.active = false;
		hpName.cameras = [camGame];
		hpBar.emptyCallback = () -> openSubState(new GameOverSubState());
		add(hpName);

		hpBar = new FlxBar(hpName.x + 35, hpName.y - 5, LEFT_TO_RIGHT, Std.int(Global.maxHp * 1.2), 20, Global, 'hp', 0, Global.maxHp);
		hpBar.createFilledBar(FlxColor.RED, FlxColor.YELLOW);
		hpBar.scrollFactor.set();
		hpBar.cameras = [camGame];
		add(hpBar);

		hpInfo = new FlxText((hpBar.x + 15) + hpBar.width, hpBar.y, 0, Global.hp + ' / ' + Global.maxHp, 22);
		hpInfo.font = Paths.font('Small');
		hpInfo.scrollFactor.set();
		hpInfo.cameras = [camGame];
		add(hpInfo);

		items = new FlxTypedGroup<FlxSprite>();

		for (i in 0...choices.length)
		{
			var bt:FlxSprite = new FlxSprite(0, hpBar.y + 32, Paths.sprite(choices[i].toLowerCase() + 'bt_1'));

			switch (choices[i])
			{
				case 'Fight':
					bt.x = 32;
				case 'Talk':
					bt.x = 185;
				case 'Item':
					bt.x = 345;
				case 'Spare':
					bt.x = 500;
			}

			bt.scrollFactor.set();
			bt.cameras = [camGame];
			bt.ID = i;
			items.add(bt);
		}

		add(items);

		box = new FlxShapeBox(32, 250, 570, 135, {thickness: 6, jointStyle: MITER, color: FlxColor.WHITE}, FlxColor.BLACK);
		box.scrollFactor.set();
		box.active = false;
		box.cameras = [camGame];
		add(box);

		defaultText = '* You feel like you\'re going to\n  have a bad time.';
		dialogText = new FlxTypeText(box.x + 14, box.y + 14, Std.int(box.width), defaultText, 32, true);
		dialogText.font = Paths.font('DTM-Mono');
		dialogText.sounds = [FlxG.sound.load(Paths.sound("txt2"), 0.86)];
		dialogText.scrollFactor.set();
		dialogText.cameras = [camGame];
		add(dialogText);
		dialogText.start(0.04, true);

		heart = new FlxSprite(0, 0, Paths.sprite('heart'));
		heart.color = FlxColor.RED;
		heart.scrollFactor.set();
		heart.active = false;
		heart.cameras = [camGame];
		add(heart);

		targetSpr = new FlxSprite(dialogText.x - 2, dialogText.y - 2, Paths.sprite('target'));
		targetSpr.scrollFactor.set();
		targetSpr.active = false;
		targetSpr.cameras = [camGame];
		targetSpr.visible = false;
		add(targetSpr);

		targetChoiceSpr_1 = new FlxSprite(dialogText.x - 2, dialogText.y - 10, Paths.sprite('targetchoice_1'));
		targetChoiceSpr_1.scrollFactor.set();
		targetChoiceSpr_1.cameras = [camGame];
		targetChoiceSpr_1.visible = false;
		add(targetChoiceSpr_1);

		targetChoiceSpr_0 = new FlxSprite(dialogText.x - 2, dialogText.y - 10, Paths.sprite('targetchoice_0'));
		targetChoiceSpr_0.scrollFactor.set();
		targetChoiceSpr_0.cameras = [camGame];
		targetChoiceSpr_0.visible = false;
		add(targetChoiceSpr_0);

		changeChoice();
		choiceSelected = false;

		FlxG.sound.playMusic(Paths.music('battle1'));
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);
		// camGame.angle += 1;
		if (FlxG.keys.justPressed.ESCAPE)
			FlxG.switchState(new TitleState());
		else if (FlxG.keys.justPressed.LEFT && !choiceSelected)
			changeChoice(-1);
		else if (FlxG.keys.justPressed.RIGHT && !choiceSelected)
			changeChoice(1);

		if (!choiceChoiced)
		{
			if (FlxG.keys.justPressed.Z)
			{
				FlxG.sound.play(Paths.sound('menuconfirm'));

				if (choiceSelected)
				{
					heart.visible = false;
					switch (choices[selected])
					{
						case 'Fight':
							targetChoiceSpr_0.x = dialogText.x - 2;
							targetChoiceSpr_1.x = dialogText.x - 2;
							choiceChoiced = true;
							dialogText.visible = false;
							targetSpr.visible = true;
							targetChoiceSpr_1.visible = true;
							trace("unun");
							targetChoiceTween = FlxTween.tween(targetChoiceSpr_1, {x: box.width + 20, y: dialogText.y - 10}, 2);
							targetChoiceTween.start();
					}
				}
				else
				{
					dialogText.visible = true;

					if (choices[selected] == 'Item' && Global.items.length <= 0)
						return;

					choiceSelected = true;

					switch (choices[selected])
					{
						case 'Fight' | 'Talk':
							heart.setPosition(box.x + 16, box.y + 26);
							dialogText.resetText('* ${monster.data.name}');
							dialogText.start(0.1, true);
							dialogText.skip();
						case 'Item':
							heart.setPosition(box.x + 16, box.y + 26);
							dialogText.resetText('* Item Selected...');
							dialogText.start(0.1, true);
							dialogText.skip();
						case 'Spare':
							heart.setPosition(box.x + 16, box.y + 26);
							dialogText.resetText('* Mercy Selected...');
							dialogText.start(0.1, true);
							dialogText.skip();
					}
				}
			}
			else if (FlxG.keys.justPressed.X && choiceSelected)
			{
				choiceSelected = false;
				changeChoice();

				dialogText.visible = true;
				dialogText.resetText(defaultText);
				dialogText.start(0.04, true);
			}
		}
		else
		{
			if (FlxG.keys.justPressed.Z)
			{
				if (targetChoiceTween.active)
				{
					targetChoiceTween.cancel();
					FlxG.sound.play(Paths.sound('slice'));
					targetChoiceSpr_0.x = targetChoiceSpr_1.x;
					attacked = true;
					monster.health -= 10;
					new FlxTimer().start(1, (timer:FlxTimer) ->
					{
						attacked = false;
						targetChoiceSpr_0.visible = false;
						targetChoiceSpr_1.visible = false;
						targetSpr.visible = false;
						var boxTween:FlxTween = FlxTween.tween(box, {x: 248.875, shapeWidth: box.shapeHeight}, 0.5, {
							onComplete: function(tween:FlxTween):Void
							{
								changeChoice();
								heart.x = ((box.x - box.offset.x) + box.shapeWidth / 2) - heart.width;
								heart.y = ((box.x - box.offset.y) + box.shapeWidth / 2) - heart.height;
								heart.visible = true;
								isDanmaku = true;
							}
						});
						boxTween.start();
					}, 1);
				}
			}
			else if (attacked)
			{
				targetChoiceSpr_0.visible = !targetChoiceSpr_0.visible;
			}
			else if (isDanmaku)
			{
				if (FlxG.keys.pressed.UP)
					heart.y -= Global.speed;
				if (FlxG.keys.pressed.DOWN)
					heart.y += Global.speed;
				if (FlxG.keys.pressed.LEFT)
					heart.x -= Global.speed;
				if (FlxG.keys.pressed.RIGHT)
					heart.x += Global.speed;
				Global.hp -= 1;

				FlxSpriteUtil.bound(heart, box.x, (box.x + box.shapeWidth), box.y, (box.y + box.shapeHeight));
			}
		}
	}

	private function changeChoice(num:Int = 0):Void
	{
		if (num != 0)
			FlxG.sound.play(Paths.sound('menumove'));

		selected = FlxMath.wrap(selected + num, 0, choices.length - 1);

		items.forEach(function(spr:FlxSprite)
		{
			if (spr.ID == selected)
			{
				spr.loadGraphic(Paths.sprite(choices[spr.ID].toLowerCase() + 'bt_0'));

				heart.setPosition(spr.x + 8, spr.y + 14);
			}
			else
				spr.loadGraphic(Paths.sprite(choices[spr.ID].toLowerCase() + 'bt_1'));
		});
	}
}
