import { test, expect } from '@playwright/test';
import path from 'path';
import fs from 'fs';
import url from 'url';

function fileUrl(p: string): string {
  const absolute = path.resolve(p);
  const href = url.pathToFileURL(absolute).href;
  return href;
}

test.describe('HeapsIframe integration via www test harness', () => {
  test('creates iframes with expected attributes and styles', async ({ page }) => {
    const wwwDir = path.resolve(__dirname, 'data', 'www');
    const indexHtml = path.join(wwwDir, 'index.html');
    const helloWorldJs = path.join(wwwDir, 'hello-world.js');
    const heapsIframeJs = path.join(wwwDir, 'heaps-iframe-test.js');

    expect(fs.existsSync(indexHtml)).toBeTruthy();
    expect(fs.existsSync(helloWorldJs)).toBeTruthy();
    expect(fs.existsSync(heapsIframeJs)).toBeTruthy();

    await page.goto(fileUrl(indexHtml));

    const iframe1 = page.locator('#root iframe');
    const iframe2 = page.locator('#root2 iframe');

    await expect(iframe1).toHaveCount(1);
    await expect(iframe2).toHaveCount(1);

    await expect(iframe1).toHaveAttribute('title', 'Test Heaps App');
    await expect(iframe1).toHaveAttribute('loading', 'eager');
    await expect(iframe1).toHaveAttribute('allow', 'autoplay; fullscreen; gamepad; xr-spatial-tracking');
    await expect(iframe1).toHaveAttribute(
      'sandbox',
      'allow-scripts allow-same-origin allow-pointer-lock allow-forms allow-popups allow-popups-to-escape-sandbox allow-modals'
    );

    const srcdoc1 = await iframe1.getAttribute('srcdoc');
    expect(srcdoc1).not.toBeNull();
    expect(srcdoc1).toContain('<canvas id="webgl"');
    expect(srcdoc1).toContain('<script src="hello-world.js"></script>');

    await expect(iframe2).toHaveCSS('width', '800px');

    const height2 = await iframe2.evaluate(el => (el as HTMLIFrameElement).style.height);
    expect(height2).toBe('50vh');

    const srcdoc2 = await iframe2.getAttribute('srcdoc');
    expect(srcdoc2).not.toBeNull();
    expect(srcdoc2).toContain('background:#123456;');
  });
});

