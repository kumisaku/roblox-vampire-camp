local keyModule = require(script.Parent:WaitForChild("Game Logic").KeyModule)

local roundModule = require(script.Parent:WaitForChild("Game Logic").RoundModule)

game.Players.PlayerAdded:Connect(function(player)
	
	
	
	local inMenu = Instance.new("BoolValue")
	inMenu.Name = "InMenu"
	inMenu.Parent = player
	
	player.CharacterAdded:Connect(function(char)
		char.Humanoid.Died:Connect(function()
			
			
			if char:FindFirstChild("HumanoidRootPart") then
				keyModule.DropTools(player,game.Workspace.Map,char.HumanoidRootPart.Position)
				print("Tools dropped")
			end
		
			
			if player:FindFirstChild("Contestant") then
				player.Contestant:Destroy()
			elseif player:FindFirstChild("Vampire") then
				player.Vampire:Destroy()
			end
		end)
	end)
	
end)

local trapDebounce = false

game.ReplicatedStorage.PlaceTrap.OnServerEvent:Connect(function(player)
	if player:FindFirstChild("Vampire") then
		if player:FindFirstChild("TrapCount") then
			if not trapDebounce then
				trapDebounce = true
				
				if player.TrapCount.Value > 0 then
					if game.Workspace:FindFirstChild("Map") then
						player.TrapCount.Value = player.TrapCount.Value - 1
						
						local trap = game.ServerStorage.Bear_Trap:Clone()
						
						trap.CFrame = player.Character.HumanoidRootPart.CFrame - Vector3.new(0,2,0)
						trap.Parent = game.Workspace:FindFirstChild("Map")
						
						
					end
				end
				
				wait(5)
				
				trapDebounce = false
			end
		end
	end
end)

game.ReplicatedStorage.MenuPlay.OnServerEvent:Connect(function(player)
	if player:FindFirstChild("InMenu") then
		
		player.InMenu:Destroy()
	end
	
	if game.ServerStorage.GameValues.GameInProgress.Value == true then
		local contestant = Instance.new("BoolValue")
		contestant.Name = "contestant"
		contestant.Parent = player
		
		game.ReplicatedStorage.ToggleCrouch:FireClient(player,true)
		
		roundModule.TeleportPlayers({player},game.Workspace:FindFirstChild("Map").PlayerSpawns:GetChildren())
		
	end
	
	
end)