## HeapsIframe

**HeapsIframe** is a tiny utility for embedding a compiled [Heaps.io](https://heaps.io) JavaScript application inside an `<iframe>`.

### Install


```bash
haxelib install heaps-iframe
```


### Usage

In a Haxe JS project:

```haxe
import js.Browser;
import heaps.iframe.HeapsIframe;

class Main {
    static function main() {
        Browser.window.onload = function () {
            HeapsIframe.createHeapsIframe({
                // A CSS selector or an Element; defaults to document.body
                container: "#root",
                // Path to your compiled Heaps JS bundle (relative to the page)
                jsUrl: "hello-world.js",
                // Optional sizing and styling
                width: 800,
                height: "600px",
                background: "#000"
            });
        };
    }
}
```

This will create an `<iframe>` inside `#root` (or `document.body` if no container is given) and load your Heaps app into it with a WebGL canvas filling the frame.


