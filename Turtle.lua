-- Turtle Object --

Turtle = {  -- variables -- 
            inventoryName = {},
            inventoryCount = {},
            minFuelLevel = 5000, 
            fuelLevel = 0,
            torchName = 'minecraft:torch',
            torchSlot = 1,
            torchAmount = 0,
            cobName = 'minecraft:cobblestone',
            cobSlot = 0,
            cobAmount = 0,
            data = turtle.getItemDetail(),



      -- functions -- 

      -- This returns the fuel level that we store in the object variable -- 
      getFuelLevel = function()
        return Turtle.fuelLevel  
        end,
      
      -- This sets object fuel level to the correct value -- 
      setFuelLevel = function()
        Turtle.fuelLevel = turtle.getFuelLevel()
        end,

      -- This checks all inventory slots for fuel and tries to refuel -- 
      reFuel = function()
        for i = 1, 16 do 
          turtle.select(i)
          turtle.refuel()
        end 
      end,

      -- Fuel check must pass to continue -- 
      startingFuel = function()
          Turtle.setFuelLevel()
          local count = 1
          while Turtle.fuelLevel < Turtle.minFuelLevel do
            print('I Need A Fuel Level Of ', Turtle.minFuelLevel)
            print('Currently I have A Fuel Level Of ', Turtle.fuelLevel)
            print(count)
            print()
            count = count + 1
            sleep(10)
            Turtle.reFuel()
            if Turtle.fuelLevel >= Turtle.minFuelLevel then 
               break end
          end
      print('Starting With A Fuel Level Of:',Turtle.fuelLevel)
      end,

      -- if data then -- 
      -- dataPrint = function()
        -- if Turtle.data then
          -- print("Item name: ", Turtle.data.name)
          -- print("Item damage value: ", Turtle.data.damage)
          -- print("Item count: ", Turtle.data.count)
        -- end
      -- end,

      -- Inventory Management -- 
      inventoryCheck = function()
        for i = 1, 16 do 
            turtle.select(i)
            Turtle.data = turtle.getItemDetail()
            if Turtle.data == nill then 
               Turtle.inventoryName[i] = 0
               Turtle.inventoryCount[i] = 0
            else 
               Turtle.inventoryName[i] = Turtle.data.name
               Turtle.inventoryCount[i] = Turtle.data.count           
            end
            
        end
      end,

      -- Making Sure You Have Torches In Slot 1, And Cob In Slot 2 -- 
      invStart = function()
        for i = 1, 2 do
          turtle.select(i)
          while Turtle.data == nill do
             print('I Need Torches And Cob Please.')
             sleep(10)
             Turtle.data = turtle.getItemDetail()
          end
        end 
      end, 
    
      -- Starting Torch Level -- 
      torchStart = function()
        while Turtle.data.name ~= Turtle.torchName do 
          print('I Need Torches In Slot 1 Please.')
          sleep(10)
          Turtle.data = turtle.getItemDetail()
        end
        Turtle.torchAmount = Turtle.data.count
      end,

      -- StartUp Function that Checks Fuel Levels, Torch Amounts, and Cob Amounts before being able to  Proceed. -- 
      startUp = function()
        Turtle.startingFuel()
        Turtle.torchStart()
      end,
             
} 

-- StartUp Function -- 

Turtle.inventoryCheck()
print(Turtle.inventoryName[2])
print(Turtle.inventoryCount[2])


