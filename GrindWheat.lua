--Do not change.
worldWarp = 1
runningSince = os.date("%H:%M")
listenTo = "OnDialogRequest"
findString = "It takes 50 per grind"
canGrind = false
worldSort = 1
 
function wh()
  countFlour = 0
  for _, obj in ipairs(getObjects()) do
    if obj.id == flourId then
      countSeed = countFlour + obj.count
    end
  end
  wbh = Webhook.new(webhookLink)
  wbh.content = "["..getBot().name.."] Flour dropped at "..os.date("%H:%M")
  wbh.embed1.use = true
  wbh.embed1.color = 0x264428
  wbh.embed1.title = "Flour Tracker"
  wbh.embed1:addField("<:flour:1194082718791782421> "..countFlour.."x seed dropped.",true)
  wbh.embed1.footer.text = "Running "..#getBots().." bot(s) since "..runningSince.."."
  if webhookMsgId == nil and webhookMsgId == "" then
    wbh:send()
  end
  if webhookMsgId ~= nil and webhookMsgId ~= "" then
    wbh:edit(webhookMsgId)
  end
end
wh()
 
while true do
  --Auto warp storage
  if getBot():getInventory():getItemCount(wheatId) < 50 and getBot():getInventory():getItemCount(flourId) < dropLimit then print("On condition auto warp")
::rewarpTake::
    while not getBot():isInWorld(worlds[worldWarp]) or getBot():getWorld():getTile(getBot().x, getBot().y).fg == 6 do
      getBot():warp(worlds[worldWarp], worldId) print("warping")
      sleep(12000)
    end
    count = 0
    for _, obj in ipairs(getObjects()) do
      if obj.id == wheatId and (#getBot():getPath(obj.x // 32, obj.y // 32) > 0 or getBot():isInTile(obj.x // 32, obj.y // 32)) do
        count = count + obj.count
      end
      if count == 0 then
        worldWarp = worldWarp + 1
          worldWarp = worldWarp + 1 print("["..storageFlour[worldSort].."Storage has reached max capacity, moving to the next storage.")
          if worldWarp > #worlds then
            if loopMode == true then
              worldWarp = 1 print("[LOOPMODE/ON] Reached the last input storage, looping to the first storage.")
              goto rewarpTake
            end
            if loopMode == false then
              worldWarp = 1 print("[LOOPMODE/OFF] Reached the last storage, stopping the script.")
              getBot():warp("EXIT")
              sleep(150)
              if disconnectOnMax == true then
                getBot():disconnect()
              end
              break
            end
          end
        end
 
    for _, obj in ipairs(getObjects()) do
      if obj.id == wheatId and getBot():getInventory():getItemCount(wheatId) < 50 and (#getBot():getPath(obj.x // 32, obj.y // 32) > 0 or getBot():isInTile(obj.x // 32, obj.y // 32)) then
        if not getBot():isInTile(obj.x // 32, obj.y // 32) then
          getBot():findPath((obj.x // 32), (obj.y // 32)) print("Finding path to object")
          sleep(150)
        end
        if getBot():isInTile(obj.x // 32, obj.y // 32) and getBot():getInventory():getItemCount(wheatId) < 50 then
          sleep(300)
          getBot():collectObject(obj.oid, 3) print("Collecting object.")
        end
      end
    end
  end
  --Auto warp grinder
  if getBot():getInventory():getItemCount(wheatId) >= 50 and getBot():getInventory():getItemCount(flourId) < dropLimit then
    while not getBot():isInWorld(grindW) or getBot():getWorld():getTile(getBot().x, getBot().y).fg == 6 do
      getBot():warp(grindW, grindId) print("Warping.")
      sleep(12000)
    end
    for _, tile in pairs(getTiles()) do
      if tile.fg == 4582 then
        if #getBot():getPath(tile.x, (tile.y - 1)) > 0 then
          grindX = tile.x print("Setting grinder tile.")
          grindY = tile.y
        end
      end
    end
    while not getBot():isInTile(grindX, (grindY - 1)) do
      getBot():findPath(grindX, (grindY - 1)) print("Finding path to tile.")
      sleep(3000)
    end
      sleep(1000)
    if getBot():isInTile(grindX, (grindY - 1)) and getBot():getInventory():getItemCount(wheatId) > 49 and getBot():getInventory():getItemCount(flourId) < 190 then
      grinding = false
      function grind(varlist,netid)
        print("Listening to packet, started.")
        if varlist:get(0):getString() == listenTo then print("Listening to packet...")
          if varlist:get(1):getString():find(findString) then print("Packet found, trying to match dialogue.")
            canGrind = true print("Dialogue found, setting canGrind to true.")
            unlistenEvents()
          end
        end
      end
      addEvent(Event.variantlist,grind)
      while canGrind == false and getBot():getInventory():getItemCount(wheatId) >= 50 and getBot():getInventory():getItemCount(flourId) < 190 do
        runThread(function()
          for _, tile in pairs(getTiles()) do
            if tile.fg == 4582 then
              phX = tile.x
              phY = tile.y
              if getBot():isInTile(phX, phY - 1) or #getBot():getPath(tile.x, (tile.y - 1)) > 0 then
                grindXa = tile.x print("Setting grinder tile.")
                grindYa = tile.y
              end
            end
          end
          getBot():place(grindXa, grindYa, 880)
          print("Placing "..getInfo(880).name.." at X: "..grindXa.." Y: "..grindYa)
        end)
        listenEvents(4) print("Start listening to event...")
      end
      if canGrind == true then
        canGrind = false print("canGrind is true, setting it back to false.")
        getBot():sendPacket(2, "action|dialog_return\ndialog_name|grinder\ntilex|"..tostring(grindX).."|\ntiley|"..tostring(grindY).."|\nitemID|"..tostring(wheatId).."|\ncount|"..tostring(getBot():getInventory():getItemCount(wheatId) // 50).."")
        sleep(delayAfterGrind)
      end
    end
  end
  --Auto drop flour
  ::rewarpDrop::
  if getBot():getInventory():getItemCount(flourId) >= dropLimit then   print("In auto drop.")
    while not getBot():isInWorld(storageFlour[worldSort]) do
      print(storageFlour[worldSort].." Checking warp condition.")
      getBot():warp(storageFlour[worldSort], flourId) print("Warping.")
      sleep(12000)
    end
    setTile = 0
    if setTile == 0 then
      for _, tile in pairs(getTiles()) do
        if tile.fg == 20 then
          if tile:getExtra().label == signText then
            initialDropX = tile.x
            initialDropY = tile.y
            dropX = initialDropX
            dropY = initialDropY
            addDropX = 0
          end
        end
      end
    setTile = 1
    end
    count = 0
    for _, obj in pairs(getObjects()) do
      if obj.id == flourId then
        count = count + obj.count
        if count >= maxFlourPerStorage then
          worldSort = worldSort + 1 print("["..storageFlour[worldSort].."Storage has reached max capacity, moving to the next storage.")
          if worldSort > #storageFlour then
            if loopMode == true then
              worldSort = 1 print("[LOOPMODE/ON] Reached the last storage, looping to the first storage.")
              goto rewarpDrop
            end
            if loopMode == false then
              worldSort = 1 print("[LOOPMODE/OFF] Reached the last storage, disconnecting the bot and stopping the script.")
              getBot():warp("EXIT")
              sleep(150)
              if disconnectOnMax == true then
                getBot():disconnect()
              end
              break
            end
          end
        end
      end
    end
    while not getBot():isInTile(dropX, dropY) do
      getBot():findPath(dropX, dropY) print("Finding path to next tile.")
      sleep(150)
    end
    while getBot():isInTile(dropX, dropY) and getBot():getInventory():getItemCount(flourId) > 0 do
      getBot():setDirection(false)
      sleep(150)
      getBot():drop(flourId, getBot():getInventory():getItemCount(flourId)) print("Dropping flour.")
      sleep(300)
      attempt = 0
      while getBot():getInventory():getItemCount(flourId) > 0 do
        attempt = attempt + 1
        getBot():setDirection(false)
        sleep(500)
        getBot():drop(flourId, getBot():getInventory():getItemCount(flourId)) print("Drop failed, attempting another try. Attempt: "..attempt)
        if attempt >= 5 then
          if addDropX < maxHorizontal then
            dropX = dropX + 1 print("Assume that tile is full, moving to next tile. New X: "..dropX)
            addDropX = addDropX + 1
          end
          if addDropX >= maxHorizontal then
            dropY = dropY + 1 print("New Y: "..dropY)
            dropX = initialDropX
            addDropX = 0
         end
        end
      end
    end
  end
print("doing nothing.")
sleep(300)
		end
