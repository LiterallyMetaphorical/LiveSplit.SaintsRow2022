state("SaintsRow_DX12")
{
    double loading      : 0x0416E1E8, 0x158, 0x18, 0x3C0, 0x20, 0x168; // double thats 1 on loading and 0 in game
    string100 objective : 0x052BF408, 0x120, 0x168, 0x0; // seems like ending offset 0x0 is consistent across all the good ones. 2nd last offset can be 168 or 498
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
            "LiveSplit | Saints Row (2022) Direct X 12",
            MessageBoxButtons.YesNo,MessageBoxIcon.Question
        );
        
        if (timingMessage == DialogResult.Yes)
        {
            timer.CurrentTimingMethod = TimingMethod.GameTime;
        }
    }
}

init
{
	vars.loading = false;
}

update
{
    //tells isLoading to look for the value of 1 to pause the timer
    vars.loading = current.loading == 1; 

   print(current.objective);     
}       

start
{
    return current.objective == "Advance to your squad" && old.objective.Contains("MISSION OBJECTIVE");
}

isLoading
{
   return vars.loading;
}

exit
{
	timer.IsGameTimePaused = true;
}