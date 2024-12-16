FINALIZE = "0:/finalize.romfs"

ui.show_text("NEW SUPER FINALIZE SCRIPT XL & KNUCKLES")
ui.echo("Testing!\n \nThis is a test.")

local trace
local debugkey = ui.check_key("Y")
if debugkey then
    ui.echo("Trace mode is enabled because Y was held.\nThis will print more debug information.")
    function trace(...)
        print(...)
    end
else
    function trace(...) end
end

local states = {
    problems = "---",
    checkexefsrtc = "---",
    permission = "---",
    verifying = "---",
    installing = "---",
    copygm9 = "---",
    cleanup = "---",
    backupexefs = "---",
    backupnand = "---",
}

local function updatestate(state, value)
    local statetext = {
        problems = "Checking for problems...",
        checkexefsrtc = "Checking for essential.exefs and Raw RTC...",
        permission = "Asking for permission...",
        verifying = "Verifying finalize.romfs...",
        installing = "Installing homebrew...",
        copygm9 = "Copying GM9 to CTRNAND...",
        cleanup = "Cleaning up SD card...",
        backupexefs = "Backing up essential.exefs...",
        backupnand = "Backing up NAND...",
    }
    local oldstate
    if state then
        oldstate = states[state]
        states[state] = value
    end

    if debugkey then
        if state then
            print("State change: "..state..": "..oldstate.." -> "..value)
        end
    else
        local textgen = {}

        for _, v in ipairs({"problems", "checkexefsrtc", "permission", "verifying", "installing", "copygm9", "cleanup", "backupexefs", "backupnand"}) do
            if states[v] == "CUR" then
                table.insert(textgen, "> "..statetext[v])
            else
                table.insert(textgen, statetext[v].." "..states[v])
            end
        end

        ui.show_text(table.concat(textgen, "\n"))
    end
end

updatestate("problems", "CUR")

trace("Getting expected finalize.romfs hash...")
-- the use of CURRDIR here lets us run the script directly as long as the txt is next to it
local success, hash_expected = pcall(fs.read_file, CURRDIR.."/finalize-romfs-hash.txt", 0, 64)
if not success then
    ui.echo("Failed to read hash txt?\nThis FIRM was built wrong!\n \n"..hash_expected)
    sys.power_off()
end

-- check if SD card can be written to
local write = "0:/WRITE"
-- don't need to care if this fails
trace("remove", write, ":", pcall(fs.remove, write))
local success, err = pcall(fs.make_dummy_file, write, 0x400)
if not success then
    updatestate("problems", "ERROR")
    trace("fs.make_dummy_file error:\n  "..err)
    ui.echo("Error #24: SD is write-protected\n \nYour SD card is set to read-only.\nEnsure that the lock switch is flipped\nin the upright position.\nOtherwise, your SD card may be failing.\n \nIf this error persists, ask for help\non Discord: https://discord.gg/MWxPgEp")
    sys.power_off()
end
trace("remove", write, ":", pcall(fs.remove, write))

updatestate("checkexefsrtc", "CUR")

trace("Checking embedded backup...")
local embedded = sys.check_embedded_backup()
if embedded == false then
    ui.echo("The embedded backup is required\nto run this script.")
    sys.reboot()
elseif embedded == nil then
    ui.echo("Unusual situation alert!\n \nThe embedded backup doesn't exist,\nand was not auto-created...?")
    sys.reboot()
end

trace("Checking Raw RTC...")
local rtc_set = false
while not rtc_set do
    rtc_set = sys.check_raw_rtc()
    if not rtc_set then
        local retry = ui.ask("If the Raw RTC is not set,\nthe date in GodMode9 will be incorrect.\n \nRetry?")
        if not retry then
            sys.reboot()
        end
    end
end

-- maybe later when we build GM9 without the stock permission prompts
-- we can remove this warning, but for now, let's pre-allow ourselves
-- (makes it easier too in case of finalize.romfs being misplaced in "Nintendo 3DS")

updatestate("checkexefsrtc", "DONE")
updatestate("permission", "CUR")

ui.echo("This script needs permission to access your SD card\nto install some software.")
local allowed = fs.allow("0:/Nintendo 3DS") and fs.allow("1:/", {ask_all=true})
if not allowed then
    updatestate("permission", "DENIED")
    ui.echo("I was not given permission\nso I guess I'll go away...")
    sys.power_off()
end

updatestate("permission", "DONE")
updatestate("verifying", "CUR")

-- these are not used for anything yet
-- but you could use these with fs.find
local paths = {
    "0:/finalize (*).romfs",
    "0:/3ds/finalize (*).romfs",
    "0:/luma/payloads/finalize (*).romfs",
    "0:/luma/finalize (*).romfs",
    "0:/DCIM/finalize (*).romfs",
    "0:/Nintendo 3DS/finalize (*).romfs",
    "0:/3ds/finalize.romfs",
    "0:/luma/payloads/finalize.romfs",
    "0:/luma/finalize.romfs",
    "0:/DCIM/finalize.romfs",
    "0:/Nintendo 3DS/finalize.romfs"
}

if not fs.exists(FINALIZE) then
    local success, path
    for i, v in ipairs(paths) do
        trace("Finding:", v)
        success, path = pcall(fs.find, v)
        if success then
            if path then
                trace("FOUND:", path)
                fs.move(path, FINALIZE)
                goto found_finalize
            end
        else
            trace("error trying to find "..v..":\n  "..path)
        end
    end
    if not path then
        ui.echo("Error #21: finalize.romfs not found\n \nfinalize.romfs could not be found on the SD card.\nCopy it to root of SD and try again.")
        sys.power_off()
    end
end

::found_finalize::

trace("Expected:", hash_expected)
-- this could search several paths for finalize.romfs, but for a test, this path is hardcoded
local success, hash_got = pcall(fs.hash_file, FINALIZE, 0, 0)
if not success then
    updatestate("verifying", "ERROR")
    trace("hash error:", hash_got)
	ui.echo("Error #22: finalize.romfs is unreadable\n \nCould not read finalize.romfs.\n(How did this happen..? Did it get corrupt?)\n \nCopy finalize.romfs to your SD card and try again.")
    sys.power_off()
end

hash_got = util.bytes_to_hex(hash_got)

trace("Got:     ", hash_got)

if hash_got ~= hash_expected then
    local hash_hi, hash_lo
    hash_g_hi = string.sub(hash_got, 1, 32)
    hash_g_lo = string.sub(hash_got, 33, 64)
    updatestate("verifying", "FAILED")
    ui.echo("Error #22: finalize.romfs is invalid\n \nThe file finalize.romfs is corrupt or unreadable.\nRe-download it, copy it to root of SD, and try again.\n \nGot:\n"..hash_hi.."\n"..hash_lo)
    sys.power_off()
end

success, err = pcall(fs.img_mount, FINALIZE)
if not success then
    trace("mount error:", err)
    ui.echo("Error #22: Failed to mount finalize.romfs\n\nCould not mount finalize.romfs.\n(How did this happen..? Did it get corrupt?)\n\nCopy finalize.romfs to your SD card and try again.")
    sys.power_off()
end

trace("Copying files to ramdrive")
fs.copy("G:/finalize", "9:/finalize", {recursive=true})
fs.img_umount()

updatestate("verifying", "DONE")
updatestate("installing", "CUR")

trace("Making 0:/luma/payloads")
fs.mkdir("0:/luma/payloads")
trace("Copying G:/finalize/GodMode9.firm")
fs.copy("9:/finalize/GodMode9.firm", "0:/luma/payloads/GodMode9.firm", {overwrite=true})

local sel = ui.ask_selection("This is where the test ends.\n \nSelect what to do now.\nOr press B to power off.", {"Reboot", "Power off"})
if sel == 1 then
    sys.reboot()
elseif sel == 2 then
    sys.power_off()
end
sys.power_off()
