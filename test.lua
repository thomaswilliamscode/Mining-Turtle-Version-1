-- move count--

local steps = 0
local miningLocation = 0
local level = 0
local miningLevel = 0
local direction = 'forward'
local oldDirection = 'forward'
local currentSlot = turtle.getSelectedSlot()
local oldSlot = 1
local cobSlot = 0
local leftOrRight = 'right'
local oldLeftOrRight = 'right'
local dataName  = 'test'
local dataCount = 0
local dataDamage = 0

local torchUp = 4
local torchRight = 5
local torchLeft = 5
local firstTorch = 'yes'
local torchLoop = 'no'

local torchSlot = 1
local shaftStatusMain = 'unfinished'
local shaftStatusRight = 'unfinished'
local shaftStatusLeft = 'unfinished'
local torchFail = 'no'

local stepsRight = 0
local oldStepsRight = 0
local stepsLeft = 0
local oldStepsLeft = 0

local mainShaftLength = 100
local branchShaftLength = mainShaftLength

local fuelStart = 0
local fuelEnd = 0
local fuelNeeded = 0


-- shaft variables--
local onShaft = 'no'
local leftOrRightShaft = ''
local leftOrRightBranch = ''

function setData()
    local data = turtle.getItemDetail()
    dataName = data.name
    dataCount = data.count
    dataDamage = data.damage
end
-- direction --
function left() 
    direction = 'left'
end

function right()
    direction = 'right'
end

function front()
    direction = 'forward'
end

function backward()
    direction = 'backward'
end

function homeDirection()
    if direction =='forward' then
        turnAround()
    elseif direction =='left' then
        turnLeft()
        backward()
    elseif direction =='right' then
        turnRight()
    else direction = 'backward'
    end
end

function miningDirection()
    if oldDirection == 'left' then 
        turnLeft()
    elseif oldDirection == 'right' then 
        turnRight()
    else oldDirection = 'forward'
    end
end
-- level count -- 
function levelUp()
    turtle.up()
    level = level + 1
end

function levelDown()
    turtle.down()
    level = level - 1
end

-- go home and go back mine -- 

function goHome()
  print('Main Tunnel: ',steps)
  print('Steps Right: ',stepsRight)

  print('Steps Left: ',stepsLeft)
  if onShaft == 'yes' and leftOrRightShaft == 'right' then
    oldStepsRight = stepsRight
    for i = 1, stepsRight do
      turtle.forward()
    end
    turnLeft()
  end
  
  if onShaft == 'yes' and leftOrRightShaft == 'left' then
    oldStepsLeft = stepsLeft
    for i = 1, stepsLeft do
      turtle.forward()
    end 
    turnRight()
  end
    miningLocation = steps
    for i = 1, steps do 
        turtle.forward()
    end
    steps = 0
end

function backToMine()
    print('I am Going Back To mine')
    turnAround()
    front()
    for i = 1, miningLocation do 
        turtle.forward()
        steps = steps + 1
    end
    
    if leftOrRight == 'left' and onShaft == 'no' then
        turnLeft()
        turtle.forward()
    end
    
  if onShaft == 'yes' and leftOrRightShaft == 'right' and shaftStatusRight == 'unfinished' then
    turnRight()
    front()
    for i = 1, oldStepsRight do
      turtle.forward()
    end 
    if rightShaftLR == 'left' then
      turnLeft()
      turtle.forward()
    end
    
  elseif onShaft == 'yes' and leftOrRightShaft == 'left' and shaftStatusLeft == 'unfinished' then
    turnLeft()
    front()
    for i = 1, oldStepsLeft do
      turtle.forward()
    end 
    if leftShaftLR == 'left' then
      turnLeft()
      turtle.forward()
    end
  end  
    
    while level < miningLevel do 
        levelUp()
    end
    if leftOrRight == 'right' then
        miningDirection()
    end
end


-- head home --

function branchStatus()
  if leftOrRightShaft == 'left' then
    leftOrRightBranch = 'left'
  elseif
    leftOrRightShaft == 'right' then 
    leftOrRightBranch = 'right'
  else 
    leftOrRightShaft = ''
    leftOrRightBranch = ''
  end 
end 
  
  
function home()
    while level >= 1 do 
        levelDown()
    end
    homeDirection()
    goHome()
    invDump()
    turtle.select(1)
    
    if shaftStatusMain == 'unfinished' then
      backToMine()
      end
    
end

function torchHome()
  homeDirection()
  goHome()
  invDump()
  turtle.select(1)
  while turtle.getItemSpace() == 64 do 
    print('waiting for torches in slot 1')
    sleep(10)
  end 
  torchSlot = 1
  backToMine()
end 
  
function shaftHome()
  if leftOrRightShaft == 'left' or leftOrRightShaft == 'right' then
    if leftOrRightShaft == 'left' then
      oldStepsLeft = stepsLeft
      turnAround()
      while stepsLeft > 0 do
        turtle.forward()
        end
      stepsLeft = 0
      turnRight()
      front()
      return
      end
      
    if leftOrRightShaft ==  'right' then
      oldStepsRight = stepsRight 
      turnAround()
      while stepsRight > 0 do
        turtle.forward()
        end
      stepsRight = 0
      turnLeft()
      front()
      return 
      end
        
  end 
end
  

function cobHome()
    oldDirection = direction
    miningLevel = level
    oldLeftorRight = leftOrRight
    while level >= 1 do 
        levelDown()
    end
    
    if leftOrRight == 'left' then
        turtle.back()
    end
    
    homeDirection()
    shaftHome()  
    goHome()
    invDump()        
    cobGrab()
    backToMine()
end

-- inventory -- 
function invDump()
    for i = 1, 16 do
        turtle.select(i)
        if turtle.getItemCount() >= 1 and i <= 2 then
          setData()
          if i == 1 and dataName == 'minecraft:torch' then
            i = i + 1
            turtle.select(i)
            end
          setData()
          if i == 2 and dataName == 'minecraft:cobblestone' then
            i = i + 1
            turtle.select(i)
          end 
        end
          turtle.refuel() 
          turtle.drop()
    end
    cobGrab()
end

function invCheck()
    if turtle.getItemCount(16) > 0 then
        
        miningLevel = level
        oldDirection = direction
        home()
        
    end
end


-- Torch place and check -- 

function torchSlotGet()
local i = 1
oldSlot = currentSlot
  while torchSlot == 0 do
    turtle.select(i)
    while turtle.getItemSpace() == 64 do
      i = i + 1
      if i == 16 and torchSlot == 0 then
        print('Going Home For Torches')
        torchFail = 'yes'
        torchHome()
        oldSlot = currentSlot
        torchPlace()
        break 
        end
      end
    setData()
    if i == 16 and torchSlot == 0 then
        print('Going Home For Torches')
        torchFail = 'yes'
        torchHome()
        torchPlace()
        break 
    elseif dataName == 'minecraft:torch' then
      torchSlot = i
      torchFail = 'no'
      break
    else 
      i = i + 1
    end
  end 
end



function torchCheck()
  if torchSlot == 0 then
    torchLoop = 'yes'
    torchSlotGet()
  end
  if turtle.getItemCount(torchSlot) == 0 then
    torchSlot = 0
    torchLoop = 'yes'
    torchSlotGet()
  end 
  torchSlot = 1
  turtle.select(torchSlot)
  setData()
  if dataName == 'minecraft:torch' then
    torchSlot = torchSlot
  else
    torchSlot = 0
    torchLoop = 'yes'
    torchSlotGet()
  end
    
end 

    

function torchPlace()
  if onShaft == 'no' then
    if torchUp == 0 then
      torchUp = 3
      end
    if torchFail == 'yes' then
      turtle.select(torchSlot)
      turtle.placeUp()
      if firstTorch == 'no' then
        branch()
      end 
      turtle.forward()
      steps = steps + 1
      if turtle.getItemCount(oldSlot) == 0 then
        oldSlot = 1
        currentSlot = 1
      end 
      turtle.select(oldSlot)
    end
    if torchUp == 3 and torchFail == 'no' then
      turtle.back()
      steps = steps - 1
      torchCheck()
      if torchLoop == 'yes' then 
        torchLoop = 'no'
      end
      turtle.select(torchSlot)
      turtle.placeUp()
      if firstTorch == 'no' then
        branch()
      end 
      firstTorch = 'no'
      turtle.forward()
      steps = steps + 1
      turtle.select(oldSlot)
    end
      torchUp = torchUp - 1
      torchFail = 'no'
      
  elseif leftOrRightShaft == 'right' then
    if torchRight == 0 then
      torchRight = 3
      end
    if torchFail == 'yes' then
      if turtle.getItemCount(oldSlot) == 0 then
        oldSlot = 1
        currentSlot = 1
      end 
      turtle.select(torchSlot)
      turtle.placeUp()
      turtle.forward()
      stepsRight = stepsRight + 1
      turtle.select(oldSlot)
    end
    if torchRight == 3 and torchFail == 'no' then
      turtle.back()
      stepsRight = stepsRight - 1
      torchCheck()
      if torchLoop == 'yes' then 
        torchLoop = 'no'
        return
      end
      turtle.select(torchSlot)
      turtle.placeUp()
      turtle.forward()
      stepsRight = stepsRight + 1
      turtle.select(oldSlot)
      end
      torchRight = torchRight - 1
      torchFail = 'no' 
    
  elseif leftOrRightShaft == 'left' then
    if torchLeft == 0 then
      torchLeft = 3
      end
    if torchFail == 'yes' then
      if turtle.getItemCount(oldSlot) == 0 then
        oldSlot = 1
        currentSlot = 1
      end 
      turtle.select(torchSlot)
      turtle.placeUp()
      turtle.forward()
      stepsLeft = stepsLeft + 1
      turtle.select(oldSlot)
    end
    if torchLeft == 3 and torchFail == 'no' then
      turtle.back()
      stepsLeft = stepsLeft - 1
      torchCheck()
      if torchLoop == 'yes' then 
        torchLoop = 'no'
        return
      end
      turtle.select(torchSlot)
      turtle.placeUp()
      turtle.forward()
      stepsLeft = stepsLeft + 1
      turtle.select(oldSlot)
      end
      torchLeft = torchLeft - 1
      torchFail = 'no'
    end 
  end


-- inv cob check --
function cobCheck()
    oldSlot = currentSlot
    local i = 1
    while  cobSlot == 0 do
        turtle.select(i)
        while turtle.getItemSpace() == 64 do
            i = i + 1
            turtle.select(i)
            if i == 16 and cobSlot == 0 then
              print('Going Home To Get Some Cob')
              cobHome()
              break
            end
         end
        setData()
        if dataName == 'minecraft:cobblestone' then
           cobSlot = i
           break
        end
        if i == 16 and cobSlot == 0 then 
            print('Going Home To Get Cob')
            cobHome()
            break
        end 
        i = i + 1
    end
end




function cobGrab()
    turtle.select(2)
    while turtle.getItemSpace() == 64 do
        print('I am waiting for cob in slot 2') 
        sleep(10)
    end
    cobSlot = 2
end  

-- movement functions --
function forward() 
    dig()
    turtle.forward()
    if onShaft == 'yes' and leftOrRightShaft == 'right' then
      stepsRight = stepsRight + 1
    elseif leftOrRightShaft == 'left' then
      stepsLeft = stepsLeft +1
    else 
      steps = steps + 1
    end
end

function turnLeft()
    turtle.turnLeft()
    left()
end 

function turnRight()
    turtle.turnRight()
    right()
end

function turnAround()
    turnRight()
    turnRight()
    backward()
end

function up() 
  local x = 1
    while x == 1 do 
      if turtle.detectUp() then
        turtle.digUp()
        sleep(1)
        invCheck()
    else 
      x = 2
      end
    end
end

function upLeft()
    up()
    turnLeft()
end

function dig()
  local x = 1
    while x == 1 do
    if turtle.detect() then
        turtle.dig()
        sleep(1)
        invCheck()
    else 
      x = 2
      end
    end
end

    

function column() 
    dig()
    levelUp()
    up()
    dig()
end

function downTwo()
    levelDown()
    levelDown()
end

function downTwoRight()
    downTwo()
    turnRight()
end

function liquidCheckRight()
  cobPlaceUp()
  turnRight()
  front()
  turnRight()
  cobPlaceForward()
  levelDown()
  cobPlaceForward()
  levelDown()
  cobPlaceForward()
  cobPlaceUnder()
  turnLeft()
  turnLeft()
  left()
  forward()
  stepsRight = stepsRight - 1
  rightShaftLR = 'left'
  cobPlaceUnder()
  cobPlaceForward()
  levelUp()
  cobPlaceForward()
  levelUp()
  cobPlaceForward()
  cobPlaceUp()
  levelDown()
  levelDown()
  turtle.back()
  rightShaftLR = 'right'
  turnRight()
  front()   
end

function liquidCheckLeft()
  cobPlaceUp()
  turnRight()
  front()
  turnRight()
  cobPlaceForward()
  levelDown()
  cobPlaceForward()
  levelDown()
  cobPlaceForward()
  cobPlaceUnder()
  turnLeft()
  turnLeft()
  left()
  forward()
  stepsLeft = stepsLeft - 1
  leftShaftLR = 'left'
  cobPlaceUnder()
  cobPlaceForward()
  levelUp()
  cobPlaceForward()
  levelUp()
  cobPlaceForward()
  cobPlaceUp()
  levelDown()
  levelDown()
  turtle.back()
  leftShaftLR = 'right'
  turnRight()
  front()   
end

-- check for lava or water -- 
function liquidCheck()
  if onShaft == 'no' then
    cobPlaceUp()
    turnRight()
    front()
    turnRight()
    cobPlaceForward()
    levelDown()
    cobPlaceForward()
    levelDown()
    cobPlaceForward()
    cobPlaceUnder()
    turnLeft()
    turnLeft()
    left()
    forward()
    steps = steps - 1
    leftOrRight = 'left'
    cobPlaceUnder()
    cobPlaceForward()
    levelUp()
    cobPlaceForward()
    levelUp()
    cobPlaceForward()
    cobPlaceUp()
    levelDown()
    levelDown()
    turtle.back()
    leftOrRight = 'right'
    turnRight()
    front()
  end 
end 


function cobPlaceUnder()
    if turtle.detectDown() == false then
        cobCheck()
        turtle.select(cobSlot)
        if turtle.getItemSpace() == 64 then
          cobSlot = 0
          cobCheck()
          end
        setData()
        if dataName == 'minecraft:cobblestone' then
          turtle.placeDown()
        else  
          cobSlot = 0
          cobCheck()
        end
    end
end
function cobPlaceUp()
    if turtle.detectUp() == false then
        cobCheck()
        turtle.select(cobSlot)
        if turtle.getItemSpace() == 64 then
          cobSlot = 0
          cobCheck()
          end
        setData()
        if dataName == 'minecraft:cobblestone' then
          turtle.placeUp()
        else  
          cobSlot = 0
          cobCheck()
        end
    end
end
 

function cobPlaceForward()
    if turtle.detect() == false then 
        cobCheck()
        turtle.select(cobSlot)
        if turtle.getItemSpace() == 64 then
          cobSlot = 0
          cobCheck()
          end
        setData()
        if dataName == 'minecraft:cobblestone' then
          turtle.place()
        else  
          cobSlot = 0
          cobCheck()
        end
    end
end


function doorway()
  forward()
  upLeft()
  dig()
  turtle.up()
  dig()
  cobPlaceUp()
  turtle.forward()   
  cobPlaceUp()
  turtle.down()
  cobPlaceUnder()
  turtle.back()
  turnRight()
  front()
end
   
-- main run -- 
  
function main()
    front()
    torchPlace() 
    forward()
    upLeft()
    column()
    levelUp()
    dig()
    liquidCheck()  
end

function mainRight()
    front()
    torchPlace() 
    forward()
    upLeft()
    column()
    levelUp()
    dig()
    liquidCheckRight()      
end

function mainLeft()
    front()
    torchPlace() 
    forward()
    upLeft()
    column()
    levelUp()
    dig()
    liquidCheckLeft()     
end
--create the main shaft -- 
function mainShaft () 
  fuelStart = turtle.getFuelLevel()
  print('My Fuel Is: ', fuelStart)
    for i = 1, mainShaftLength do 
      print('Im on Main Loop Numer: ', i)
      leftOrRightShaft = ''
        main()
        if i == mainShaftLength  then
          shaftStatusMain = 'finished'
          print('All Done, Heading Home')
          home()
          fuelEnd = turtle.getFuelLevel
          fuelNeeded = fuelStart - fuelEnd
          print('Fuel Needed is: ', fuelNeded)
          
        end 
    end
end

function mainShaftRight () 
  onShaft = 'yes'
  doorway()
    for i = 1, branchShaftLength do 
      print('Im on Right Shaft Loop Numer: ', i)
        mainRight()
        if i == branchShaftLength  then
          shaftStatusRight = 'finished'
          print('All Done, Heading Back to Main Shaft')
          home()
        end 
    end
end

function mainShaftLeft () 
  onShaft = 'yes'
  doorway()
    for i = 1, branchShaftLength do 
      print('Im on Left Shaft Numer: ', i)
        mainLeft()
        if i == branchShaftLength  then
          shaftStatusLeft = 'finished'
          print('All Done, Heading Back to Main Shaft')
          home()
        end 
    end
end







-- start a branch shaft --

function leftShaft()
  onShaft = 'no'
  forward()
  turtle.turnLeft()
  onShaft = 'yes'
  leftOrRightShaft = 'left'
  forward()
  mainShaftLeft()
  shaftStatusLeft = 'finished'
  onShaft = 'no' 
  stepsLeft = '0'
  forward()
end

function rightShaft()
  turtle.back()
  steps = steps - 1
  turtle.back() 
  steps = steps - 1
  turnRight()
  onShaft = 'yes'
  leftOrRightShaft = 'right'
  mainShaftRight()
  shaftStatusRight = 'finished'
  stepsRight = '0'
end

function branch()
  shaftStatusLeft = 'unfinished'
  shaftStatusRight = 'unfinished'
  leftOrRightShaft = 'right'
  rightShaft()
  leftShaft()
  onShaft = 'no'
  leftOrRightShaft = ''
end

-- testing chunk load distance -- 
function chunkTest()
    for i = 1, 100 do 
        turtle.forward()
    end
    turnAround()
    for i = 1, 100 do 
        turtle.forward()
    end
end

mainShaft()

