#!/bin/bash

# exit when any command fails
set -e

echo "Install all essential libraries"
sudo apt update && sudo apt upgrade -y
sudo apt install git fonts-font-awesome
sudo apt install -y build-essential ninja-build libssl-dev gdb ccache cmake tar curl zip unzip python3-pip ranger

# Install the latest clang
echo "Install LLVM Clang"
wget https://apt.llvm.org/llvm.sh
chmod u+x llvm.sh
sudo ./llvm.sh

clang_versions=$(find /usr/bin -name 'clang-[0-9]*' | sed 's/.*clang-\([0-9]*\).*/\1/' | sort -nr)
latest_clang_version=$(echo "$clang_versions" | head -n 1)
echo "Selecting the latest install clang-$latest_clang_version"

if [ -z "$latest_clang_version" ]; then
    echo "No clang versions found."
    exit 1
fi
clang_path="/usr/bin/clang-$latest_clang_version"
clangpp_path="/usr/bin/clang++-$latest_clang_version"

if [ ! -f "$clang_path" ] || [ ! -f "$clangpp_path" ]; then
    echo "Clang paths not found."
    exit 1
fi

sudo update-alternatives --install /usr/bin/cc cc "$clang_path" 100
sudo update-alternatives --install /usr/bin/c++ c++ "$clangpp_path" 100

echo "Updated alternatives to use Clang $latest_clang_version"

# Install Rust
echo "Install Rust"
sudo apt install libssl-dev pkg-config
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

cargo install sccache
export RUSTC_WRAPPER="sccache cargo install {package}"

cargo install coreutils
cargo install du-dust

cargo install exa
cargo install bat
cargo install ripgrep
cargo install gitui

# Install AstroNVIM
cargo install bob-nvim
bob install latest
cargo install tree-sitter-cli
git clone --depth 1 https://github.com/AstroNvim/AstroNvim ~/.config/nvim

# Install Nushell
cargo install nu
echo $(which nu) | sudo tee -a /etc/shells
echo "Change default shell to Nushell"
chsh -s /full/path/to/nu

# Install starship
cargo install starship

# Need to prepend to $nu.env-path
# mkdir ~/.cache/starship
# starship init nu | save -f ~/.cache/starship/init.nu

# Need to prepend to $nu.config-path
# use ~/.cache/starship/init.nu

# Configuring starship
# https://starship.rs/config/
echo "Configuring starship"
starship preset nerd-font-symbols -o ~/.config/starship.toml

# Install hunter
sudo apt install libglib2.0-dev libgstreamer1.0-dev gstreamer1.0-plugins-base gstreamer1.0-plugins-good gstreamer1.0-plugins-bad gstreamer1.0-plugins-ugly
sudo apt-get install libgstreamer-plugins-base1.0-dev
sudo apt install gcc libgstreamer-plugins-base1.0-dev gstreamer1.0-plugins-good libgstreamer-plugins-bad1.0-dev libsixel-bin
cargo install hunter

