getBot.auto_collect = true

function Save()
getBot().auto_collect = false
    for i,v in ipairs(SaveItems) do
        if getBot():getInventory():getItemCount(v) >= 190 then
           while not getBot():isInWorld(SAVEWORLD) do
               getBot():warp(SAVEWORLD,SAVEWORLDID)
               sleep(3500)
           end
           getBot():drop(v,200)
           sleep(300)
           while getBot():getInventory():getItemCount(v) > 0 do
               getBot():moveTo(1,0)
               sleep(300)
               getBot():drop(v,200)
               sleep(300)
            end
        end
    end
end

function Trash()
    for i,v in ipairs(TrashItems) do
         if getBot():getInventory():getItemCount(v) > 150 then
            getBot():trash(v,getBot():getInventory():getItemCount(v))
            sleep(300)
        end
    end
end

function GonWebhook(SC)
    wh = Webhook.new(WebhookUrl)
    wh.username = "Clear World Script"
    wh.avatar_url = "https://cdn.discordapp.com/avatars/208654299738144768/bb27c340964dcd6a75ff1883d1341a6e.png?size=1024"
    wh.embed1.use = true
    wh.embed1.title = "Clear World Script"
    wh.embed1.description = SC
    wh:send()
end

for i,world in ipairs(WORLD) do
    getBot():warp(world)
    sleep(5000)
    for i,tiles in pairs(getBot():getWorld():getTiles()) do 
        if tiles.bg == 14 and tiles.fg ~= 6 and tiles.fg ~= 8 and tiles.fg ~= 3760 and getBot():getWorld():hasAccess(tiles.x,tiles.y) > 0 then
            getBot():findPath(tiles.x,tiles.y - 1)
            sleep(100)
            while getBot():getWorld():getTile(tiles.x,tiles.y).bg == 14 do
                getBot():hit(tiles.x,tiles.y)
                sleep(150)
            end
        end
        Save()
        if not getBot():isInWorld(world) then
            getBot():warp(world)
            sleep(3000)
getBot.auto_collect = true
        end
        Trash()
    end
    GonWebhook("**World : " .. getBot():getWorld().name .. "\nStatus : DONE**")
end
