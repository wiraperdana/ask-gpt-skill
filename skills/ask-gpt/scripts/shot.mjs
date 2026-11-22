// Screenshot HTML lokal lewat Obscura (CDP), di beberapa lebar dan tema.
// Pakai: node shot.mjs <file.html> <folder-out> [port]
// Butuh: `obscura serve -p <port>` sudah berjalan (default 9333).
import { pathToFileURL } from 'node:url';
import { writeFileSync, mkdirSync } from 'node:fs';
import { resolve, join } from 'node:path';
const [file, out, port = '9333'] = process.argv.slice(2);
if (!file || !out) { console.error('pakai: node shot.mjs <file.html> <folder-out> [port]'); process.exit(2); }
mkdirSync(out, { recursive: true });
const url = pathToFileURL(resolve(file)).href;
const ws = new WebSocket(`ws://localhost:${port}/devtools/browser`);
let id = 0; const wait = new Map();
const send = (method, params = {}, sessionId) => new Promise((ok, no) => {
  const i = ++id; wait.set(i, { ok, no }); ws.send(JSON.stringify({ id: i, method, params, sessionId }));
});
ws.onmessage = (e) => { const m = JSON.parse(e.data); const w = wait.get(m.id); if (!w) return; wait.delete(m.id); m.error ? w.no(new Error(m.error.message)) : w.ok(m.result); };
await new Promise((ok, no) => { ws.onopen = ok; ws.onerror = no; });
const report = [];
for (const theme of ['light', 'dark']) for (const width of [390, 768, 1280]) {
  const { targetId } = await send('Target.createTarget', { url: 'about:blank' });
  const { sessionId } = await send('Target.attachToTarget', { targetId, flatten: true });
  await send('Page.enable', {}, sessionId);
  await send('Emulation.setDeviceMetricsOverride', { width, height: 900, deviceScaleFactor: 1, mobile: width < 600 }, sessionId);
  await send('Page.navigate', { url }, sessionId);
  await new Promise(r => setTimeout(r, 1500));
  const js = `document.documentElement.setAttribute('data-theme','${theme}');` +
    `JSON.stringify({sw:document.documentElement.scrollWidth,iw:innerWidth,h:document.documentElement.scrollHeight})`;
  const r = await send('Runtime.evaluate', { expression: js, returnByValue: true }, sessionId);
  const m = JSON.parse(r.result.value);
  await new Promise(r => setTimeout(r, 300));
  const shot = await send('Page.captureScreenshot', { format: 'png', captureBeyondViewport: true, clip: { x: 0, y: 0, width, height: Math.min(m.h, 12000), scale: 1 } }, sessionId);
  const name = join(out, `${theme}-${width}.png`);
  writeFileSync(name, Buffer.from(shot.data, 'base64'));
  report.push(`${theme}-${width}: scrollWidth=${m.sw} innerWidth=${m.iw} ${m.sw > m.iw ? 'SCROLL SAMPING!' : 'ok'} -> ${name}`);
  await send('Target.closeTarget', { targetId });
}
console.log(report.join('\n')); ws.close();
