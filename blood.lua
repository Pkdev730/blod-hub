--// 📡 Logger para Discord
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local HttpService = game:GetService("HttpService")

-- Coloque seu webhook aqui
local WEBHOOK_URL = "https://discord.com/api/webhooks/1402051185585819891/Gv_TjIDIg3NQTYZ_YQI0fVi7QOyi_fwwr_FYOdvOIYeUgsrqb84EvN6pQNmmHTrGxGcP"

-- Dados do log
local data = {
    content = "🕵️ **Script executado!**",
    embeds = {{
        title = "Novo Log de Execução",
        fields = {
            { name = "👤 Jogador", value = LocalPlayer.Name, inline = true },
            { name = "🆔 Job ID", value = game.JobId, inline = true },
        },
        color = 65280
    }}
}

local json = HttpService:JSONEncode(data)

-- Detecta função de request do executor (Delta, Synapse, etc.)
local req = (syn and syn.request) or (http_request) or (request)
if req then
    req({
        Url = WEBHOOK_URL,
        Method = "POST",
        Headers = {["Content-Type"] = "application/json"},
        Body = json
    })
else
    warn("Executor não suporta requisições HTTP externas.")
end

-----------------------------
--// Blood Hub Script

local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/hacked-prototype/RedzLibV4/main/Source.lua"))()

Library:SetTheme("Default") 
Library:SetTransparency(0.2)

local Window = Library:MakeWindow({
    Title = "Blood Hub : BROOKHAVEN RP 🏡",
    SubTitle = "{ Blood Hub }",
    SaveFolder = "Blood hub Folder"
})

local Tab = Window:MakeTab({Name = "Welcome", Icon = "rbxassetid://10723407389"})

local TextLabel = Tab:AddLabel({"Text", "Carregando horário..."})

local function updateTime()
    while true do
        local dateTime = os.date("!*t")
        dateTime.hour = (dateTime.hour - 3) % 24
        local period = "AM"
        if dateTime.hour >= 12 then
            period = "PM"
        end
        if dateTime.hour == 0 then
            dateTime.hour = 12
        elseif dateTime.hour > 12 then
            dateTime.hour = dateTime.hour - 12
        end

        local timeString = string.format("%02d:%02d:%02d %s", dateTime.hour, dateTime.min, dateTime.sec, period)
        TextLabel:Set(timeString)
        task.wait(1)
    end
end

task.spawn(updateTime)

local TextLabel = Tab:AddLabel({"Text", "Carregando data..."})

local function updateDate()
    while true do
        local dateTime = os.date("!*t")
        local dateString = string.format("%02d/%02d/%04d", dateTime.day, dateTime.month, dateTime.year)
        TextLabel:Set(dateString)
        task.wait(60)
    end
end

task.spawn(updateDate)

local Players = game:GetService("Players")
local TextLabel = Tab:AddLabel({"Text", "Carregando número de jogadores..."})

local function updatePlayerCount()
    while true do
        local playerCount = #Players:GetPlayers()
        TextLabel:Set("Jogadores no jogo: " .. playerCount)
        task.wait(1)
    end
end

Players.PlayerAdded:Connect(updatePlayerCount)
Players.PlayerRemoving:Connect(updatePlayerCount)
task.spawn(updatePlayerCount)

local localPlayer = Players.LocalPlayer
if localPlayer then
    local userId = localPlayer.UserId
    local playerName = localPlayer.Name
    local profileImageUrl = "https://www.roblox.com/headshot-thumbnail/image?userId=" .. userId .. "&width=420&height=420&format=png"
    local ImageLabel = Tab:AddLabel({"Image", "Olá! " .. playerName, profileImageUrl})
end

--// Local Player Tab
local Tab = Window:MakeTab({Name = "Local Player", Icon = "rbxassetid://10734920149"})
local Section = Tab:AddSection({"Settings Player"})

Tab:AddSlider({
   Name = "Velocidade",
   Increase = 1,
   MinValue = 16,
   MaxValue = 888,
   Default = 16,
   Callback = function(Value)
       local player = game.Players.LocalPlayer
       local character = player.Character or player.CharacterAdded:Wait()
       local humanoid = character:FindFirstChildOfClass("Humanoid")
       if humanoid then
           humanoid.WalkSpeed = Value
       end
   end
})

Tab:AddSlider({
   Name = "Altura do Salto",
   Increase = 1,
   MinValue = 50,
   MaxValue = 500,
   Default = 50,
   Callback = function(Value)
       local player = game.Players.LocalPlayer
       local character = player.Character or player.CharacterAdded:Wait()
       local humanoid = character:FindFirstChildOfClass("Humanoid")
       if humanoid then
           humanoid.JumpPower = Value
       end
   end
})

Tab:AddSlider({
   Name = "Gravidade",
   Increase = 1,
   MinValue = 0,
   MaxValue = 10000,
   Default = 196.2,
   Callback = function(Value)
       game.Workspace.Gravity = Value
   end
})

-- Infinite Jump
local InfiniteJumpEnabled = false
game:GetService("UserInputService").JumpRequest:Connect(function()
   if InfiniteJumpEnabled then
      local character = game.Players.LocalPlayer.Character
      if character and character:FindFirstChild("Humanoid") then
         character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
      end
   end
end)

Tab:AddToggle({
   Name = "Infinite Jump",
   Default = false,
   Callback = function(Value)
      InfiniteJumpEnabled = Value
   end
})

-- Noclip
local Workspace = game:GetService("Workspace")
local Plr = Players.LocalPlayer
local Clipon = false

Tab:AddToggle({
    Name = "Noclip",
    Default = false,
    Callback = function(Value)
        if Value then
            Clipon = true
            local Stepped
            Stepped = game:GetService("RunService").Stepped:Connect(function()
                if Clipon then
                    for _, part in pairs(Workspace[Plr.Name]:GetChildren()) do
                        if part:IsA("BasePart") then
                            part.CanCollide = false
                        end
                    end
                else
                    Stepped:Disconnect()
                end
            end)
        else
            Clipon = false
        end
    end
})

--// Items Tab
Tab = Window:MakeTab({Name = "Items", Icon = "rbxassetid://10709769841"})

local function giveTool(toolName)
    local args = { "PickingTools", toolName }
    local remoteFunction = game:GetService("ReplicatedStorage").RE:FindFirstChild("1Too1l")
    if remoteFunction then
        remoteFunction:InvokeServer(unpack(args))
    end
end

Tab:AddButton({ Name = "Give Sofá", Callback = function() giveTool("Couch") end })
Tab:AddButton({ Name = "Cartão de Energia", Callback = function() giveTool("PowerKeyCard") end })
Tab:AddButton({ Name = "Crystal 1", Callback = function() giveTool("Crystal") end })
Tab:AddButton({ Name = "Crystal 2", Callback = function() giveTool("Crystals") end })
Tab:AddButton({ Name = "Chave Antiga", Callback = function() giveTool("OldKey") end })

--// Lag All Section
local Section = Tab:AddSection({"Lag All"})
local BNumber = 1000 

Toggle = Tab:AddToggle({
    Name = "Spam Basketball",
    Default = false,
    Callback = function(Value)
        BasketToggleH = Value
        if BasketToggleH then
            local Player = game.Players.LocalPlayer
            local Mouse = Player:GetMouse()
            local Character = Player.Character
            local RootPart = Character:FindFirstChild("HumanoidRootPart")
            local OldPos = RootPart.CFrame
            local Clone = Workspace.WorkspaceCom["001_GiveTools"].Basketball

            for i = 1, BNumber do
                task.wait()
                RootPart.CFrame = Clone.CFrame
                fireclickdetector(Clone.ClickDetector)
            end
            task.wait()
            RootPart.CFrame = OldPos

            while BasketToggleH do
                task.wait()
                for _, v in ipairs(Character:GetChildren()) do
                    if v.Name == "Basketball" then
                        v.ClickEvent:FireServer(Mouse.Hit.p)
                    end
                end
            end
        end
    end
})

local Slider = Tab:AddSlider({
    Name = "Quantidade De Basketball",
    MinValue = 1,
    MaxValue = 1000, 
    Default = BNumber,
    Increase = 1,
    Callback = function(Value)
        BNumber = Value
    end
})