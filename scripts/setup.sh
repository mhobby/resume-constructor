#!/usr/bin/env bash
set -e

PLUGIN_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

echo "Setting up resume-constructor..."

# Check uv is installed
if ! command -v uv &>/dev/null; then
  echo "Installing uv..."
  curl -LsSf https://astral.sh/uv/install.sh | sh
  export PATH="$HOME/.cargo/bin:$PATH"
fi

# Install Python dependencies
echo "Installing Python dependencies..."
cd "$PLUGIN_ROOT"
uv sync

# Install WeasyPrint system libraries
if [[ "$OSTYPE" == "darwin"* ]]; then
  if ! command -v brew &>/dev/null; then
    echo "Homebrew not found. Install it from https://brew.sh then re-run setup."
    exit 1
  fi
  echo "Installing WeasyPrint system libraries via Homebrew..."
  brew install weasyprint 2>/dev/null || brew upgrade weasyprint 2>/dev/null || true
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
  echo "Installing WeasyPrint system libraries via apt..."
  sudo apt-get install -y libpango-1.0-0 libpangoft2-1.0-0 libpangocairo-1.0-0 \
    libcairo2 libgdk-pixbuf2.0-0 libffi-dev shared-mime-info
fi

# Profile lives in each Claude project (workspace), not in the plugin install path.
echo ""
echo "Next: in your project directory, run /resume-constructor:construct or /resume-constructor:setup — a profile stub will be created at ./profile/professional_profile.md from the bundled template when missing."
echo "After construct approves a draft, run /resume-constructor:format <path-to-markdown> to build the PDF."

echo ""
echo "Setup complete. Run /resume-constructor:construct when your profile is ready, then /resume-constructor:format on the approved draft (use /resume-constructor:setup anytime for help with this script)."
