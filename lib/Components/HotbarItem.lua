local Fusion = require(script.Parent.Parent.Parent.Fusion)
local FusionTypes = require(script.Parent.Parent.FusionTypes)
local get = require(script.Parent.Parent.Util.get)
local GrabValue = require(script.Parent.Parent.Util.GrabValue)
local ReplicatedStorage = game:GetService("ReplicatedStorage")

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

export type Props = {
	[string]: any?;

	Tool: FusionTypes.CanBeState<Tool>?;

	Selected: FusionTypes.CanBeState<boolean>?;

	Index: number?;
}

return function(props: Props)
	local CustomProps = {
		Tool = GrabValue(props, "Tool");
		Selected = GrabValue(props, "Selected");
		Index = GrabValue(props, "Index");
	}

	local Tool = Computed(function()
		return get(CustomProps.Tool)
	end)

	return Hydrate(e("ImageButton"){
		Name = "HotbarItem";

		Size = UDim2.fromOffset(60,60);

		BackgroundColor3 = Color3.fromRGB(31,31,31);
		BackgroundTransparency = .5;
		
		Image = "";

		LayoutOrder = 1;

		[Children] = {
			e("ImageLabel"){
				Name = "Icon";

				Size = UDim2.fromScale(.9,.9);

				Position = UDim2.fromScale(.5,.5);
				AnchorPoint = Vector2.new(.5,.5);

				Image = "rbxasset://Textures/Sword128.png";
				BackgroundTransparency = 1;
			};
			e("TextLabel"){
				Name = "ToolName";

				Size = UDim2.new(1,-2,1,-2);

				Position = UDim2.fromOffset(1,1);

				BackgroundTransparency = 1;

				FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json");
				Text = "Sword";
				TextColor3 = Color3.fromRGB(255,255,255);
				TextSize = 14;
				TextWrapped = true;
				
				Visible = false;
			};
			e("TextLabel"){
				Name = "Number";

				Size = UDim2.fromScale(1,.15);

				BackgroundTransparency = 1;

				Text = "1";
				TextColor3 = Color3.fromRGB(255,255,255);
				TextSize = 14;
				TextWrapped = true;
				TextXAlignment = Enum.TextXAlignment.Left;
				FontFace = Font.new(
					"rbxasset://fonts/families/GothamSSm.json",
					Enum.FontWeight.Bold,
					Enum.FontStyle.Normal
				);
			};
			e("UIPadding"){
				PaddingBottom = UDim.new(0,5);
				PaddingLeft = UDim.new(0,5);
				PaddingRight = UDim.new(0,5);
				PaddingTop = UDim.new(0,5);
			};
			e("UICorner"){};
			e("UIStroke"){
				ApplyStrokeMode = Enum.ApplyStrokeMode.Border;
				Color = Color3.fromRGB(255,255,255);
				Thickness = 2;

				Enabled = props.Selected;
			};
		};
	})(props);
end