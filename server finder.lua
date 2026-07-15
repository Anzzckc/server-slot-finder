local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local LocalPlayer = Players.LocalPlayer
local PlaceId = game.PlaceId
local JobId = game.JobId

function findServerOneSlot()
    local servers = {}
    local url = "https://games.roblox.com/v1/games/" .. PlaceId .. "/servers/Public?sortOrder=Desc&limit=100&excludeFullGames=true"
    
    local success, result = pcall(function()
        return game:HttpGet(url)
    end)
    
    if not success then
        warn("Failed to get server list")
        return
    end
    
    local data = HttpService:JSONDecode(result)
    
    if data and data.data then
        for _, server in pairs(data.data) do
            local emptySlots = server.maxPlayers - server.playing
            if server.playing < server.maxPlayers and server.id ~= JobId and emptySlots == 1 then
                table.insert(servers, {
                    id = server.id,
                    playing = server.playing,
                    maxPlayers = server.maxPlayers,
                    emptySlots = emptySlots
                })
            end
        end
    end
    
    if #servers > 0 then
        local target = servers[math.random(1, #servers)]
        warn("Found server: " .. target.playing .. "/" .. target.maxPlayers .. " (1 slot left)")
        TeleportService:TeleportToPlaceInstance(PlaceId, target.id, LocalPlayer)
    else
        warn("No server with 1 slot found")
    end
end

findServerOneSlot()
