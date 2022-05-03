import flixel.FlxG;
import flixel.FlxSprite;
import flixel.util.FlxColor;

class OptionsDirect extends MusicBeatState
{
	var menuBG:FlxSprite;

	override function create()
	{
		FlxG.camera.fade(FlxColor.BLACK, 0.8, true);
		Paths.clearStoredMemory();
		Paths.clearUnusedMemory();

		menuBG = new FlxSprite().loadGraphic(Paths.image("menuDesat"));
		menuBG.color = 0xFFea71fd;
		menuBG.setGraphicSize(Std.int(menuBG.width * 1.1));
		menuBG.updateHitbox();
		menuBG.screenCenter();
		menuBG.antialiasing = FlxG.save.data.antialiasing;
		add(menuBG);
		openSubState(new OptionsMenu());
	}
}
