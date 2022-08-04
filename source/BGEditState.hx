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
import flixel.addons.ui.FlxSlider;
#if FEATURE_DISCORD
import Discord.DiscordClient;
#end

using StringTools;

class BGEditState extends MusicBeatState
{
	var scale:Float = 1;

	var dots:FlxSprite;
	var fg:FlxSprite;

	var bgHue:Int;
	var fgHue:Int;
	var splitHue:Int;

	var bgSlider:FlxSlider;
	var fgSlider:FlxSlider;
	var splitSlider:FlxSlider;

	var bgHSV:Array<Array<Int>> = [[0, 0, 0], [0, 0, 0], [0, 0, 0]];
	private var shaderArray:Array<ColorSwap> = [];
	var camFollow:FlxObject;
    

	public static var finishedFunnyMove:Bool = false;

	override function create()
	{
		var bg:FlxGraphic;
		var bgColor:FlxColor = FlxColor.fromRGB(77, 0, 3);
		bg = FlxGraphic.fromRectangle(4000, 4000, bgColor, true);
		var bgObj:FlxSprite = new FlxSprite(-100, 0, bg);
		bgObj.screenCenter();
		add(bgObj);
		dots = new FlxSprite(-30).loadGraphic(Paths.loadImage('mainmenu/assets/dots'));
		dots.scrollFactor.x = 0;
		dots.scrollFactor.y = 0.10;
		dots.setGraphicSize(Std.int(dots.width * 0.6));
		dots.updateHitbox();
		dots.screenCenter();
		dots.antialiasing = FlxG.save.data.antialiasing;
		add(dots);
		fg = new FlxSprite(-100, 200).loadGraphic(Paths.loadImage('mainmenu/assets/fg'));
		fg.scrollFactor.x = 0;
		fg.scrollFactor.y = 0.1;
		fg.setGraphicSize(Std.int(fg.width * 0.8));
		fg.updateHitbox();
		fg.screenCenter();
		fg.antialiasing = FlxG.save.data.antialiasing;
		add(fg);
		var split:FlxSprite = new FlxSprite(-100, 200).loadGraphic(Paths.loadImage('mainmenu/assets/split'));
		split.scrollFactor.x = 0;
		split.scrollFactor.y = 0.10;
		split.setGraphicSize(Std.int(split.width * 0.8));
		split.updateHitbox();
		split.screenCenter();
		split.antialiasing = FlxG.save.data.antialiasing;
		add(split);

		bgSlider = new FlxSlider(this, "bgHSV", 0, -100, 0, 255, 100, 15, 3, 0xFF000000, 0xFF828282);
		add(bgSlider);

		fgSlider = new FlxSlider(this, "fgHSV", 0, -200, 0, 255, 100, 15, 3, 0xFF000000, 0xFF828282);
		add(bgSlider);

		splitSlider = new FlxSlider(this, "splitHSV", 0, -300, 0, 255, 100, 15, 3, 0xFF000000, 0xFF828282);
		add(splitSlider);

		camFollow = new FlxObject(0, 0, 1, 1);
		add(camFollow);

		camFollow.setPosition(bgObj.getGraphicMidpoint().x, bgObj.getGraphicMidpoint().y);

		FlxG.camera.follow(camFollow, null, 0.60 * (60 / FlxG.save.data.fpsCap));

		super.create();
	}
}
