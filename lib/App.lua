local Fusion = require(script.Parent.Parent.Fusion)
local HotbarItem = require(script.Parent.Components.HotbarItem)
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local e = Fusion.New
local Children = Fusion.Children
local Cleanup = Fusion.Cleanup
local Hydrate = Fusion.Hydrate
local Out = Fusion.Out
local Ref = Fusion.Ref
local Value = Fusion.Value
local OnEvent = Fusion.OnEvent
local OnChange = Fusion.OnChange
local Computed = Fusion.Computed
local Observer = Fusion.Observer
local Tween = Fusion.Tween
local Spring = Fusion.Spring
local ForPairs = Fusion.ForPairs
local ForKeys = Fusion.ForKeys
local ForValues = Fusion.ForValues

local Player: Player = Players.LocalPlayer

export type Props = {
	
}

return function(props: Props)
	local Tools = Value{}
	local EquippedTool = Value()

	local ToolStorage: {[Tool]: number} = {}

	local function Update()
		local Character: Model = Player.Character or Player.CharacterAdded:Wait()
		local Backpack: Backpack = Player:WaitForChild("Backpack")

		local BackpackItems = {}
		
		for _, Tool: Tool in Backpack:GetChildren() do
			table.insert(BackpackItems, Tool)

			if not (ToolStorage[Tool]) then
				ToolStorage[Tool] = #BackpackItems
			end
		end

		local CurrentEquippedTool: Tool = Character:FindFirstChildWhichIsA("Tool")
		if (CurrentEquippedTool) then
			table.insert(BackpackItems, CurrentEquippedTool)

			if not (ToolStorage[CurrentEquippedTool]) then
				ToolStorage[CurrentEquippedTool] = #BackpackItems
			end
		end
		EquippedTool:set(CurrentEquippedTool)
		
		table.sort(BackpackItems,function(a, b)
			return ((ToolStorage[a] or 0) < (ToolStorage[b] or 0)) --(a.Name > b.Name)
		end)
		
		Tools:set(BackpackItems)
	end

	local function Equip(Index: number)
		local Tool: Tool = Tools:get()[Index]
		if not (Tool) then return end

		local Character: Model = Player.Character
		if not (Character) then return end

		local Humanoid: Humanoid = Character:WaitForChild("Humanoid")

		local CurrentEquippedTool = EquippedTool:get()

		Humanoid:UnequipTools()
		if (Tool.Parent) and (CurrentEquippedTool ~= Tool) then
			Tool.Parent = Character
		end

		Update()
	end

	Update()

	return e("ScreenGui"){
		Name = "ModernBackpack";

		ResetOnSpawn = false;
		ZIndexBehavior = Enum.ZIndexBehavior.Sibling;

		[Cleanup] = {
			UserInputService.InputEnded:Connect(function(Input: InputObject, GP: boolean)
				if (GP) then return end
		
				local Number: number = (Input.KeyCode.Value - 48)
				if (Number > 0) and (Number <= 9) then
					Equip(Number)
				end
			end);
			RunService.Heartbeat:Connect(Update);
		};
	
		[Children] = {
			e("Frame"){
				Name = "Hotbar";
				BackgroundColor3 = Color3.fromRGB(0,0,0);
				BackgroundTransparency = 1;
				BorderColor3 = Color3.fromRGB(0,0,0);
				BorderSizePixel = 0;
				Position = UDim2.new(0.5,-327,1,-70);
				Size = UDim2.fromOffset(655,70);
	
				[Children] = {
					e("UIListLayout"){
						Padding = UDim.new(0,8);
						FillDirection = Enum.FillDirection.Horizontal;
						HorizontalAlignment = Enum.HorizontalAlignment.Center;
						SortOrder = Enum.SortOrder.LayoutOrder;
					};
					ForPairs(Tools,function(Index: number, Tool: Tool)
						return Index, HotbarItem{
							Tool = Tool;
							Index = Index;
					
							Selected = Computed(function()
								return (EquippedTool:get() == Tool)
							end);
		
							LayoutOrder = Index;

							[OnEvent("Activated")] = function()
								Equip(Index)
							end;
						}
					end,Fusion.cleanup);
				};
			};
		};
	}
end