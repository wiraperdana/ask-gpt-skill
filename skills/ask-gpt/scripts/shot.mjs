// Screenshot HTML lokal lewat Obscura (CDP), di beberapa lebar dan tema.
// Pakai: node shot.mjs <file.html> <folder-out> [port] [--open-details] [--eval <js>] [--clip <selector>]
// --open-details membuka semua <details> sebelum dipotret; nama berkas diberi akhiran -open.
// Butuh: `obscura serve -p <port>` sudah berjalan (default 9333).
import { pathToFileURL } from 'node:url';
import { writeFileSync, mkdirSync } from 'node:fs';
import { resolve, join } from 'node:path';
const argv = process.argv.slice(2);
const openDetails = argv.includes('--open-details');
const ei = argv.indexOf('--eval'); const extra = ei >= 0 ? argv[ei + 1] : '';
const ci = argv.indexOf('--clip'); const clipSel = ci >= 0 ? argv[ci + 1] : '';
const pos = argv.filter((a, i) => !a.startsWith('--') && (ei < 0 || i !== ei + 1) && (ci < 0 || i !== ci + 1));
const [file, out, port = '9333'] = pos;
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
  const js = `document.documentElement.setAttribute('data-theme','${theme}');` + (extra ? 'try{' + extra + '}catch(e){}' : '') +
    (openDetails ? `document.querySelectorAll('details').forEach(function(d){d.open=true});` : '') +
    `var q=${JSON.stringify(clipSel)},el=q&&document.querySelector(q),b=el?el.getBoundingClientRect():null;` +
    `JSON.stringify({sw:document.documentElement.scrollWidth,iw:innerWidth,h:document.documentElement.scrollHeight,y:b?Math.max(0,b.top+scrollY-16):0,ch:b?b.height+32:0})`;
  const r = await send('Runtime.evaluate', { expression: js, returnByValue: true }, sessionId);
  const m = JSON.parse(r.result.value);
  await new Promise(r => setTimeout(r, 300));
  const shot = await send('Page.captureScreenshot', { format: 'png', captureBeyondViewport: true, clip: { x: 0, y: m.y, width, height: Math.min(m.ch || m.h, 12000), scale: 1 } }, sessionId);
  const name = join(out, `${theme}-${width}${openDetails ? '-open' : ''}${clipSel ? '-clip' : ''}.png`);
  writeFileSync(name, Buffer.from(shot.data, 'base64'));
  report.push(`${theme}-${width}: scrollWidth=${m.sw} innerWidth=${m.iw} ${m.sw > m.iw ? 'SCROLL SAMPING!' : 'ok'} -> ${name}`);
  await send('Target.closeTarget', { targetId });
}
console.log(report.join('\n')); ws.close();
