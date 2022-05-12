local HTTP = game:GetService("HttpService")
local Joints = {
	['Torso'] = 'RootJoint',
	['Left Arm'] = 'Left Shoulder',
	['Right Arm'] = 'Right Shoulder',
	['Left Leg'] = 'Left Hip',
	['Right Leg'] = 'Right Hip',
	['Head'] = 'Neck',
	["LowerTorso"] = "Root",
	["UpperTorso"] = "Waist",
	["RightUpperArm"] = "RightShoulder",
	["RightLowerArm"] = "RightElbow",
	["RightHand"] = "RightWaist",
	["RightUpperLeg"] = "RightHip",
	["RightLowerLeg"] = "RightKnee",
	["RightFoot"] = "RightAnkle",
	["LeftUpperArm"] = "LeftShoulder",
	["LeftLowerArm"] = "LeftElbow",
	["LeftHand"] = "LeftWaist",
	["LeftUpperLeg"] = "LeftHip",
	["LeftLowerLeg"] = "LeftKnee",
	["LeftFoot"] = "LeftAnkle",
}

local function EncodeCFrame(cfr)
	return {cfr:components()}
end

return function(Animation)
	local AnimationTable = {}
	for i,v in pairs(Animation:GetKeyframes()) do
		local Table = {}
		for i,v in pairs(v:GetDescendants()) do
			if Joints[v.Name] then
				Table[v.Name] = EncodeCFrame(v.CFrame)
			end
		end
		AnimationTable[i] = {}
		AnimationTable[i].Joints = Table
		AnimationTable[i].Time = v.Time
	end
	return HTTP:JSONEncode(AnimationTable)
end
