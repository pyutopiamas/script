--Do not change.
worldWarp = 1

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
      getBot():warp(storageFlour, flourId) print("Warping.")
      sleep(12000)
    end
    for _, tile in pairs(getTiles()) do
      if tile.fg == 20 then
        if tile:getExtra().label == "drop" then
          initialDropX = tile.x
          initialDropY = tile.y
          dropX = initialDropX
          dropY = initialDropY
          addDropX = 0
        end
      end
    end
    dropCount = 0
    for _, obj in pairs(getObjects()) do
		print(dropX)
      if (obj.x // 32) == (dropX + 1) and (obj.y // 32) == (dropY) and obj.id == flourId then
        dropCount = dropCount + obj.count print("Counting dropped object.")
      end
    end
    if dropCount > 3800 then
      dropX = dropX + 1 print("Tile is full, moving to next tile.")
      addDropX = addDropX + 1
      if addDropX > maxHorizontal then
        dropY = dropY + 1
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
    end
  end
print("doing nothing.")
sleep(300)
end
