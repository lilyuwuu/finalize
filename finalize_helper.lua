ui.show_text("NEW SUPER FINALIZE SCRIPT XL & KNUCKLES")
ui.echo("Testing!\n \nThis is a test.")

print("Checking embedded backup...")
local embedded = sys.check_embedded_backup()
if embedded == false then
    ui.echo("The embedded backup is required\nto run this script.")
    sys.reboot()
elseif embedded == nil then
    ui.echo("Unusual situation alert!\n \nThe embedded backup doesn't exist,\n \nand was not auto-created...?")
    sys.reboot()
end

print("Checking Raw RTC...")
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
-- (makes it easier too in case of finalize.romfs being misplaced in "Nintendo 3DS"

ui.echo("This script needs permission\nto access your SD card software\nto install some stuff.")
local allowed = fs.allow("0:/Nintendo 3DS")
if not allowed then
    ui.echo("I was not given permission\nso I guess I'll go away...")
    sys.power_off()
end

-- these are not used for anything yet
-- but you could use these with fs.find
local paths = {
    "0:/finalize (*).romfs",
    "0:/3ds/finalize (*).romfs",
    "0:/luma/payloads/finalize (*).romfs",
    "0:/luma/finalize (*).romfs",
    "0:/DCIM/finalize (*).romfs",
    "0:/Nintendo 3DS/finalize (*).romfs",
    "0:/finalize.romfs",
    "0:/3ds/finalize.romfs",
    "0:/luma/payloads/finalize.romfs",
    "0:/luma/finalize.romfs",
    "0:/DCIM/finalize.romfs",
    "0:/Nintendo 3DS/finalize.romfs"
}

print("Getting expected hash...")
-- the use of CURRDIR here lets us run the script directly as long as the txt is next to it
local success, hash_expected = pcall(fs.read_file, CURRDIR.."/finalize-romfs-hash.txt", 0, 64)
if not success then
    ui.echo("Failed to read hash txt?\n"..hash_expected)
    sys.power_off()
end

print("Expected:", hash_expected)
-- this could search several paths for finalize.romfs, but for a test, this path is hardcoded
local success, hash_got = pcall(fs.hash_file, "0:/finalize.romfs", 0, 0)
if not success then
    ui.echo("Failed to hash finalize.romfs\n"..hash_got)
    sys.power_off()
end

hash_got = util.bytes_to_hex(hash_got)

print("Got:     ", hash_got)

if hash_got == hash_expected then
    ui.echo("Success!")
else
    ui.echo("Failure...")
end

local sel = ui.ask_selection("This is where the test ends.\n \nSelect what to do now.\nOr press B to power off.", {"Reboot", "Power off"})
if sel == 1 then
    sys.reboot()
elseif sel == 2 then
    sys.power_off()
end
sys.power_off()
