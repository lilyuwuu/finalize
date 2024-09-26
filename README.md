# finalize

Scripts relating to Finalizing Setup on https://3ds.hacks.guide/finalizing-setup.

- [`/romfs/finalize/`](romfs/finalize): Files that are packed into `finalize.romfs`
    - [`/romfs/finalize/img`](romfs/finalize/img): Images used for visual troubleshooting 
    - [`/romfs/finalize/finalize.gm9`](romfs/finalize/finalize.gm9): Script run after `finalize_helper.gm9` that:
        - Installs base homebrew applications to SYSNAND SD (see below for list)
        - Copies GodMode9 to CTRNAND (`/rw/luma/payloads`)
        - Backs up `essential.exefs` to `/gm9/backups`
        - Deletes CFW installation files that are no longer necessary
        - Backs up minsize NAND backup to `/gm9/backups`
    - `/romfs/finalize/donor.db`: Empty title database used for consoles that do not have title database (i.e. no eShop software)
- [`finalize_helper.gm9`](finalize_helper.gm9): Script that is compiled as GM9 scriptrunner (`finalize_helper.firm`); extracts `finalize.romfs`
- [`docs.md`](docs.md): Full error information / script documentation

## Bundled software
The following repositories have their compiled builds in this software package:

- [FBI](https://github.com/nh-server/FBI-NH/tree/37e7c40f1d9f2f332edd036017f01d72cdcffbae)
- [Homebrew Launcher Loader](https://github.com/PabloMK7/homebrew_launcher_dummy)
- [Anemone3DS](https://github.com/astronautlevel2/Anemone3DS)
- [Checkpoint](https://github.com/FlagBrew/Checkpoint)
- [ftpd](https://github.com/mtheall/ftpd)
- [Universal-Updater](https://github.com/Universal-Team/Universal-Updater/)
- [GodMode9](https://github.com/d0k3/GodMode9)
    - [GM9Megascript](https://github.com/annson24/GM9Megascript) *Note: Git repo deviates from GM9Megascript bundled with GM9*

## Releases

Releases are tagged for reference (based on usage in the guide). **Releases in this repository are not intended to be for general use.** If you want to use them, you have two options:

### Automatically built binaries

Binaries are automatically built by [GitHub Actions](https://github.com/hacks-guide/finalize/actions/). Place `finalize_helper.firm` in `/luma/payloads/` and `finalize.romfs` on root of SD.

### Manual file placement

- Clone this repository (latest commit, or a tagged release if you are looking for a specific version)
- Copy the contents of `finalize` (inside of the `romfs` folder) to the root of your console's SD card
- Copy `finalize.gm9` from the `finalize` folder to `/gm9/scripts/`
- Copy `GodMode9.firm` from the `finalize` folder to `/luma/payloads/`
    - Create any folders that do not exist
    - Luma's `boot.firm` needs to be on root of SD for this to work


## Building

You need the following tools installed on your computer:
- [3dstool](https://github.com/dnasdw/3dstool/releases/latest)
- [devkitARM](https://devkitpro.org/wiki/Getting_Started)
    - devkitARM is only required if you are building the FIRM, which you are going to want to do anyway
    - Install the 3DS related packages

Clone the repository via the following commands:
```
git clone https://github.com/hacks-guide/finalize --recurse-submodules
cd finalize
```

And build:
```
make
```

The romfs and FIRM will be present in the `builds` directory.

## License

TBD
