local RedzLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/REALVOY/RedzLibV2/main/Source.lua"))()

local Window = RedzLib:MakeWindow({
  Name = "Redz Hub (Lite v2)",
  SubTitle = "Fast & Smooth",
  DiscordID = "123456789"
})

local MainTab = Window:MakeTab({"Auto Farm", "home"})

_G.AutoFarm = false
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local LP = Players.LocalPlayer

local QuestData = {
    {Level = 0, QuestName = "BanditQuest1", QuestLevel = 1, MonsterName = "Bandit", NPCCFrame = CFrame.new(1059, 15, 1549)},
    {Level = 10, QuestName = "JungleQuest", QuestLevel = 1, MonsterName = "Monkey", NPCCFrame = CFrame.new(-1598, 35, 153)},
    {Level = 15, QuestName = "JungleQuest", QuestLevel = 2, MonsterName = "Gorilla", NPCCFrame = CFrame.new(-1598, 35, 153)},
    {Level = 30, QuestName = "BuggyQuest1", QuestLevel = 1, MonsterName = "Pirate", NPCCFrame = CFrame.new(-1141, 5, 3835)},
    {Level = 40, QuestName = "BuggyQuest1", QuestLevel = 2, MonsterName = "Brute", NPCCFrame = CFrame.new(-1141, 5, 3835)},
    {Level = 60, QuestName = "DesertQuest", QuestLevel = 1, MonsterName = "Desert Bandit", NPCCFrame = CFrame.new(894, 6, 4388)},
    {Level = 75, QuestName = "DesertQuest", QuestLevel = 2, MonsterName = "Desert Officer", NPCCFrame = CFrame.new(894, 6, 4388)},
    {Level = 90, QuestName = "SnowQuest", QuestLevel = 1, MonsterName = "Snow Bandit", NPCCFrame = CFrame.new(1389, 15, -1299)},
    {Level = 100, QuestName = "SnowQuest", QuestLevel = 2, MonsterName = "Snowman", NPCCFrame = CFrame.new(1389, 15, -1299)},
    {Level = 120, QuestName = "MarineQuest2", QuestLevel = 1, MonsterName = "Chief Petty Officer", NPCCFrame = CFrame.new(-4855, 22, 4326)},
    {Level = 150, QuestName = "SkyQuest", QuestLevel = 1, MonsterName = "Sky Bandit", NPCCFrame = CFrame.new(-4839, 717, -2619)},
    {Level = 175, QuestName = "SkyQuest", QuestLevel = 2, MonsterName = "Dark Skilled Skeleton", NPCCFrame = CFrame.new(-4839, 717, -2619)},
    {Level = 197, QuestName = "PrisonQuest", QuestLevel = 1, MonsterName = "Prisoner", NPCCFrame = CFrame.new(5308, 0, 474)},
    {Level = 210, QuestName = "PrisonQuest", QuestLevel = 2, MonsterName = "Dangerous Prisoner", NPCCFrame = CFrame.new(5308, 0, 474)},
    {Level = 250, QuestName = "ColosseumQuest", QuestLevel = 1, MonsterName = "Toga Warrior", NPCCFrame = CFrame.new(-1580, 7, -2982)},
    {Level = 300, QuestName = "MagmaQuest", QuestLevel = 1, MonsterName = "Military Soldier", NPCCFrame = CFrame.new(-5313, 12, 8515)},
    {Level = 325, QuestName = "MagmaQuest", QuestLevel = 2, MonsterName = "Military Spy", NPCCFrame = CFrame.new(-5313, 12, 8515)},
    {Level = 375, QuestName = "FishmanQuest", QuestLevel = 1, MonsterName = "Fishman Warrior", NPCCFrame = CFrame.new(61122, 18, 1568)},
    {Level = 450, QuestName = "SkyQuest2", QuestLevel = 1, MonsterName = "God's Guard", NPCCFrame = CFrame.new(-4721, 845, -1949)},
    {Level = 625, QuestName = "FountainQuest", QuestLevel = 1, MonsterName = "Galley Pirate", NPCCFrame = CFrame.new(5259, 38, 4049)}
}

local function GetMyQuest()
    local MyLevel = LP.Data.Level.Value
    for i = #QuestData, 1, -1 do
        if MyLevel >= QuestData[i].Level then
            return QuestData[i]
        end
    end
end

local function TP(TargetCFrame)
    if LP.Character and LP.Character:FindFirstChild("HumanoidRootPart") then
        local Distance = (TargetCFrame.p - LP.Character.HumanoidRootPart.Position).Magnitude
        TweenService:Create(LP.Character.HumanoidRootPart, TweenInfo.new(Distance / 250, Enum.EasingStyle.Linear), {CFrame = TargetCFrame}):Play()
    end
end

local AttackRemote = game:GetService("ReplicatedStorage"):WaitForChild("Modules"):WaitForChild("Net"):WaitForChild("RE/RegisterAttack")

RunService.Stepped:Connect(function()
    if _G.AutoFarm and LP.Character then
        for _, v in pairs(LP.Character:GetDescendants()) do
            if v:IsA("BasePart") then v.CanCollide = false end
        end
    end
end)

MainTab:AddToggle({
  Name = "Fast Auto Farm",
  Default = false,
  Callback = function(Value)
    _G.AutoFarm = Value
    task.spawn(function()
        while _G.AutoFarm do
            task.wait()
            pcall(function()
                local QuestGui = LP.PlayerGui.Main.Quest
                if not QuestGui.Visible then
                    local Data = GetMyQuest()
                    TP(Data.NPCCFrame)
                    if (LP.Character.HumanoidRootPart.Position - Data.NPCCFrame.p).Magnitude < 10 then
                        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("StartQuest", Data.QuestName, Data.QuestLevel)
                    end
                else
                    local Data = GetMyQuest()
                    if not LP.Character:FindFirstChildOfClass("Tool") then
                        for _, v in pairs(LP.Backpack:GetChildren()) do
                            if v:IsA("Tool") and (v.ToolTip == "Melee" or v.ToolTip == "Sword") then 
                                LP.Character.Humanoid:EquipTool(v)
                                break
                            end
                        end
                    end
                    for _, monster in pairs(game.Workspace.Enemies:GetChildren()) do
                        if monster.Name == Data.MonsterName and monster:FindFirstChild("Humanoid") and monster.Humanoid.Health > 0 then
                            repeat
                                TP(monster.HumanoidRootPart.CFrame * CFrame.new(0, 7, 0))
                                AttackRemote:FireServer(0.4000000059604645)
                                task.wait()
                            until not _G.AutoFarm or not monster.Parent or monster.Humanoid.Health <= 0 or not QuestGui.Visible
                        end
                    end
                end
            end)
        end
    end)
  end
})

RedzLib:Init()
