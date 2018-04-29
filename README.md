<p align="center">
  <img src="https://img.shields.io/badge/bl--browser-v0.2.1-orange.svg">
  <img src="https://img.shields.io/github/release/paperworx/bl-browser-installer.svg">
  <img src="https://img.shields.io/github/downloads/paperworx/bl-browser-installer/total.svg">
</p>

# BL-Browser-Installer

[BL-Browser](https://github.com/Pah1023/BL-Browser) is an implementation of Awesomium for Blockland that allows you to load webpages/videos in-game.

This is an installer that will attempt to install BL-Browser for a user automatically, while ensuring the user has all the dependencies required to run it and is running a compatible operating system.

# Download

See Releases page and look for **Latest Release**.

# Compiling

The following stuff is required to compile the source yourself:

- NSIS v3.03: https://sourceforge.net/projects/nsis/files/NSIS%203/3.03
- BL-Browser v0.2.1: https://github.com/Pah1023/BL-Browser/releases/tag/v0.2.1

Place the contents of BL-Browser v0.2.1 into `instfiles` then use NSIS v3.03 to compile `main.nsi`.