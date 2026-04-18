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

# Set up profile if not already present
if [ ! -f "$PLUGIN_ROOT/profile/professional_profile.md" ]; then
  echo ""
  echo "Profile not found. Copy the template and fill it in:"
  echo "  cp $PLUGIN_ROOT/profile/professional_profile_template.md $PLUGIN_ROOT/profile/professional_profile.md"
fi

echo ""
echo "Setup complete. Open Claude Code in this directory and run /resume-constructor:construct to get started."
