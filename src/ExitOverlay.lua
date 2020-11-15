ExitOverlay = Class("ExitOverlay")


function ExitOverlay:initialize()
    
    self.options =
    {
        "Continuar",
        "Sair"
    }
    self.isActive = false
    self.selectedOption = 1

end

function ExitOverlay:update(dt)

    if love.keyboard.wasJustPressed("escape") then
        self.isActive = not self.isActive
    end
    if not self.isActive then
        return
    end


    if love.keyboard.wasJustPressed("up") then
        self.selectedOption = self.selectedOption - 1
        Assets.getSfx("select.wav"):play()
        if self.selectedOption <= 0 then
            self.selectedOption = #self.options
        end
    elseif love.keyboard.wasJustPressed("down") then
        self.selectedOption = self.selectedOption + 1
        Assets.getSfx("select.wav"):play()
        if self.selectedOption > #self.options then
            self.selectedOption = 1
        end
    elseif love.keyboard.wasJustPressed("return") then
        local opt = self.options[self.selectedOption]
        Assets.getSfx("confirm.wav"):play()

        if opt == "Continuar" then
            self.isActive = not self.isActive
        elseif opt == "Sair" then
            love.mouse.setVisible(true)
            love.event.quit()
        else
            print"Option not found"
        end
    end

end


local function drawOptions(overlay, startX, startY)
    love.graphics.setFont(GAME_INTERFACE_FONT)
    for i, v in ipairs(overlay.options) do
        if i == overlay.selectedOption then
            love.graphics.setColor(1,1,1,1)
        else
            love.graphics.setColor(0.7,0.7,0.7,1)
        end
        love.graphics.printf(v, startX, startY + 40*(i-1), 200, "center")
    end
end

function ExitOverlay:draw()

    if not self.isActive then
        return
    end
    local r,g,b,a = love.graphics.getColor()
    love.graphics.setColor(0,0,0,0.5)

    love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())
    
    drawOptions(self, love.graphics.getWidth()/2.4, love.graphics.getHeight()/2.5)

    love.graphics.setColor(r,g,b,a)
end