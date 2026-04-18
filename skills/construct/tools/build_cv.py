"""
Render an HTML file to PDF using WeasyPrint.

Usage:
    uv run tools/build_cv.py --input .tmp/cv.html --output deliverables/cv.pdf

The HTML file should contain all content and styling in <style> tags.
WeasyPrint CSS constraints — read before writing HTML:
  - No display:flex or display:grid (text becomes non-selectable)
  - Use display:table / display:table-cell for multi-column layouts
  - No float-based clearfix (overflow:hidden) — causes text overlap
  - No external fonts (@import url(...)) — WeasyPrint cannot fetch at render time
  - System fonts only: 'Helvetica Neue', Arial, sans-serif
  - Page breaks: page-break-after:avoid on headings; page-break-inside:avoid on sections
"""

import argparse
from pathlib import Path

from weasyprint import CSS, HTML

ROOT = Path(__file__).parent.parent

PAGE_CSS = CSS(
    string="""
    @page { size: A4; margin: 28px 0 0 0; }
    @page :first { margin-top: 0; }
"""
)


def build(input_path: Path, output_path: Path) -> None:
    output_path.parent.mkdir(parents=True, exist_ok=True)
    HTML(filename=str(input_path), base_url=str(ROOT)).write_pdf(
        str(output_path),
        stylesheets=[PAGE_CSS],
    )
    print(f"Written: {output_path}")


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Render an HTML file to PDF via WeasyPrint")
    parser.add_argument("--input", required=True, help="Path to HTML input file (e.g. .tmp/cv.html)")
    parser.add_argument("--output", required=True, help="Path for output PDF (e.g. deliverables/cv.pdf)")
    args = parser.parse_args()

    input_path = Path(args.input)
    if not input_path.exists():
        parser.error(f"Input file not found: {input_path}")

    build(input_path, ROOT / args.output if not Path(args.output).is_absolute() else Path(args.output))
