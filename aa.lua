local RageAA = menu.Switch("Anti-Aim", "Rage Anti-Aim", false)
local JitterAngle = menu.SliderInt("Anti-Aim", "Jitter Angle", 15, -58, 58)
local LBYJitter1 = menu.Slider("Anti-Aim", "First LBY Jitter", 0, -180, 180)
local LBYJitter2 = menu.Slider("Anti-Aim", "Second LBY Jitter", 0, -180, 180)
local FakeDuck = menu.Switch("Anti-Aim", "Fake Duck", false)
local InverterToggle = menu.Switch("Anti-Aim", "Inverter Toggle", false)
local DesyncAmount = menu.Slider("Anti-Aim", "Desync Amount", 50, 0, 100)

-- State control variables
local RotationJitter = 0
local lastInversion = false

-- Advanced Jitter Function
local function AdvancedJitter()
    local randomJitter = math.random(-JitterAngle:GetValue(), JitterAngle:GetValue())
    antiaim.OverrideYawOffset(randomJitter)
    
    -- Lower Body Yaw Breaker
    if RotationJitter == 0 then
        antiaim.OverrideLBYOffset(LBYJitter1:GetValue())
        RotationJitter = 1
    else
        antiaim.OverrideLBYOffset(LBYJitter2:GetValue())
        RotationJitter = 0
    end
end

-- Desync Logic
local function ApplyDesync()
    local desyncAmount = DesyncAmount:GetValue()
    if lastInversion then
        antiaim.OverrideYawOffset(desyncAmount)
    else
        antiaim.OverrideYawOffset(-desyncAmount)
    end
    lastInversion = not lastInversion
end

-- Fake Duck Handler
local function HandleFakeDuck()
    if FakeDuck:GetBool() then
        antiaim.OverrideFakeDuck(true)
    else
        antiaim.OverrideFakeDuck(false)
    end
end

-- Main Rage Anti-Aim Function
local function DynamicRageAA()
    if not RageAA:GetBool() then return end

    -- Apply Jitter
    AdvancedJitter()

    -- Apply Desync
    ApplyDesync()

    -- Randomize Pitch
    local randomPitch = math.random(75, 89)
    antiaim.OverridePitch(randomPitch)

    -- Toggle Inverter
    if InverterToggle:GetBool() then
        antiaim.OverrideInverter(lastInversion)
    end

    -- Handle Fake Duck
    HandleFakeDuck()

    -- Randomize movement if desired (e.g., slow walk)
    antiaim.OverrideMovementSpeed(math.random(10, 100))
end

-- Register the callbacks
RageAA:RegisterCallback(DynamicRageAA)
