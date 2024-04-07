# Troubleshooting script errors
*As of v1.8.0 (2024/04/07)*

## Script-integrated error checking (finalize.gm9)

- **ERROR**: "Error #01: No Nintendo 3DS folder"
- **CAUSE**: Script is outdated (error no longer exists). Was caused by lack of Nintendo 3DS folder before implementation of NOSPACE.
- **FIX**: Update script

---

- **ERROR**: "Error #02: Missing essential.exefs"
- **CAUSE**: SYSNAND VIRTUAL:/essential.exefs does not exist, because the user denied GodMode9's prompt to make an essential.exefs backup
- **FIX**: Tell the user to re-enter GodMode9 (by holding START on boot) and to say Yes (press A) to the essential.exefs backup prompt

---

- **ERROR**: "Error #03: Missing files" (also: 03a, 03b, 03c, 03d, 03e, 03f, 03g)
- **CAUSE**: Script is outdated (error no longer exists). Was caused by lack of 0:/finalize (which should no longer happen with scriptrunner).
- **FIX**: Update script

---

- **ERROR**: "Error #04: No space"
- **CAUSE**: Insufficient space for NAND backup
- **FIX**: Make sufficient space (.nospace as contingency)

---

- **ERROR**: "Error #05: No title database"
- **CAUSE**: Script is outdated (error has been renamed; if it says 'error' and not 'information', this version of the script will create a dummy title database)
- **FIX**: Update script

---

- **ERROR**: "Information #05: No title database"
- **CAUSE**: title.db does not exist
- **FIX**: Allow prompt to import title database
- **NOTE**: If script release between 1.3.0 and 1.3.2, this will use the dummy title database, which will require reboot and DBRESET. This shouldn't happen as this version isn't known to be distributed anywhere

---

- **ERROR**: "Error #06: NAND backup fail"
- **CAUSE**: NAND backup failed to complete for some reason
- **FIX**: Unknown (check for space/partition issues, try another SD card...)
- **NOTE**: Will display as "#06*" on top screen if occuring during NOSPACE, as remaining SD space is not checked if Nintendo 3DS folder does not exist

---

- **ERROR**: "(Fatal) Error #07: No SD size"
- **CAUSE**: SD size check portion failed to run. Should not ever happen
- **FIX**: Pray

---

- **ERROR**: "Error #08: Dummy title database"
- **CAUSE**: Script is outdated (error no longer exists)
- **FIX**: Update script. Will most likely cause Error #16 (Title database mount fail) on a rerun. Alternatively, run user through DBRESET and rerun outdated script.

---

- **ERROR**: "Error #09: Unsupported GodMode9 version"
- **CAUSE**: Script is outdated (error no longer exists). Was caused by GodMode9 not being version 2.1.1.
- **FIX**: Update script

---

- **ERROR**: "(Fatal) Error #10: Application install fail"
- **CAUSE**: Script is outdated (error no longer exists because the check did not make sense), but if this happens then something seriously wrong has happened
- **FIX**: Pray

---

- **ERROR**: "Error #11: Missing donor database"
- **CAUSE**: Script is outdated (error no longer exists)
- **FIX**: Update script or provide donor.db to SD:/finalize

---

- **ERROR**: "Error #12a: Copy title.db fail" (also 12b: Copy import.db fail)
- **CAUSE**: donor.db could not be copied to A:/dbs/title.db
- **FIX**: Most likely due to MSET9 being applied and A:/ not being mounted, so try removing MSET9

---

- **ERROR**: "Fatal Error #13a: Fix CMAC fail" (also 13b)
- **CAUSE**: CMACs could not be fixed for title.db (13a) or import.db (13b)
- **FIX**: Pray

---

- **ERROR**: "Error #14a: CIA install fail"
- **CAUSE**: CIA (Anemone3DS) is corrupt, or issue with title database
- **FIX**: Check for title database issues, assuming there are none check for issues with Anemone3DS.cia / with the SD card, or use FBI for verbose error details. Alternatively, title.db issue, so if possible, have user delete `Nintendo 3DS` folder, have 3DS regenerate it, and try again. Alternatively, sketchy SD card (check for errors).

---

- **ERROR**: "Error #14b: CIA install fail" (also: 14c, 14d, 14e, 14f)
- **CAUSE**: CIA after Anemone3DS is corrupt, so at least one CIA succeeded installation but one of them failed
- **FIX**: Most likely a corrupt file, so have user replace file in SD:/finalize (14b = Checkpoint; 14c = FBI; 14d = ftpd; 14e = HBL; 14f = U-U). Alternatively, title.db issue, so if possible, have user delete `Nintendo 3DS` folder, have 3DS regenerate it, and try again. Alternatively, sketchy SD card (check for errors).

---

- **ERROR**: "Fatal Error #15: File creation fail"
- **CAUSE**: 0:/gm9/flags/BACKUPFLAG could not be created
- **FIX**: Shouldn't happen. Ensure user has a working NAND backup and if they do then they can continue normally (move NAND backup off of SD, run script as normal).

---

- **ERROR**: "Fatal Error #16: Title database mount fail"
- **CAUSE**: A:/title.db exists but could not be mounted
- **FIX**: This may happen if user has a dummy title database, in which case allowing the prompt is fine. Otherwise user's SD might be failing and data should be backed up yesterday.

---

- **ERROR**: "Information #17: Duplicate NAND backup"
- **CAUSE**: 0:/gm9/flags/BACKUPFLAG exists, and 0:/Nintendo 3DS does not exist (user ran through NOSPACE more than once even though the NAND backup succeeded)
- **FIX**: Verify user has a NAND backup, and if they do then they should continue NOSPACE (move NAND backup off of SD, move Nintendo 3DS folder back onto SD)

---

- **ERROR**: "Error #18: MSET9 detected"
- **CAUSE**: Script is outdated (MSET9 is now properly detected and removed by script)
- **FIX**: Remove MSET9 (manually if failed to remove through mset9.py/MSET9 Installer, i.e. Chromebook), or update script and have the script try to do it for you

---

- **ERROR**: "Error #18a: MSET9 detected (ID1 still affected by MSET9)
- **CAUSE**: Script detected `<ID1>_user-id1`, which appears when MSET9 is not removed (may be user error, may be Chromebook/Android issue)
- **FIX**: Follow prompts (A, A, keycombo) to remove MSET9. User will have to go through blue screen THIS IS NOT RECOMMENDED due to interaction with Nintendo 3DS folder, as well as eject and reinsert SD to force GodMode9 to mount A:/.

---

- **ERROR**: "Error #18b: MSET9 detected (MSET9 hax'd ID1 is still present)
- **CAUSE**: Script detected MSET9 itself, which will happen if MSET9 is not installed (however, this should only appear if `_user-id1` is not found, meaning something weird probably happened)
- **FIX**: Follow prompts (A, A, keycombo) to remove MSET9. User will have to go through blue screen THIS IS NOT RECOMMENDED due to interaction with Nintendo 3DS folder, as well as eject and reinsert SD to force GodMode9 to mount A:/.

---

- **ERROR**: "Fatal Error #19a: Could not remove MSET9 (Failed to rename ID1)
- **CAUSE**: Rename process failed for some reason. Sketchy SD? Weird folder name?
- **FIX**: Remove MSET9 manually (via mset9.py or MSET9 Installer, or failing that, by manually deleting MSET9 folder and renaming `_user-id1`)


---

- **ERROR**: "Fatal Error #19b: Could not remove MSET9 (Failed to remove hax'd ID1)
- **CAUSE**: Delete failed for some reason. Sketchy SD? 
- **FIX**: Remove MSET9 manually (via mset9.py or MSET9 Installer, or failing that, by manually deleting MSET9 folder)

---

> NOTE: There is no error #20; I have no idea why I skipped them, I think I thought I already used them when I didn't

---

## Scriptrunner-integrated error checking (finalize_helper.firm)

- **ERROR**: "Error #21: finalize.romfs not found"
- **CAUSE**: finalize.romfs could not be found in any of the checked locations (SD root, 3ds, Nintendo 3DS, DCIM, luma, /luma/payloads)
- **FIX**: Have user place finalize.romfs in the right directory

---

- **ERROR**: "Error #22: finalize.romfs is invalid"
- **CAUSE**: finalize.romfs does not match finalize_helper.firm's hardcoded checksum (corrupted SD? outdated file?)
- **FIX**: Replace finalize.romfs with freshly downloaded copy

---

- **ERROR**: "Information #23: finalize.romfs in wrong location
- **CAUSE**: finalize.romfs is placed in 0:/Nintendo 3DS (this folder requires additional consent from GodMode9)
- **FIX**: Tell user to allow prompts, even though it says "this is not recommended"

---

- **ERROR**: "Error #24: SD is write-protected"
- **CAUSE**: Script failed to write "0:/WRITE" dummy file (thus, SD is locked)
- **FIX**: Tell user to unlock SD; if SD is unlocked, try tape-over-the-switch method, otherwise SD card is likely failing

---

- **ERROR**: "Error #25: Could not boot GodMode9"
- **CAUSE**: GodMode9 could not be booted, probably it does not exist.
- **FIX**: This likely occurs when SD space is insufficient. Free up some space and try again. Of note is that 1.0GB+ is required anyway unless NAND backup is skipped.
- **NOTE**: This is a lazy fix to checking for free space, as doing so is difficult. This check will fail to trigger if user already has GodMode9.firm in `/luma/payloads/` (which could conceivably happen).

---

## Other script-related errors

- **ERROR**: FBI fails to install CIAs with error 0xD900458A
- **CAUSE**: Corrupted title database, likely caused by running dummy title database creation (from an outdated script) and then opening FBI via Download Play without resetting title database
- **FIX**: Regardless, tell people to replace the dummy title database (DBRESET). Then, you can either have them install everything through FBI and then run the script again (redundant), or just tell people to run the script.

## Other documentation

### BACKUPFLAG

The script checks for the existence of `SD:/gm9/flags/BACKUPFLAG` (no file extension). If it exists, it will silently skip the NAND backup. This will be visible to the user through:

- The top screen displaying "Setup complete!*" with an asterisk
- A warning symbol next to the two NAND backup files on the top screen
- Additional text on the bottom screen highlighting that a NAND backup was not made

This is created and used by the script when a NAND backup is made without a Nintendo 3DS folder ("NOSPACE"). In such instances, BACKUPFLAG is created so that when the user re-runs GodMode9 with the Nintendo 3DS folder, sufficient space for a NAND backup is not required.

### INSTALLFLAG

The script checks for the instance of `SD:/gm9/flags/INSTALLFLAG` (no file extension). If it exists, it will silently skip installing CIAs. This will be visible to the user through:

- The top screen displaying "Setup complete!**" with two asterisks
- Additional text on the bottom screen highlighting that CIA installation has been skipped

If BACKUPFLAG is triggered at the same time, "Setup complete!*" will take priority. The bottom screen will still warn the user that CIA installation has been skipped.

This flag can only be triggered by the user creating the file, and is intended to be used for debugging purposes (i.e. CIA installation works fine through FBI).

### Checksums (finalize.gm9) and changelog

For versions before migration to a Git repository, see [here](https://gist.github.com/lilyuwuu/8a7ce43263fe498b7fb0a403ea5eaff3).


