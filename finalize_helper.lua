ui.echo("Testing!\n \nThis is a test.\n \nI will now try to verify finalize.romfs.")

local success, hash_expected = pcall(fs.read_file, CURRDIR.."/finalize-romfs-hash.txt", 0, 64)
if not success then
    ui.echo("Failed to read hash txt?\n"..hash_expected)
    sys.power_off()
end

print("Expected:", hash_expected)
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
