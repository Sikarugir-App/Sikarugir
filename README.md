# Kegworks
A wrapper project that's the successor to Wineskin\
This project supports *macOS 10.15.4* or later.

<br>

[![ko-fi](https://img.shields.io/badge/kofi-Donate-blue?style=for-the-badge&logo=ko-fi)](https://ko-fi.com/gcenx)
[![PayPal](https://img.shields.io/badge/PayPal-Donate-blue?style=for-the-badge&logo=paypal)](https://www.paypal.com/paypalme/gcenx)
[![](https://dcbadge.limes.pink/api/server/vJTjDyzJM2?compact=true)](https://discord.gg/vJTjDyzJM2)

<br>

> [!NOTE]
> How to install using [homebrew](https://brew.sh/)
> ```
> brew upgrade
> brew uninstall --force --zap wineskin
> brew install --cask --no-quarantine gcenx/wine/kegworks
> ```
> <br>
> 
> How to install using [MacPorts](https://www.macports.org/)
> ```
> port selfupdate
> port install kegworks
> ```

<br>

> [!IMPORTANT]
> DirectX support
> - WineD3D (default) Supports DirectX 11 and below.
> - VKD3D (default) Limited DirectX 12 support.
> - D9VK (winetricks) DirectX 9 via Vulkan.
> - DXVK (winetricks) DirectX 10 & 11 via Vulkan.
> - D3DMetal (toggle) 64Bit DirectX 11 & 12 via Metal.
>
> <br>
>
> Apples D3DMetal commonly refered to as GPTK is closed source and has a restrictive license\
> it can not be used for commerial ports, that's not the case for all over renders.\
> You can review the license for [D3DMetal-v1.1](/D3DMetal/1.1/License.pdf) and [D3DMetal-v2.0](/D3DMetal/2.0/License.pdf)

<br>

> [!CAUTION]
> My Antivirus says it's a VIRUS!!!\
> You need to contact your Antivirus/Anti-malware vendor to report these as false positives.\
> This started once wine moved to using *Mingw-gcc* to compile PE binaries.
> 
> __See the following examples:__
> - [CrossOver 19 and antivirus programs](https://www.codeweavers.com/support/forums/general/?t=27;msg=222870)
> - [Windows Defender detects Occamy.c trojan in steam proton 5.0 folder](https://github.com/ValveSoftware/Proton/issues/3593)

<br>

## Components that fall under LGPL-2.1 license
- `Kegworks Winery.app` (renamed/tweaked Wineskin Winery)
- `Wineskin.app` (tweaked)

sources can be found https://github.com/Gcenx/wineskin-source/tree/Kegworks

<br>

## Components that don't fall under LGPG-2.1 license
_Kegworks Winery-2.0.3/Wineskin-3.0.6-1 or greater_
- `wineskinlauncher` (Kegworks in wineskin compatibility mode)

<br>

## Credits
- [VitorMM](https://github.com/vitor251093) for modernizing the [Wineskin Codebase](https://github.com/vitor251093/wineskin) & [ObjectiveC_Extension](https://github.com/vitor251093/ObjectiveC_Extension) & writting Kegworks-App from the ground up.
- [PaulTheTall](https://www.paulthetall.com/) for constant test data and finding bugs.
- doh123 for creating [Wineskin](https://web.archive.org/web/20141218081028/http://wineskin.urgesoftware.com/tiki-index.php).
- [Gcenx](https://github.com/Gcenx) for maintaining the Wine Engines & upstream Winehq packages.
