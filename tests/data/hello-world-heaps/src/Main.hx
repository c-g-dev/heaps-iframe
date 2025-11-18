
import h2d.Text;
import hxd.App;
import hxd.res.DefaultFont;

class Main extends App {
	override function init() {
		var txt = new Text(DefaultFont.get(), s2d);
		txt.text = "Hello Heaps Iframe";
	}

	static function main() {
		new Main();
	}
}


