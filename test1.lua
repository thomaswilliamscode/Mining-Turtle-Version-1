
local data = turtle.getItemDetail()
local dataName = data.name
local dataDamage = data.damage
local dataCount = data.count



function dataGet()
    if data then 
        print('Item Name: ', data.name )
        print('Item Damage: ', data.damage)
        print('Item Count: ', data.count)
        print(dataName)
    end
end
-- cobSlot--

function cobPlace()
    print(dataName)
    if dataName == 'minecraft:cobblestone' then
        turtle.place()
    end
end

-- test--

turtle.select(1)
if dataName == 'minecraft:torch' then
  print('We are the same')
else 
  print('Not the same')
end
