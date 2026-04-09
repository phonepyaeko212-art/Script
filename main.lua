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
                  local lp = game.Players.LocalPlayer
                  
                  if not lp.Character:FindFirstChildOfClass("Tool") then
                      for _, v in pairs(lp.Backpack:GetChildren()) do
                          if v:IsA("Tool") and (v.ToolTip == "Melee" or v.ToolTip == "Sword") then
                              lp.Character.Humanoid:EquipTool(v)
                              break
                          end
                      end
                  end

                  if not lp.PlayerGui.Main.Quest.Visible then
                      lp.Character.HumanoidRootPart.CFrame = q[4]
                      game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("StartQuest", q[1], q[2])
                  else
                      for _, v in pairs(game.Workspace.Enemies:GetChildren()) do
                          if v.Name == q[3] and v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 then
                              repeat
                                  task.wait()
                                  lp.Character.HumanoidRootPart.CFrame = v.HumanoidRootPart.CFrame * CFrame.new(0, 4, 0)
                                  game:GetService("ReplicatedStorage"):WaitForChild("Modules"):WaitForChild("Net"):WaitForChild("RE/RegisterAttack"):FireServer(0.1)
                              until not _G.AutoFarm or v.Humanoid.Health <= 0 or not lp.PlayerGui.Main.Quest.Visible
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
