#!/usr/bin/env bash
#
# build-resume.sh
# Renders content/resume.md to a clean standalone HTML, then converts it to
# PDF and DOCX using LibreOffice (soffice). Output lands in static/resume/
# so Hugo copies it to public/resume/ and GitHub Pages serves it.
#
# Usage: ./scripts/build-resume.sh   (run from the repo root)
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$REPO_ROOT"

OUT_DIR="static/resume"
PDF_NAME="CV_karthick-k.pdf"
DOCX_NAME="CV_karthick-k.docx"
TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT

echo "==> Building site to render resume HTML"
hugo >&2

RESUME_HTML="public/resume/index.html"
if [[ ! -f "$RESUME_HTML" ]]; then
  echo "ERROR: $RESUME_HTML not found. Run this from the repo root." >&2
  exit 1
fi

echo "==> Extracting resume body"
python3 - "$RESUME_HTML" "$TMP/resume.html" <<'PY'
import sys, bs4
src, dst = sys.argv[1], sys.argv[2]
soup = bs4.BeautifulSoup(open(src, encoding="utf-8").read(), "html.parser")
content = soup.select_one(".post-content")
if content is None:
    # fallback: grab the <article> body without the title link
    content = soup.select_one("article")
name = soup.select_one("h1")
name_text = name.get_text(strip=True) if name else "CV"

css = """
@page { size: A4; margin: 14mm 16mm; }
* { box-sizing: border-box; }
body {
  font-family: "Liberation Sans", Arial, Helvetica, sans-serif;
  color: #1a1a1a; font-size: 10.5pt; line-height: 1.45; margin: 0;
}
h1 { font-size: 22pt; margin: 0 0 2mm; letter-spacing: -0.5px; }
h2 { font-size: 13pt; margin: 6mm 0 2mm; border-bottom: 1px solid #ddd;
     padding-bottom: 1mm; color: #111; }
h3 { font-size: 11pt; margin: 3mm 0 1mm; }
p  { margin: 0 0 2mm; }
ul { margin: 0 0 2mm; padding-left: 5mm; }
li { margin: 0 0 1mm; }
a  { color: #1a1a1a; text-decoration: none; }
strong { font-weight: 700; }
"""

doc = (f'<html><head><meta charset="utf-8">'
       f'<title>{name_text}</title><style>{css}</style></head>'
       f'<body>{content.decode_contents()}</body></html>')
open(dst, "w", encoding="utf-8").write(doc)
print(f"    wrote {dst}")
PY

echo "==> Converting to PDF"
soffice --headless --convert-to pdf --outdir "$TMP" "$TMP/resume.html" >/dev/null 2>&1
echo "==> Converting to DOCX (html -> odt -> docx)"
soffice --headless --convert-to odt --outdir "$TMP" "$TMP/resume.html" >/dev/null 2>&1
soffice --headless --convert-to docx --outdir "$TMP" "$TMP/resume.odt" >/dev/null 2>&1

mkdir -p "$OUT_DIR"
cp "$TMP/resume.pdf"  "$OUT_DIR/$PDF_NAME"
cp "$TMP/resume.docx" "$OUT_DIR/$DOCX_NAME"

echo "==> Done:"
ls -la "$OUT_DIR/$PDF_NAME" "$OUT_DIR/$DOCX_NAME"
