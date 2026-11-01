"""Serve the real Flutter preview locally, without exposing the repository."""
import argparse
from functools import partial
from http.server import SimpleHTTPRequestHandler, ThreadingHTTPServer
from pathlib import Path
import json
import shutil

parser = argparse.ArgumentParser()
parser.add_argument('--root', type=Path)
parser.add_argument('--port', type=int, default=8765)
args = parser.parse_args()
REPO = Path(__file__).resolve().parents[2]
ROOT = (args.root or REPO.parent / 'Cashew-tools' / 'web-preview').resolve()
if not (ROOT / 'app/main.dart.js').is_file():
    raise SystemExit('The Flutter web preview has not been built yet.')
shutil.copyfile(Path(__file__).with_name('index.html'), ROOT / 'index.html')
shutil.copyfile(Path(__file__).with_name('app-index.html'), ROOT / 'app/index.html')

CSP = "; ".join([
    "default-src 'self'",
    "script-src 'self' 'unsafe-inline' 'unsafe-eval' blob:",
    "style-src 'self' 'unsafe-inline'",
    "img-src 'self' data: blob:",
    "font-src 'self' data:",
    "connect-src 'self' data: blob:",
    "worker-src 'self' blob:",
    "frame-src 'self'",
    "object-src 'none'",
    "form-action 'self'",
])


class PreviewHandler(SimpleHTTPRequestHandler):
    extensions_map = {**SimpleHTTPRequestHandler.extensions_map,
                      '.wasm': 'application/wasm', '.js': 'application/javascript'}

    def end_headers(self):
        self.send_header('Content-Security-Policy', CSP)
        self.send_header('Cache-Control', 'no-store')
        self.send_header('X-Content-Type-Options', 'nosniff')
        super().end_headers()

    def do_POST(self):
        if self.path != '/__preview_error':
            self.send_error(404)
            return
        message = self.rfile.read(min(int(self.headers.get('Content-Length', 0)), 4000))
        print('BROWSER ERROR:', message.decode('utf-8', errors='replace'), flush=True)
        self.send_response(204)
        self.end_headers()

    def do_GET(self):
        if self.path == '/health':
            payload = json.dumps({'app': 'Cashew', 'preview': True,
                                  'main_js_bytes': (ROOT / 'app/main.dart.js').stat().st_size}).encode()
            self.send_response(200)
            self.send_header('Content-Type', 'application/json')
            self.send_header('Content-Length', str(len(payload)))
            self.end_headers()
            self.wfile.write(payload)
            return
        super().do_GET()


print(f'Cashew local preview: http://127.0.0.1:{args.port}/', flush=True)
print(f'Only generated files are served from {ROOT}', flush=True)
ThreadingHTTPServer(('127.0.0.1', args.port), partial(PreviewHandler, directory=str(ROOT))).serve_forever()
