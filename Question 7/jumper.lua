--Called when the jumper UI module is loaded
function init()
    --Import the UI elements from jumper.otui and hook the window-opening function to when the game starts
    g_ui.importStyle('jumper')
    connect(g_game, {onGameStart = createWindow})
end

--Called when the jumper UI module is unloaded
function terminate()
    disconnect(g_game, {onGameStart = createwindow}) --Un-hook the createWindow callback as it's no longer needed

    --Destroy the UI elements so that the references don't linger
    jumpButton:destroy()
    jumperWindow:destroy()
    jumpButton = nil
    jumperWindow = nil
end

--Creates the window and button UI elements
function createWindow()
    jumperWindow = g_ui.createWidget('JumperWindow', rootWidget)
    jumpButton = jumperWindow:getChildById('jumpButton')
    scheduleEvent(moveButtonLeft, 25) --Queue the first call to the jump button-moving function
end

--The user was able to click the button, so put it back to the right and randomly set its vertical position within the window
function onJumpButtonClick()
    jumpButton:setMarginRight(0)
    jumpButton:setMarginBottom(math.random(0, jumperWindow:getHeight() - 50))
end

function moveButtonLeft()
    --If the button reaches the left side of the window, reset its position to the right of the window and somewhere random vertically
    if jumpButton:getX() - jumperWindow:getX() < 10 then
        jumpButton:setMarginRight(0)
        jumpButton:setMarginBottom(math.random(0, jumperWindow:getHeight() - 50))
    end

    --Move the button further to the left and queue the next call of this function
    jumpButton:setMarginRight(jumpButton:getMarginRight() + 5)
    scheduleEvent(moveButtonLeft, 25)
end