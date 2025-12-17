#!/usr/bin/env bash
set -e

echo "⚙️ Installing dependencies ..."
sudo apt update 
sudo apt install -y git curl python3

echo "⚙️ Installing TFenv ..."
git clone --depth=1 https://github.com/tfutils/tfenv.git ~/.tfenv
ln -s ~/.tfenv/bin/* /usr/local/bin
