local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "My Hub | Gravity Style",
   LoadingTitle = "Starting Fast Attack...",
   LoadingSubtitle = "No Animation Mode",
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
                  local lp = game.Players.LocalPlayer
                  local character = lp.Character
                  local q = GetQuest()

                  if not character:FindFirstChildOfClass("Tool") then
                      for _, v in pairs(lp.Backpack:GetChildren()) do
                          if v:IsA("Tool") and (v.ToolTip == "Melee" or v.ToolTip == "Sword") then
                              lp.Character.Humanoid:EquipTool(v)
                          end
                      end
                  end

                  if not lp.PlayerGui.Main.Quest.Visible then
                      character.HumanoidRootPart.CFrame = q[4]
                      game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("StartQuest", q[1], q[2])
                  else
                      for _, v in pairs(game.Workspace.Enemies:GetChildren()) do
                          if v.Name == q[3] and v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 then
                              repeat
                                  task.wait()
                                  
                                  -- [[ Mob Bring & Position Fix ]]
                                  v.HumanoidRootPart.CanCollide = false
                                  v.HumanoidRootPart.Size = Vector3.new(60, 60, 60)
                                  v.HumanoidRootPart.CFrame = character.HumanoidRootPart.CFrame * CFrame.new(0, -5, 0)
                                  character.HumanoidRootPart.CFrame = v.HumanoidRootPart.CFrame * CFrame.new(0, 5, 0)

                                  -- [[ Gravity Style Fast Attack ]]
                                  local tool = character:FindFirstChildOfClass("Tool")
                                  if tool then
                                      game:GetService("ReplicatedStorage"):WaitForChild("Modules"):WaitForChild("Net"):WaitForChild("RE/RegisterAttack"):FireServer(0)
                                      tool:Activate()
                                  end

                                  -- [[ No Animation ]]
                                  if character.Humanoid:FindFirstChild("Animator") then
                                      character.Humanoid.Animator:Destroy()
                                  end
                              until not _G.AutoFarm or v.Humanoid.Health <= 0 or not lp.PlayerGui.Main.Quest.Visible
                          end
                      end
                  end
              end)
          end
      end)
   end,
})
