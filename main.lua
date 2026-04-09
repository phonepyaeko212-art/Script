local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "Redz Private | Sea 1",
   LoadingTitle = "Starting Full Auto...",
   LoadingSubtitle = "Fast Attack & Gravity",
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
   Name = "Redz Fast Farm (No Click)",
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

                  if _G.AutoFarm then
                      local bv = character.HumanoidRootPart:FindFirstChild("G-Control") or Instance.new("BodyVelocity")
                      bv.Name = "G-Control"
                      bv.Velocity = Vector3.new(0, 0, 0)
                      bv.MaxForce = Vector3.new(9e9, 9e9, 9e9)
                      bv.Parent = character.HumanoidRootPart
                  end

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
                                  v.HumanoidRootPart.CanCollide = false
                                  character.HumanoidRootPart.CFrame = v.HumanoidRootPart.CFrame * CFrame.new(0, 5, 0)
                                  
                                  -- [[ Redz Original Attack System ]]
                                  local tool = character:FindFirstChildOfClass("Tool")
                                  if tool then
                                      -- Damage အလိုလိုတက်အောင် Remote ၃ မျိုးစလုံးကို ပစ်မှတ်ထားတာ
                                      game:GetService("ReplicatedStorage"):WaitForChild("Modules"):WaitForChild("Net"):WaitForChild("RE/RegisterAttack"):FireServer(0)
                                      game:GetService("ReplicatedStorage"):WaitForChild("Modules"):WaitForChild("Net"):WaitForChild("RE/RegisterAttack"):FireServer(0.1)
                                      
                                      -- Animation မပြဘဲ Damage တန်းထိစေတဲ့ Click Simulation
                                      tool:Activate()
                                      game:GetService("VirtualUser"):CaptureController()
                                      game:GetService("VirtualUser"):Button1Down(Vector2.new(1280, 672))
                                  end

                                  if character.Humanoid:FindFirstChild("Animator") then
                                      character.Humanoid.Animator:Destroy()
                                  end
                              until not _G.AutoFarm or v.Humanoid.Health <= 0 or not lp.PlayerGui.Main.Quest.Visible
                          end
                      end
                  end
              end)
          end
          if not _G.AutoFarm and game.Players.LocalPlayer.Character.HumanoidRootPart:FindFirstChild("G-Control") then
              game.Players.LocalPlayer.Character.HumanoidRootPart["G-Control"]:Destroy()
          end
      end)
   end,
})
