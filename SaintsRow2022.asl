state("SaintsRow_Vulkan")
{
    double loading      : 0x04145A20, 0x158, 0x18, 0x3C0, 0x20, 0x168; // double thats 1 on loading and 0 in game. All offsets consistent on updates. 
    string100 objective : 0x05297388, 0x120, 0x168, 0x0; // UTF-16. Seems like ending offset 0x0 is consistent across all the good ones. 2nd last offset can be 168 or 498
}

state("SaintsRow_DX12") 
{
    double loading      : 0x0416F540, 0x158, 0x18, 0x3C0, 0x20, 0x168;
    string100 objective : 0x052C05F8, 0x120, 0x168, 0x0;
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
}  

start
{
    return current.objective == "Advance to your squad" && old.objective.Contains("MISSION OBJECTIVE");
}

// To start, scan for a 1 Double (Simple Values Only) on a loading screen
// 0 in game, in a cutscene, and on main menu, while scanning for 1 on any loading screens in between.
// Should be able to find 3 double addresses that seem good enough. Do some more testing to limit it further
// Proceed with pointer scan using the offsets already found.

update
{
//DEBUG CODE 
//print(current.loading.ToString()); 
//print(current.objective.ToString());
}

isLoading
{
    return current.loading == 1;
}

exit
{
	timer.IsGameTimePaused = true;
}
