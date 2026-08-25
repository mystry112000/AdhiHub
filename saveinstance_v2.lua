--[[
    UniversalSynSaveInstance Enhanced v2.0
    ======================================
    Improved game dumper with profiles, error handling, and auto-naming.
    
    Usage:
      1. Paste this in Roblox executor
      2. Edit the CONFIG table below to your needs
      3. Execute — file saves to your executor's workspace
    
    Profiles: "full" | "map" | "scripts" | "minimal"
    Author: YourName
    License: MIT
]]

-- ═══════════════════════════════════════════
-- CONFIG — Edit this section
-- ═══════════════════════════════════════════

local CONFIG = {
    -- Profile preset: "full" | "map" | "scripts" | "minimal"
    Profile = "full",

    -- Custom file name (nil = auto-generate with timestamp)
    FileName = nil,

    -- Override profile's ExtraInstances (nil = use profile default)
    ExtraInstances = nil,

    -- Advanced options
    Decompile           = true,     -- decompile scripts to source
    RemovePlayerChars   = true,     -- strip player characters
    IgnoreDefaultProps  = false,    -- false = saves ALL properties (exact copy)
    SaveNotCreatable    = true,     -- save NotCreatable instances
    SharedStringOverwrite = true,   -- overwrite shared strings
    TreatUnionsAsParts  = false,    -- keep unions intact
}

-- ═══════════════════════════════════════════
-- PROFILES — What to save for each preset
-- ═══════════════════════════════════════════

local PROFILES = {
    full = {
        Desc = "Everything — map, scripts, lighting, GUIs",
        Instances = {
            "Workspace",
            "Lighting",
            "ReplicatedStorage",
            "ServerStorage",
            "ServerScriptService",
            "StarterGui",
            "StarterPlayer",
        },
    },
    map = {
        Desc = "Map geometry and lighting only",
        Instances = {
            "Workspace",
            "Lighting",
        },
    },
    scripts = {
        Desc = "All scripts and modules (no map geometry)",
        Instances = {
            "ServerScriptService",
            "ServerStorage",
            "ReplicatedStorage",
            "StarterPlayer",
            "StarterGui",
        },
    },
    minimal = {
        Desc = "Workspace only — fast dump",
        Instances = {
            "Workspace",
        },
    },
}

-- ═══════════════════════════════════════════
-- UTILITIES
-- ═══════════════════════════════════════════

local HttpService = game:GetService("HttpService")

local function log(level, msg)
    local prefix = ({
        info  = "[INFO]",
        ok    = "[OK]",
        warn  = "[WARN]",
        err   = "[ERROR]",
    })[level] or "[?]"
    print(prefix .. " " .. msg)
end

local function getTimestamp()
    local t = os.date("*t")
    return string.format("%04d%02d%02d_%02d%02d%02d",
        t.year, t.month, t.day, t.hour, t.min, t.sec)
end

local function resolveServices(serviceNames)
    local services = {}
    for _, name in ipairs(serviceNames) do
        local ok, service = pcall(game.GetService, game, name)
        if ok and service then
            table.insert(services, service)
        else
            log("warn", "Service not found: " .. name)
        end
    end
    return services
end

local function deepMerge(base, override)
    local result = {}
    for k, v in pairs(base) do result[k] = v end
    for k, v in pairs(override) do result[k] = v end
    return result
end

-- ═══════════════════════════════════════════
-- MAIN
-- ═══════════════════════════════════════════

local function main()
    log("info", "UniversalSynSaveInstance Enhanced v2.0")
    log("info", "─────────────────────────────────────")

    -- Validate profile
    local profile = PROFILES[CONFIG.Profile]
    if not profile then
        log("err", "Invalid profile: '" .. tostring(CONFIG.Profile) .. "'")
        log("err", "Available: full, map, scripts, minimal")
        return
    end
    log("info", "Profile: " .. CONFIG.Profile .. " — " .. profile.Desc)

    -- Resolve file name
    local fileName = CONFIG.FileName
    if not fileName or fileName == "" then
        fileName = CONFIG.Profile .. "_" .. getTimestamp()
    end
    log("info", "File: " .. fileName)

    -- Resolve instances
    local serviceNames = CONFIG.ExtraInstances or profile.Instances
    local instances = resolveServices(serviceNames)

    if #instances == 0 then
        log("err", "No valid services to save!")
        return
    end

    log("info", "Saving " .. #instances .. " services...")
    for _, inst in ipairs(instances) do
        log("info", "  → " .. inst:GetFullName())
    end

    -- Fetch saveinstance script
    log("info", "Fetching saveinstance.lua...")
    local rawScript
    local ok, err = pcall(function()
        rawScript = game:HttpGet(
            "https://raw.githubusercontent.com/luau/UniversalSynSaveInstance/main/saveinstance.lua",
            true -- silent
        )
    end)

    if not ok or not rawScript or rawScript == "" then
        log("err", "Failed to fetch saveinstance.lua: " .. tostring(err))
        return
    end

    log("ok", "Fetched (" .. #rawScript .. " bytes)")

    -- Load and execute
    local loadFn = loadstring(rawScript)
    if not loadFn then
        log("err", "Failed to compile saveinstance.lua")
        return
    end

    loadFn()
    log("ok", "saveinstance loaded")

    -- Build save options
    local saveOptions = {
        mode                  = "custom",
        ExtraInstances        = instances,
        TreatUnionsAsParts    = CONFIG.TreatUnionsAsParts,
        SharedStringOverwrite = CONFIG.SharedStringOverwrite,
        IgnoreDefaultProps    = CONFIG.IgnoreDefaultProps,
        SaveNotCreatable      = CONFIG.SaveNotCreatable,
        RemovePlayerCharacters = CONFIG.RemovePlayerChars,
        Decompile             = CONFIG.Decompile,
        FilePath              = fileName,
    }

    -- Execute save
    log("info", "Starting dump...")
    local saveOk, saveErr = pcall(saveinstance, saveOptions)

    if saveOk then
        log("ok", "═══════════════════════════════════")
        log("ok", "  SAVE COMPLETE: " .. fileName)
        log("ok", "═══════════════════════════════════")
    else
        log("err", "Save failed: " .. tostring(saveErr))
    end
end

-- Run with error boundary
local ok, err = pcall(main)
if not ok then
    log("err", "Fatal: " .. tostring(err))
end
