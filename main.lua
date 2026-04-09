local RedzLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/REALVOY/RedzLibV2/main/Source.lua"))()

local Window = RedzLib:MakeWindow({
  Name = "Redz Hub",
  SubTitle = "Sea 1 Auto Farm",
  DiscordID = "123456789"
})

local MainTab = Window:MakeTab({"Auto Farm", "home"})

MainTab:AddToggle({
  Name = "Auto Farm (Sea 1)",
  Default = false,
  Callback = function(Value)
    _G.AutoFarm = Value
  end
})

RedzLib:Init()
