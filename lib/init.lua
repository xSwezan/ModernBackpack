local App = require(script.App)
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local StarterGui = game:GetService("StarterGui")

local IsClient: boolean = RunService:IsClient()
assert(IsClient, "ModernBackpack is client only!")

local Player: Player = Players.LocalPlayer
local PlayerGui: PlayerGui = Player:WaitForChild("PlayerGui")

local ModernBackpack = {}

function ModernBackpack:Add()
	StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Backpack, false)

	local Backpack = App{}
	Backpack.Parent = PlayerGui
end

return ModernBackpack