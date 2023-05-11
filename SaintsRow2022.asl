// Saints Row 2022 (DX12/Vulkan EXEs) Load Remover and Autosplitter 
// By Meta, hoxi, Vlad2D and xsoapbubble.

state("SaintsRow_Vulkan", "1.1.4.4380107")
{
    double loading      : 0x04145A20, 0x158, 0x18, 0x3C0, 0x20, 0x168; // double thats 1 on loading and 0 in game. All offsets consistent on updates. 
    string100 objective : 0x05297388, 0x120, 0x168, 0x0; // UTF-16. Seems like ending offset 0x0 is consistent across all the good ones. 2nd last offset can be 168 or 498
}

state("SaintsRow_DX12", "1.1.4.4380107") 
{
    double loading      : 0x0416F540, 0x158, 0x18, 0x3C0, 0x20, 0x168;
    string100 objective : 0x052C05F8, 0x120, 0x168, 0x0;
}

state("SaintsRow_Vulkan", "1.1.2.4376604")
{
    double loading      : 0x04145A88, 0x158, 0x18, 0x3C0, 0x20, 0x168;
    string100 objective : 0x05296778, 0x120, 0x168, 0x0;
}

state("SaintsRow_DX12", "1.1.2.4376604")
{
    double loading      : 0x0416E5A8, 0x158, 0x18, 0x3C0, 0x20, 0x168;
    string100 objective : 0x052BFE28, 0x120, 0x168, 0x0;
}

state("SaintsRow_Vulkan", "1.1.2.4374033")
{
    double loading      : 0x04145948, 0x158, 0x18, 0x3C0, 0x20, 0x168;
    string100 objective : 0x05296638, 0x120, 0x168, 0x0;
}

state("SaintsRow_DX12", "1.1.2.4374033")
{
    double loading      : 0x0416CA80, 0x158, 0x18, 0x3C0, 0x20, 0x168;
    string100 objective : 0x052BFEA8, 0x120, 0x168, 0x0;
}

state("SaintsRow_Vulkan", "1.1.6.4392638")
{
    double loading      : 0x04146C70, 0x158, 0x18, 0x3C0, 0x20, 0x168;
    string100 objective : 0x05297BA8, 0x120, 0x168, 0x0;
}

state("SaintsRow_DX12", "1.1.6.4392638")
{
    double loading      : 0x0416F800, 0x158, 0x18, 0x3C0, 0x20, 0x168;
    string100 objective : 0x052C08C8, 0x120, 0x168, 0x0;
}

state("SaintsRow_DX12", "1.2.5.4537292")
{
    double loading      : 0x043CB250, 0x158, 0x18, 0x3C0, 0x20, 0x168; 
    string100 objective : 0x0551AD38, 0x120, 0x168, 0x0;
}

state("SaintsRow_Vulkan", "1.2.5.4537292")
{
    double loading      : 0x043E35B8, 0x158, 0x18, 0x3C0, 0x20, 0x168;
    string100 objective : 0x05531558, 0x120, 0x168, 0x0; 
}

state("SaintsRow_DX12", "1.3.0.4610986")
{
    double loading      : 0x044AD3E0, 0x158, 0x18, 0x3C0, 0x20, 0x168; 
    string100 objective : 0x05600AE8, 0x120, 0x168, 0x0;
}

state("SaintsRow_Vulkan", "1.3.0.4610986")
{
    double loading      : 0x04462A08, 0x158, 0x18, 0x3C0, 0x20, 0x168;
    string100 objective : 0x055B60F8, 0x120, 0x168, 0x0; 
}



// Objective 4Byte conversion list
// MISSION OBJECTIVE          || 
// Advance to your squad      || 6553665
// Rendezvous with Bravo Team || 6619218

startup
  {
    if (timer.CurrentTimingMethod == TimingMethod.RealTime)
    // Asks user to change to game time if LiveSplit is currently set to Real Time.
    {        
        var timingMessage = MessageBox.Show (
            "This game uses Time without Loads (Game Time) as the main timing method.\n"+
            "LiveSplit is currently set to show Real Time (RTA).\n"+
            "Would you like to set the timing method to Game Time?",
            "LiveSplit | Saints Row (2022)",
            MessageBoxButtons.YesNo,MessageBoxIcon.Question
        );
        
        if (timingMessage == DialogResult.Yes)
        {
            timer.CurrentTimingMethod = TimingMethod.GameTime;
        }
    }

    settings.Add("MissionPassSplit", true, "Split on mission pass");
    settings.Add("FinaleSplit", true, "Split on last QTE");
}  

init 
{
    // Used for getting addresses from pattern scans
	Func<int, string, int> getAddressFromPattern = (patternOffset, patternStr) => {
		var page = modules.First();
		var scanner = new SignatureScanner(game, page.BaseAddress, page.ModuleMemorySize);
		IntPtr offsetPtr = scanner.Scan(new SigScanTarget(patternOffset, patternStr));
		return (int) (offsetPtr.ToInt64() - page.BaseAddress.ToInt64() + game.ReadValue<int>(offsetPtr) + 0x4);
	};

    int finaleAddr = getAddressFromPattern(2, "88 1D ?? ?? ?? ?? 84 DB");
    int missionENDAddr = getAddressFromPattern(4, "F3 0F 10 0D ?? ?? ?? ?? F3 0F 5C C8 F3 0F 59 CB F3 0F 58 C8 F3 0F 11 4C 24 ?? F3 0F 10 97 ?? ?? ?? ?? F3 0F 10 05 ?? ?? ?? ?? F3 0F 5C C2 F3 0F 59 C3 F3 0F 58 C2 F3 0F 11 44 24 ?? F3 0F 10 8F ?? ?? ?? ?? F3 0F 10 15 ?? ?? ?? ?? F3 0F 5C D1 F3 0F 59 D3 F3 0F 58 D1 F3 0F 11 54 24 ?? F3 0F 10 87 ?? ?? ?? ?? F3 0F 10 0D ?? ?? ?? ?? F3 0F 5C C8 F3 0F 59 CB F3 0F 58 C8 F3 0F 11 4C 24 ?? F3 0F 10 8F ?? ?? ?? ??");

    vars.Watchers = new MemoryWatcherList
    {
        new MemoryWatcher<int>(new DeepPointer(finaleAddr)) { Name = "finale" },
        new MemoryWatcher<int>(new DeepPointer(missionENDAddr)) { Name = "missionEND" }
    };

    byte[] exeMD5HashBytes = new byte[0];
    using (var md5 = System.Security.Cryptography.MD5.Create())
    {
	    using (var s = File.Open(modules.First().FileName, FileMode.Open, FileAccess.Read, FileShare.ReadWrite))
	    {
	    	exeMD5HashBytes = md5.ComputeHash(s); 
	    } 
    }
    var MD5Hash = exeMD5HashBytes.Select(x => x.ToString("X2")).Aggregate((a, b) => a + b);
    //print("MD5Hash: " + MD5Hash.ToString());

    switch (MD5Hash) 
    {
        case "E96DC72C03A4B4E71E04840A89D49614":
        case "A58013800D8AC71C0686014B93B800D0":
            version = "1.1.4.4380107";
            break;
        case "9A144EDF3F154B7EDAA6462E24E2FD31":
        case "41DFE6B52697205887CFA1EE26373410":
            version = "1.1.2.4376604";
            break;
        case "189BF2A300B621E39426877766A5DAFB":
        case "3FEC1EBAC3DF5D358881817099F96096":
            version = "1.1.2.4374033";
            break;
        case "67D480923A0F272E7092F123B5002EEA": //DX12
        case "010E2CC3A53F0483607E529E1A13C3EA": //Vulkan
            version = "1.1.6.4392638";
            break;
        case "6AE5D5B75A3021D74B6FB278C890F4D5":
        case "03A254E2D22ECACCF9908DB43A0A756E":
            version = "1.2.5.4537292";
            break;
        case "B60D79183CE956B08F71872E143643B2":
        case "1E3DCE3ED6B787E7EDB18589EA9A7C76":
            version = "1.3.0.4610986";
            break;
        default:
            version = "unknown";
            break;
    }
    vars.startAndReset = false;
}

update
{
    vars.startAndReset = current.objective == "Advance to your squad" && old.objective.Contains("MISSION OBJECTIVE");
    vars.Watchers.UpdateAll(game);
}

start
{
    return vars.startAndReset;
}

reset
{
    return vars.startAndReset;
}

split
{
    if (settings["MissionPassSplit"]) 
    {
        if (vars.Watchers["missionEND"].Old != 0 && vars.Watchers["missionEND"].Current == 0) 
        {
            return true;
        }
    }

    if (settings["FinaleSplit"]) 
    {
        if ((vars.Watchers["finale"].Current == 1 && vars.Watchers["missionEND"].Old == 257) && current.objective == "Kill the Nahualli") 
        {
            return true;
        }
    }
}

// To start, scan for a 1 Double (Simple Values Only) on a loading screen
// 0 in game, in a cutscene, and on main menu, while scanning for 1 on any loading screens in between.
// Should be able to find 3 double addresses that seem good enough. Do some more testing to limit it further
// Proceed with pointer scan using the offsets already found.

isLoading
{
    return current.loading == 1;
}

exit
{
    timer.IsGameTimePaused = true;
}
