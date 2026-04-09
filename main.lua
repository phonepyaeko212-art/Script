local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "My Hub | Sea 1",
   LoadingTitle = "Starting Script...",
   LoadingSubtitle = "Fast Auto Farm",
   ConfigurationSaving = { Enabled = false }
})

local Tab = Window:CreateTab("Main Farm", 4483362458)

_G.AutoFarm = false

local function GetQuest()
    local lvl = game:GetService("Players").LocalPlayer.Data.Level.Value
    if lvl >= 0 and lvl < 10 then return {"BanditQuest1", 1, "Bandit", CFrame.new(1059, 15, 1549)}
    elseif lvl >= 10 and lvl < 15 then return {"JungleQuest", 1, "Monkey", CFrame.new(-1598, 35, 153)}
    elseif lvl >= 15 and lvl < 30 then return {"JungleQuest", 2, "Gorilla", CFrame.new(-1598, 35, 153)}
    else return {"BanditQuest1", 1, "Bandit", CFrame.new(1059, 15, 1549)}
    end
end

Tab:CreateToggle({
   Name = "Auto Farm Level",
   CurrentValue = false,
   Callback = function(Value)
      _G.AutoFarm = Value
      task.spawn(function()
          while _G.AutoFarm do
              task.wait()
              pcall(function()
                  local q = GetQuest()
                  if not game:GetService("Players").LocalPlayer.PlayerGui.Main.Quest.Visible then
                      game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = q[4]
                      game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("StartQuest", q[1], q[2])
                  else
                      for _, v in pairs(game.Workspace.Enemies:GetChildren()) do
                          if v.Name == q[3] and v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 then
                              repeat
                                  task.wait()
                                  game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = v.HumanoidRootPart.CFrame * CFrame.new(0, 7, 0)
                                  game:GetService("ReplicatedStorage"):WaitForChild("Modules"):WaitForChild("Net"):WaitForChild("RE/RegisterAttack"):FireServer(0.4)
                              until not _G.AutoFarm or v.Humanoid.Health <= 0 or not game:GetService("Players").LocalPlayer.PlayerGui.Main.Quest.Visible
                          end
                      end
                  end
              end)
          end
      end)
   end,
})

Rayfield:Notify({
   Title = "Loaded!",
   Content = "Ready to Farm!",
   Duration = 3,
})
