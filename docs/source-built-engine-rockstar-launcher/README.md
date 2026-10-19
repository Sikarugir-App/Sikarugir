# Rockstar Games Launcher + RDR2 on a Wine engine built only from public sources (Apple Silicon)

Status: tested on an M1 Max, macOS 26. Rockstar Games Launcher signs in and shows its UI,
Red Dead Redemption 2 (story mode) renders through D3DMetal. No CodeWeavers binaries are used.
RDR Online does not work (BattlEye).

This relates to [#258](https://github.com/Sikarugir-App/Sikarugir/issues/258): the launcher only
works with CrossOver 25/26 engines. Reason found here: CrossOver picks the graphics backend
**per program** through the proprietary `cxcompatdb`, which is not part of the public source.

## What is needed

Source: `crossover-sources-26.3.0.tar.gz` from <https://www.codeweavers.com/crossover/source>
(Wine 11 base, LGPL parts). Patches from
[highball-engine](https://github.com/gauthierpiarrette/highball-engine) (LGPL-2.1+), applied with `patch -p1`:

| Patch | Purpose |
|---|---|
| `0003-ntdll-winedllpath-prepend` | `WINEDLLPATH_PREPEND` is searched before Wine's own DLLs |
| `0006-kernelbase-per-exe-command-line-append` | `AppDefaults\<exe>\CommandLineAppend` |
| `0007-winemac-cross-process-child-swapchains` | Launcher browser (CEF) windows, Wine bug 60263 |

Own patch in this folder (apply after 0006): `9001-kernelbase-appdefaults-environment.patch` reads
`HKCU\Software\Wine\AppDefaults\<exe>\Environment` and sets those variables for that program only.
CrossOver's public `__CX_UNIX_` prefix promotes them into the Unix environment.

## Per-program backend (the actual fix)

Wine's own Direct3D must stay the default (the launcher needs a D3D10.1 device, D3DMetal has none).
Only the game gets D3DMetal. Do not put D3DMetal files into the engine's `lib/wine`.

```
AppDefaults\RDR2.exe\Environment
  __CX_UNIX_WINEDLLPATH_PREPEND               = <wrapper>/SharedSupport/renderer/d3dmetal/wine
  __CX_UNIX_CX_APPLEGPTK_LIBD3DSHARED_PATH    = <wrapper>/SharedSupport/renderer/d3dmetal/external/libd3dshared.dylib
  __CX_UNIX_CX_ACTIVE_GRAPHICS_BACKEND        = d3dmetal
AppDefaults\Launcher.exe\Environment          (same two variables, empty)
AppDefaults\SocialClubHelper.exe\Environment  (same two variables, empty)
AppDefaults\SocialClubHelper.exe  CommandLineAppend = --disable-gpu --disable-gpu-compositing
```

The empty values matter: the wrapper starts `RDR2.exe` first, which starts the launcher, and
children inherit the environment.

## Building without Xcode (pitfalls)

See `scripts/`. Short version:

- `/usr/bin` tools (`ar`, `make`, `m4`, `strip`...) are xcrun shims and fail without Xcode.
  Use Homebrew LLVM tools in a `toolbin`, `gmake`, and `M4=/opt/brew/opt/m4/bin/m4` (flex uses it).
- Put `-fuse-ld=...` in `LDFLAGS`, not `CC` (Wine turns unused-argument warnings into errors).
- Wine's loaders (`loader/wine`, `loader/wine-preloader`) need `-segaddr`/`-segalign`. lld ignores
  them, the engine then crashes with exit 139. Link only these two with Apple's `ld64`
  (<https://github.com/tpoechtrager/cctools-port> plus <https://github.com/tpoechtrager/apple-libtapi>);
  everything else with lld. See `scripts/relink-loaders.sh`.
- `configure` fails the `MTLDevice registryID` check with this toolchain. Without
  `#define HAVE_MTLDEVICE_REGISTRYID 1` in `include/config.h`, winemac finds no display adapter.
- FreeType, GMP, Nettle, GnuTLS built for x86_64 (GnuTLS is needed for HTTPS; set `ENABLE_NETTLE`
  in `config.status` if the generated `configure` leaves it off). `dyld` strips `DYLD_*` for
  `/bin/sh`, so give helper tools an absolute install name instead.
- Add `#define SONAME_LIBVULKAN "libMoltenVK.dylib"` to `config.h` when building without MoltenVK headers.
- Wrapper options `Skip Mono`/`Skip Gecko` = 1 avoid the Mono prompt after the prefix is upgraded.

## Known issues

- RDR2 shows "Minimum Recommended Hardware Check Failure" (AMD driver); OK continues.
- The launcher's window belongs to `SocialClubHelper.exe` in the macOS window list, not `Launcher.exe`.
- RDR2 detects debuggers; attaching `winedbg` ends the game.
- Vulkan mode (MoltenVK) did not get past startup here (transform feedback missing).
