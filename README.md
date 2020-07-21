# ROGSwitch

(c) 2020 black.dragon74 aka Nick

A macOS menu bar app to change the RGB lights on Asus ROG laptops. Supports device ids 0b05:1854, 0b05:1866 and 0b05:1869.

Requires Input Monitoring permission from Accessibility settings and my [macRogAuraCore](https://github.com/black-dragon74/macRogAuraCore) to work.

## Features
- Supports setting color to RED, GREEN, MAGENTA and GOLD.
- Supports Rainbow, color-cycle and multicolor breathing modes.
- Auto save states across reboots.

## Installing

Download the latest zip from Releases, copy `ROGSwitch.app` to `/Applications` folder and open normally.

**Important: Input monitoring accessibility permission is required for this app to work.**

## Building

### From GitHub:

Install Xcode, clone the GitHub repo and enter the top-level directory.  Then:

```sh
xcodebuild -configuration Release
```

## Credits

- [black-dragon74](https://github.com/black-dragon74) for writing this software and maintaining it.
