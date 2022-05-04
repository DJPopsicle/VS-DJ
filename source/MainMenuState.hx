package;

import flixel.graphics.FlxGraphic;
import flixel.input.gamepad.FlxGamepad;
import Controls.KeyboardScheme;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.effects.FlxFlicker;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.math.FlxMath;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import lime.app.Application;
import sys.io.File;
import sys.FileSystem;
#if FEATURE_DISCORD
import Discord.DiscordClient;
#end

using StringTools;

class MainMenuState extends MusicBeatState
{
	var curSelected:Int = 0;
	var lastSelected:Int = 0;

	var menuItems:FlxTypedGroup<FlxSprite>;

	#if !switch
	// var menuOptions:Array<String> = ['story mode', 'freeplay', 'donate', 'options'];
	var menuOptions:Array<String> = [
		'story_mode',
		'freeplay',
		#if MODS_ALLOWED 'mods',
		#end
		#if ACHIEVEMENTS_ALLOWED
		'awards',
		#end
		'credits',
		#if !switch 'donate',
		#end
		'options'
	];
	#else
	var menuOptions:Array<String> = ['story mode', 'freeplay'];
	#end

	var newGaming:FlxText;
	var newGaming2:FlxText;

	public static var firstStart:Bool = true;

	public static var nightly:String = "";

	public static var kadeEngineVer:String = "1.8.1" + nightly;
	public static var gameVer:String = "0.2.7.1";

	var magenta:FlxSprite;

	var dj:FlxSprite;

	var camFollow:FlxObject;
	var camFollowPos:FlxObject;

	var scale:Float = 1;

	var djScale:Float = 0.70;

	var djPos:Array<Float> = [-50, 0];

	public static var finishedFunnyMove:Bool = false;

	override function create()
	{
		trace(0 / 2);
		clean();
		PlayState.inDaPlay = false;
		#if FEATURE_DISCORD
		// Updating Discord Rich Presence
		DiscordClient.changePresence("In the Menus", null);
		#end

		if (!FlxG.sound.music.playing)
		{
			FlxG.sound.playMusic(Paths.music('freakyMenu'));
		}

		persistentUpdate = persistentDraw = true;

		var bg:FlxGraphic;
		var bgColor:FlxColor = FlxColor.fromRGB(133, 0, 34);
		bg = FlxGraphic.fromRectangle(4000, 4000, bgColor, true);

		var bgObj:FlxSprite = new FlxSprite(-100, 0, bg);
		bgObj.screenCenter();

		add(bgObj);

		var dots:FlxSprite = new FlxSprite(-100).loadGraphic(Paths.loadImage('mainmenu/assets/dots'));
		dots.scrollFactor.x = 0;
		dots.scrollFactor.y = 0.10;
		dots.setGraphicSize(Std.int(dots.width * 0.8));
		dots.updateHitbox();
		dots.screenCenter();
		dots.antialiasing = FlxG.save.data.antialiasing;
		add(dots);

		var split:FlxSprite = new FlxSprite(-100).loadGraphic(Paths.loadImage('mainmenu/assets/split'));
		split.scrollFactor.x = 0;
		split.scrollFactor.y = 0.10;
		split.setGraphicSize(Std.int(split.width * 0.8));
		split.updateHitbox();
		split.screenCenter();
		split.antialiasing = FlxG.save.data.antialiasing;
		add(split);

		camFollow = new FlxObject(0, 0, 1, 1);
		camFollowPos = new FlxObject(0, 0, 1, 1);
		add(camFollow);
		add(camFollowPos);

		// magenta = new FlxSprite(-80).loadGraphic(Paths.loadImage('menuDesat'));
		// magenta.scrollFactor.x = 0;
		// magenta.scrollFactor.y = 0.10;
		// magenta.setGraphicSize(Std.int(magenta.width * 1.1));
		// magenta.updateHitbox();
		// magenta.screenCenter();
		// magenta.visible = false;
		// magenta.antialiasing = FlxG.save.data.antialiasing;
		// magenta.color = 0xFFfd719b;
		// add(magenta);
		// magenta.scrollFactor.set();

		menuItems = new FlxTypedGroup<FlxSprite>();
		add(menuItems);

		var tex = Paths.getSparrowAtlas('FNF_main_menu_assets');

		for (i in 0...menuOptions.length)
		{
			var offset:Float = 108 - (Math.max(menuOptions.length, 4) - 4) * 80;
			var menuItem:FlxSprite = new FlxSprite(150, FlxG.height * 1.6);
			menuItem.scale.x = scale;
			menuItem.scale.y = scale;
			menuItem.frames = Paths.getSparrowAtlas('mainmenu/assets/menu_' + menuOptions[i]);
			menuItem.animation.addByPrefix('idle', menuOptions[i] + " basic", 24);
			menuItem.animation.addByPrefix('selected', menuOptions[i] + " white", 24);
			menuItem.animation.play('idle');
			menuItem.ID = i;
			// menuItem.screenCenter(X);
			menuItems.add(menuItem);
			menuItem.scrollFactor.set(0, 1);
			menuItem.antialiasing = FlxG.save.data.antialiasing;

			if (firstStart)
			{
				FlxTween.tween(menuItem, {y: 60 + (i * 160), x: 560 - (i * 50)}, 1 + (i * 0.25), {
					ease: FlxEase.expoInOut,
					onComplete: function(flxTween:FlxTween)
					{
						menuItem.y = 60 + (i * 160);
						menuItem.x = 560 - (i * 50);
						finishedFunnyMove = true;
						// changeItem(0, false);
					}
				});
			}
			else
			{
				menuItem.y = 60 + (i * 160);
				menuItem.x = 560 - (i * 50);
				// changeItem(0, true);
			}
		}

		var djSprName:String = menuOptions[curSelected];
		var path:String = Paths.image('mainmenu/dj/' + djSprName);
		path.toString();

		if (FileSystem.exists(path) || firstStart)
		{
			dj = new FlxSprite(djPos[0], djPos[1]).loadGraphic(Paths.loadImage('mainmenu/dj/' + 'story_mode'));
			add(dj);
			dj.scale.x = this.djScale;
			dj.scale.y = this.djScale;
			dj.scrollFactor.set();
			dj.antialiasing = FlxG.save.data.antialiasing;
			dj.updateHitbox();
		}

		dj.y += 700;

		FlxTween.tween(dj, {y: dj.y - 700}, 1, {
			ease: FlxEase.expoOut
		});

		firstStart = false;
		FlxG.camera.follow(camFollow, null, 0.60 * (60 / FlxG.save.data.fpsCap));
		FlxG.camera.follow(camFollowPos, null, 1);
		var versionShit:FlxText = new FlxText(5, FlxG.height - 18, 0, gameVer, 12);
		versionShit.scrollFactor.set();
		versionShit.setFormat("VCR OSD Mono", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(versionShit);
		// NG.core.calls.event.logEvent('swag').send();
		if (FlxG.save.data.dfjk)
			controls.setKeyboardScheme(KeyboardScheme.Solo, true);
		else
			controls.setKeyboardScheme(KeyboardScheme.Duo(true), true);
		changeItem(0, true);
		super.create();
	}

	var selectedSomethin:Bool = false;

	override function update(elapsed:Float)
	{
		if (FlxG.sound.music.volume < 0.8)
		{
			FlxG.sound.music.volume += 0.5 * FlxG.elapsed;
		}

		var lerpVal:Float = CoolUtil.boundTo(elapsed * 7.5, 0, 1);
		camFollowPos.setPosition(FlxMath.lerp(camFollowPos.x, camFollow.x, lerpVal), FlxMath.lerp(camFollowPos.y, camFollow.y, lerpVal));

		if (!selectedSomethin)
		{
			var gamepad:FlxGamepad = FlxG.gamepads.lastActive;

			if (gamepad != null)
			{
				if (gamepad.justPressed.DPAD_UP)
				{
					FlxG.sound.play(Paths.sound('scrollMenu'));
					changeItem(-1, true);
				}
				if (gamepad.justPressed.DPAD_DOWN)
				{
					FlxG.sound.play(Paths.sound('scrollMenu'));
					changeItem(1, true);
				}
			}

			if (FlxG.keys.justPressed.UP)
			{
				FlxG.sound.play(Paths.sound('scrollMenu'));
				changeItem(-1, true);
			}

			if (FlxG.keys.justPressed.DOWN)
			{
				FlxG.sound.play(Paths.sound('scrollMenu'));
				changeItem(1, true);
			}

			if (controls.BACK)
			{
				FlxG.switchState(new TitleState());
			}

			if (controls.ACCEPT)
			{
				if (menuOptions[curSelected] == 'donate')
				{
					FlxG.switchState(new AchievementsMenuState());
				}
				else
				{
					selectedSomethin = true;
					FlxG.sound.play(Paths.sound('confirmMenu'));

					if (FlxG.save.data.flashing)
						// FlxFlicker.flicker(magenta, 1.1, 0.15, false);

						menuItems.forEach(function(spr:FlxSprite)
						{
							FlxTween.tween(dj, {y: dj.y + 700}, 1, {
								ease: FlxEase.expoIn,
								onComplete: function(twn:FlxTween)
								{
									remove(dj);
								}
							});

							if (curSelected != spr.ID)
							{
								FlxTween.tween(spr, {alpha: 0}, 1.3, {
									ease: FlxEase.quadOut,
									onComplete: function(twn:FlxTween)
									{
										spr.kill();
									}
								});
							}
							else
							{
								if (FlxG.save.data.flashing)
								{
									FlxFlicker.flicker(spr, 1, 0.06, false, false, function(flick:FlxFlicker)
									{
										goToState();
									});
								}
								else
								{
									new FlxTimer().start(1, function(tmr:FlxTimer)
									{
										goToState();
									});
								}
							}
						});
				}
			}
		}

		super.update(elapsed);

		menuItems.forEach(function(spr:FlxSprite)
		{
			// spr.screenCenter(X);
		});
	}

	function goToState()
	{
		var daChoice:String = menuOptions[curSelected];

		switch (daChoice)
		{
			case 'story_mode':
				FlxG.switchState(new StoryMenuState());
				trace("Story Menu Selected");
			case 'freeplay':
				FlxG.switchState(new FreeplayState());

				trace("Freeplay Menu Selected");

			case 'options':
				FlxG.switchState(new OptionsDirect());
		}
	}

	function changeItem(huh:Int = 0, tween:Bool = false)
	{
		if (finishedFunnyMove)
		{
			if (huh != 0)
			{
				lastSelected = curSelected;
			}
			menuItems.forEach(function(spr:FlxSprite)
			{
				if (tween == true)
				{
					if (spr.ID == curSelected && finishedFunnyMove)
					{
						FlxTween.tween(spr, {x: spr.x + 50}, 0.5, {
							ease: FlxEase.expoOut
						});
					}
				}
			});
			curSelected += huh;

			if (curSelected >= menuItems.length)
			{
				lastSelected = curSelected - 1;
				curSelected = 0;
			}
			if (curSelected < 0)
			{
				lastSelected = curSelected;
				curSelected = menuItems.length - 1;
			}
			var djSprName:String = menuOptions[curSelected];
			var path:String = Paths.image('mainmenu/dj/' + djSprName);
			path.toString();

			if (FileSystem.exists(path))
			{
				// dj.y += 700;

				FlxTween.tween(dj, {y: dj.y + 700}, 1, {
					ease: FlxEase.expoIn,
					onComplete: function(twn:FlxTween)
					{
						remove(dj);
						dj = new FlxSprite(djPos[0], djPos[1] + 700).loadGraphic(Paths.loadImage('mainmenu/dj/' + djSprName));
						add(dj);

						FlxTween.tween(dj, {y: dj.y - 700}, 1, {
							ease: FlxEase.expoOut
						});
						dj.scale.x = this.djScale;
						dj.scale.y = this.djScale;
						dj.scrollFactor.set();
						dj.updateHitbox();
					}
				});
			}
			menuItems.forEach(function(spr:FlxSprite)
			{
				spr.animation.play('idle');
				spr.updateHitbox();

				if (spr.ID == curSelected)
				{
					spr.animation.play('selected');
					var add:Float = 0;
					if (menuItems.length > 4)
					{
						add = menuItems.length * 8;
					}
					camFollow.setPosition(spr.getGraphicMidpoint().x, spr.getGraphicMidpoint().y - add);
					spr.centerOffsets();
					if (tween == true)
					{
						FlxTween.tween(spr, {x: spr.x - 50}, 0.5, {
							ease: FlxEase.expoOut
						});
					}
					// FlxTween.tween(spr, {x: spr.x - 50}, 1, {
					// 	ease: FlxEase.expoOut
					// });
				}

				spr.animation.curAnim.frameRate = 24 * (60 / FlxG.save.data.fpsCap);

				spr.updateHitbox();
			});
		}
	}
}
