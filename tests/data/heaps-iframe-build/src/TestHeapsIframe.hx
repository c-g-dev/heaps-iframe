
import js.Browser;
import js.html.Element;
import heaps.iframe.HeapsIframe;

class TestHeapsIframe {
	static function main() {
		Browser.window.onload = function() {
			final root = createContainer("root");
			HeapsIframe.createHeapsIframe({
				container: root,
				jsUrl: "hello-world.js",
				title: "Test Heaps App"
			});

			final root2 = createContainer("root2");
			HeapsIframe.createHeapsIframe({
				container: root2,
				jsUrl: "hello-world.js",
				width: 800,
				height: "50vh",
				background: "#123456"
			});
		};
	}

	static function createContainer(id:String):Element {
		final el = Browser.document.createElement("div");
		el.id = id;
		Browser.document.body.appendChild(el);
		return el;
	}
}


