package heaps.iframe;


import js.Browser;
import js.html.Element;
import js.html.IFrameElement;
import js.html.URL;
import haxe.DynamicAccess;
import haxe.extern.EitherType;

typedef HeapsIframeOptions = {
	?container: EitherType<String, Element>,
	jsUrl: String,
	?width: EitherType<Int, String>,
	?height: EitherType<Int, String>,
	?background: String,
	?fullscreen: Bool,
	?allow: String,
	?sandbox: String,
	?title: String,
	?id: String,
	?className: String,
	?loading: String,
	?style: DynamicAccess<String>
}

class HeapsIframe {
	public static function createHeapsIframe(options:HeapsIframeOptions):IFrameElement {
		if (options == null || options.jsUrl == null || options.jsUrl == "") {
			throw "HeapsIframe.createHeapsIframe: jsUrl is required";
		}

		final container = resolveContainer(options.container);
		final baseHref = computeBaseHref(options.jsUrl);

		final iframe:IFrameElement = cast Browser.document.createElement("iframe");
		if (options.id != null) iframe.id = options.id;
		if (options.className != null) iframe.className = options.className;
		iframe.title = options.title != null ? options.title : "Heaps App";
		iframe.setAttribute("loading", options.loading != null ? options.loading : "eager");

		final allowFullscreen = options.fullscreen == null || options.fullscreen;
		if (allowFullscreen) iframe.setAttribute("allowfullscreen", "");

		final allowDefault = "autoplay; fullscreen; gamepad; xr-spatial-tracking";
		iframe.setAttribute("allow", options.allow != null ? options.allow : allowDefault);

		final sandboxDefault = "allow-scripts allow-same-origin allow-pointer-lock allow-forms allow-popups allow-popups-to-escape-sandbox allow-modals";
		iframe.setAttribute("sandbox", options.sandbox != null ? options.sandbox : sandboxDefault);

		// Sizing and basic styles
		iframe.style.border = "0";
		iframe.style.display = "block";
		iframe.style.width = toCssSize(options.width, "100%");
		iframe.style.height = toCssSize(options.height, "600px");

		// Additional styles (if provided)
		if (options.style != null) {
			for (k in options.style.keys()) {
				untyped iframe.style[k] = options.style[k];
			}
		}

		final background = options.background != null ? options.background : "#000";
		final html = buildIframeHtml(baseHref, options.jsUrl, background);

		iframe.src = "about:blank";
		// Use attribute to set srcdoc to avoid depending on extern field presence
		iframe.setAttribute("srcdoc", html);

		container.appendChild(iframe);
		return iframe;
	}

	public static inline function createHeapsIFrame(options:HeapsIframeOptions):IFrameElement {
		return createHeapsIframe(options);
	}

	static function resolveContainer(container:EitherType<String, Element>):Element {
		if (container == null) return Browser.document.body;
		if (Std.isOfType(container, String)) {
			final selector:String = cast container;
			final el = Browser.document.querySelector(selector);
			if (el == null) {
				throw 'HeapsIframe.createHeapsIframe: container selector not found: $selector';
			}
			return el;
		}
		return cast container;
	}

	static function computeBaseHref(resourceUrl:String):String {
		final absolute = new URL(resourceUrl, Browser.document.baseURI);
		final dir = new URL("./", absolute.href);
		return dir.href;
	}

	static function toCssSize(value:EitherType<Int, String>, defaultValue:String):String {
		if (value == null) return defaultValue;
		if (Std.isOfType(value, Int) || Std.isOfType(value, Float)) {
			return Std.string(value) + "px";
		}
		return Std.string(value);
	}

	static function buildIframeHtml(baseHref:String, jsUrl:String, background:String):String {
		final css = [
			'html,body{margin:0;padding:0;width:100%;height:100%;overflow:hidden;background:' + background + ';}',
			'canvas{display:block;outline:none;}'
		].join("");

		return [
			"<!doctype html>",
			"<html>",
			"<head>",
			'<meta charset="utf-8">',
			'<meta name="viewport" content="width=device-width, initial-scale=1, viewport-fit=cover">',
			'<base href="' + escapeHtml(baseHref) + '">',
			"<style>" + css + "</style>",
			"</head>",
			"<body>",
			'<canvas id="webgl" tabindex="1" width="1000" height="1000"></canvas>',
			'<script src="' + escapeHtml(jsUrl) + '"></script>',
			"</body>",
			"</html>"
		].join("");
	}

	static function escapeHtml(str:String):String {
		return str
			.split("&").join("&amp;")
			.split("<").join("&lt;")
			.split(">").join("&gt;")
			.split('"').join("&quot;")
			.split("'").join("&#39;");
	}
}


