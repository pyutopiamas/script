worldWarp = 1
runningSince = os.date("%H:%M")

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
  wbh:send()
end
wh()

function checkTile()
  local countObj = 0 print("Counting obj in tile.")
  for _, obj in pairs(getObjects()) do
    if obj.x // 32 == dropX + 1 and obj.y // 32 == dropY then
      countObj = countObj + obj.count
    end
  end
  print("Count = "..countObj)
  if countObj < maxObjperTile then
    return true
  else
    return false
  end
end

while true do
  --Auto warp storage
  if getBot():getInventory():getItemCount(wheatId) < 50 and getBot():getInventory():getItemCount(flourId) < dropLimit then print("On condition auto warp")
    while not getBot():isInWorld(worlds[worldWarp]) or getBot():getWorld():getTile(getBot().x, getBot().y).fg == 6 do
      getBot():warp(worlds[worldWarp], worldId) print("warping")
      sleep(12000)
    end
    for _, obj in ipairs(getObjects()) do
      if obj.id == wheatId and getBot():getInventory():getItemCount(wheatId) < 50 then
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
      getBot():place(grindX, grindY, wheatId) print("Placing "..getInfo(wheatId).name.." at X: "..grindX.." Y: "..grindY)
      sleep(300)
      getBot():sendPacket(2, "action|dialog_return\ndialog_name|grinder\ntilex|"..tostring(grindX).."|\ntiley|"..tostring(grindY).."|\nitemID|"..tostring(wheatId).."|\ncount|"..tostring(getBot():getInventory():getItemCount(wheatId) // 50).."") print("Grinding on X:"..grindX.." Y: "..grindY)
    end
  end
  --Auto drop flour
  if getBot():getInventory():getItemCount(flourId) >= dropLimit then   print("In auto drop.")
    while not getBot():isInWorld(storageFlour) do
      getBot():warp(storageFlour, flStrgId) print("Warping.")
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
    for _, tile in pairs(getTiles()) do
      if tile.fg == 20 then
        if tile:getExtra().label == "drop" then
          initialDropX = tile.x
          initialDropY = tile.y
          dropX = initialDropX print("X: "..dropX)
          dropY = initialDropY print("Y: "..dropY)
          addDropX = 0
        end
      end
    end
    while not checkTile() do
      dropX = dropX + 1 print("Tile is full, moving to next tile. New X: ")
      addDropX = addDropX + 1
      if addDropX >= maxHorizontal then
        dropY = dropY + 1 print("New Y: "..dropY)
        dropX = initialDropX
        addDropX = 0
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
            dropX = dropX + 1 print("Assume that tile is full, moving to next tile. New X: ")
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
  wh()
  end
print("doing nothing.")
sleep(300)
end
