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
import flixel.group.FlxGroup;
import flixel.input.keyboard.FlxKey;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.ui.FlxBar;
import flixel.util.FlxColor;

class PlayState extends State
{
	var selected:Int = 0;
	final choices:Array<String> = ['Fight', 'Talk', 'Item', 'Spare'];
	var items:FlxTypedGroup<FlxSprite>;

	var stats:FlxText;
	var hpName:FlxSprite;
	var hpBar:FlxBar;
	var hpInfo:FlxText;

	var box:FlxShapeBox;
	var heart:FlxSprite;

	var dialogText:FlxTypeText;
	var defaultText:String;

	var choiceSelected:Bool = false;

	var monster:Monster;

	var camGame:FlxCamera;

	override public function create()
	{
		super.create();

		camGame = new FlxCamera();
		camGame.bgColor.alpha = 0;

		// FlxG.cameras.reset(camGame);
		FlxG.cameras.add(camGame, false);

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
		add(hpName);

		hpBar = new FlxBar(hpName.x + 35, hpName.y - 5, LEFT_TO_RIGHT, Std.int(Global.maxHp * 1.2), 20, Global, 'hp', 0, Global.maxHp);
		hpBar.createFilledBar(FlxColor.RED, FlxColor.YELLOW);
		// hpBar.emptyCallback = () -> FlxG.switchState(new GameOverState());
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

		heart = new FlxSprite(0, 0, Paths.sprite('heart'));
		heart.color = FlxColor.RED;
		heart.scrollFactor.set();
		heart.active = false;
		heart.cameras = [camGame];
		add(heart);

		defaultText = '* You feel like you\'re going to\n  have a bad time.';
		dialogText = new FlxTypeText(box.x + 14, box.y + 14, Std.int(box.width), defaultText, 32, true);
		dialogText.font = Paths.font('DTM-Mono');
		dialogText.sounds = [FlxG.sound.load(Paths.sound("txt2"), 0.86)];
		dialogText.scrollFactor.set();
		dialogText.cameras = [camGame];
		add(dialogText);
		dialogText.start(0.04, true);

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

		if (FlxG.keys.justPressed.Z)
		{
			FlxG.sound.play(Paths.sound('menuconfirm'));

			if (choiceSelected)
			{
				if (choices[selected] == 'Talk')
				{
					// TODO
				}
				else
				{
					dialogText.visible = false;

					// TODO
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
						dialogText.resetText('* ${monster.data.name}');
						dialogText.start(0.1, true);
						dialogText.skip();

					/*var monsterHpBar:FlxBar = new FlxBar(box.x + 158 + (monster.data.name.length * 16), writer.y, LEFT_TO_RIGHT,
							Std.int(monster.data.hp / monster.data.maxHp * 100), 16, monster.data, 'hp', 0, monster.data.maxHp);
						monsterHpBar.createFilledBar(FlxColor.RED, FlxColor.LIME);
						monsterHpBar.emptyCallback = () -> FlxG.log.notice('YOU WON!');
						monsterHpBar.scrollFactor.set();
						add(monsterHpBar); */
					case 'Item':
						dialogText.resetText('* Item Selected...');
						dialogText.start(0.1, true);
						dialogText.skip();
					case 'Spare':
						dialogText.resetText('* Mercy Selected...');
						dialogText.start(0.1, true);
						dialogText.skip();
				}
			}
		}
		else if (FlxG.keys.justPressed.X && choiceSelected)
		{
			choiceSelected = false;

			dialogText.visible = true;
			dialogText.resetText(defaultText);
			dialogText.start(0.04, true);
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
