#!/bin/bash

echo "🚀 Setting up Solana Flash Arbitrage Development Environment"
echo "Target versions: Rust 1.87, Solana 1.18.26, Anchor 0.31"
echo "=================================================="

# Update system
echo "📦 Updating system packages..."
sudo apt-get update && sudo apt-get upgrade -y

# Install essential packages
echo "🔧 Installing essential development packages..."
sudo apt-get install -y \
    curl wget git build-essential pkg-config \
    libudev-dev libssl-dev ca-certificates \
    gnupg lsb-release software-properties-common

# Install latest Rust (1.87)
echo "🦀 Installing Rust 1.87..."
# Remove any existing Rust installation
rustup self uninstall -y 2>/dev/null || true
rm -rf ~/.cargo ~/.rustup 2>/dev/null || true

# Fresh Rust installation
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --default-toolchain stable
source ~/.cargo/env

# Verify Rust installation
echo "🔍 Verifying Rust installation..."
rustc --version
cargo --version
echo "Rust installed at: $(which cargo)"

# Install Solana CLI 1.18.26
echo "⚡ Installing Solana CLI 1.18.26..."
# Create directory structure
mkdir -p ~/.local/share/solana/install/releases/1.18.26
cd ~/.local/share/solana/install/releases/1.18.26

# Download Solana 1.18.26
wget -q --show-progress https://github.com/solana-labs/solana/releases/download/v1.18.26/solana-release-x86_64-unknown-linux-gnu.tar.bz2

# Extract binaries
tar -xjf solana-release-x86_64-unknown-linux-gnu.tar.bz2 --strip-components=1

# Clean up archive
rm solana-release-x86_64-unknown-linux-gnu.tar.bz2

# Create active release symlink
cd ~/.local/share/solana/install/
ln -sf releases/1.18.26 active_release

# Add to PATH
echo 'export PATH="$HOME/.local/share/solana/install/active_release/bin:$PATH"' >> ~/.bashrc
source ~/.bashrc

# Verify Solana installation
echo "🔍 Verifying Solana installation..."
export PATH="$HOME/.local/share/solana/install/active_release/bin:$PATH"
solana --version
cargo-build-sbf --version

# Install Anchor 0.31 from source (for compatibility)
echo "⚓ Installing Anchor CLI 0.31 from source..."
# Use source installation to avoid GLIBC issues
cargo install --git https://github.com/coral-xyz/anchor --tag v0.31.0 anchor-cli --locked

# Verify Anchor installation
echo "🔍 Verifying Anchor installation..."
anchor --version

# Install Node.js dependencies
echo "📦 Installing Node.js development tools..."
npm install -g typescript ts-node @types/node

# Install essential Solana packages globally for quick access
echo "📦 Installing Solana development packages..."
npm install -g @solana/web3.js @solana/spl-token

# Create project structure
echo "📁 Creating project structure..."
mkdir -p ~/solana-projects
cd ~/solana-projects

# Configure Solana for development
echo "⚙️  Configuring Solana for development..."
export PATH="$HOME/.local/share/solana/install/active_release/bin:$PATH"
solana config set --url https://api.devnet.solana.com
solana-keygen new --no-bip39-passphrase --silent --outfile ~/.config/solana/id.json || true

# Final verification
echo ""
echo "🎉 Installation Complete! Here's your setup:"
echo "=================================================="
echo "🦀 Rust: $(rustc --version | cut -d' ' -f2)"
echo "⚡ Solana: $(solana --version | cut -d' ' -f2)"
echo "⚓ Anchor: $(anchor --version | cut -d' ' -f3)"
echo "📦 Node.js: $(node --version)"
echo "📦 TypeScript: $(tsc --version)"
echo "📁 Project directory: ~/solana-projects"
echo "🔗 Solana config: $(solana config get)"
echo ""
echo "✅ Ready for Solana Flash Arbitrage Development!"
echo ""
echo "Quick start commands:"
echo "  cd ~/solana-projects"
echo "  anchor init flash-arbitrage --javascript"
echo "  cd flash-arbitrage"
echo "  anchor build"
echo "  anchor test"
echo ""
echo "🚀 Happy coding!"
