local Round = require(script.RoundModule)

local Door = require(script.DoorModule)

local Status = game.ReplicatedStorage:WaitForChild("Status")

while wait() do
	
	repeat
		
		local availablePlayers = {}
		
		for i, plr in pairs(game.Players:GetPlayers()) do
			if not plr:FindFirstChild("InMenu") then
				table.insert(availablePlayers,plr)
			end
		end
		
		Status.Value = "2 'Ready' players Needed ("..#availablePlayers.."/2)"
		
		wait(2)
		
	until #availablePlayers >= 2
	
	Round.Intermission(10)

	local chosenChapter = Round.SelectChapter()

	local clonedChapter = chosenChapter:Clone()
	clonedChapter.Name = "Map"
	clonedChapter.Parent = game.Workspace
	
	wait(2)
	
	if clonedChapter:FindFirstChild("Doors") then
		Door.ActivateDoors(clonedChapter.Doors)
	else
		warn("Error:please put a door to your map!")
	end
	local contestants = {}

	for i, v in pairs(game.Players:GetPlayers()) do
		if not v:FindFirstChild("InMenu") then
			table.insert(contestants,v)
		end
	end



	local chosenVamp = Round.ChooseVamp(contestants)

	for i, v in pairs (contestants) do
		if v == chosenVamp then
			table.remove(contestants,i)
	   end
	end
	
	for i, v in pairs (contestants) do
		if v ~= chosenVamp then
			game.ReplicatedStorage.ToggleCrouch:FireClient(v,true)
		end
	end
	

	
	wait(2)
	
	Round.DressVamp(chosenVamp)

	Round.TeleportVamp(chosenVamp)

	if clonedChapter:FindFirstChild("PlayerSpawns") then
		Round.TeleportPlayers(contestants, clonedChapter.PlayerSpawns:GetChildren())
	else
		warn("Fatal eror: pls put ur map!")
	end

	Round.InsertTag(contestants,"Contestant")
	Round.InsertTag({chosenVamp},"Vampire")

	Round.StartRound(600,chosenVamp,clonedChapter)

	contestants = {}

	for i, v in pairs(game.Players:GetPlayers()) do
		if not v:FindFirstChild("InMenu") then
			table.insert(contestants,v)
		end
	end

	if game.Workspace.Lobby:FindFirstChild("Spawns") then
		Round.TeleportPlayers(contestants, game.Workspace.Lobby.Spawns:GetChildren())
	else
		warn("Fatal Error: You have not added a Spawns folder into your lobby with the SpawnLocations Inside,Please do this to make the script work!")
	end

	clonedChapter:Destroy()

	Round.RemoveTags()
	
	wait(2)
end