-- I really miss those golden Kade Engine days....
-- Average4k ftw :D

function start(song) -- do nothing
    bfsinging= true;
    spinLength = 0
    if getProperty('LuaMidscroll') then
        if getProperty('LuaOpponent') then
            for i=0,3 do
                local receptor = _G['receptor_'..i]
                receptor.x = receptor.defaultX + 332.5;
                setOpponentLaneUnderLayOpponentPos(_G['receptor_'..0].x - 25)
            end
            for i=4,7 do
                local playerReceptor = _G['receptor_'..i]
                playerReceptor.x = playerReceptor.defaultX+900;
                setLaneUnderLayPos(_G['receptor_'..4].x-25)
            end
        else
            for i=0,3 do 
                local receptor = _G['receptor_'..i]
                receptor.x = receptor.defaultX - 900;
                setOpponentLaneUnderLayOpponentPos(_G['receptor_'..0].x - 25)
            end
            for i=4,7 do
                local playerReceptor = _G['receptor_'..i]
                playerReceptor.x = playerReceptor.defaultX-308.5;
                setLaneUnderLayPos(_G['receptor_'..4].x-25)
            end
        end
    end

end

local function camZoom() --Simulate a camZoom 
    if zoomAllowed then
        camHUD:tweenZoom(1.06,0.01/rate, 'linear')
        camHUD:tweenZoom(1, 0.5/rate, 'elasticout')
        if bfsinging then
            camGame:tweenZoom(1.06,0.01/rate, 'linear')
            camGame:tweenZoom(1, 0.5/rate, 'elasticout')
        else
            camGame:tweenZoom(1.36,0.01/rate, 'linear')
            camGame:tweenZoom(1.3, 0.5/rate, 'elasticout')
        end
    end
end

local function speedBounce() --Interlope speed notes effect
    setScrollSpeed(1)
    changeScrollSpeed(scrollspeed,0.35/rate,'sineout')
end

local function spin() --Do the endless spin strums 
    for i=0,7 do
        local receptor = _G['receptor_'..i]
        receptor:tweenAngle(receptor.angle+360,0.5/rate,'smootherStepInOut')
    end
end

function update(elapsed) --Sway Strum's X and Y
    --camGame:shake(0.005) -Some screen shake stuff bruh
    --camHUD:shake(0.005)
    if difficulty == 2 and curStep > math.floor(400 * rate) then
        local currentBeat = (songPos / 1000)*(bpm*rate/60)
        if spinLength < 32 then
            spinLength = spinLength + 0.2
        end
        if not getProperty('LuaMidscroll') then
            for i=0,7 do
                local receptor = _G['receptor_'..i]
                receptor.x = receptor.defaultX + spinLength * math.sin((currentBeat + i*0.25) * math.pi)
                receptor.y = (receptor.defaultY+10) + spinLength * math.cos((currentBeat + i*0.25) * math.pi)
            end
        else
            if getProperty('LuaOpponent') then
                for i=0,3 do
                    local receptor = _G['receptor_'..i]
                    receptor.x = (receptor.defaultX+332.5) + spinLength * math.sin((currentBeat + i*0.25) * math.pi)
                    receptor.y = (receptor.defaultY+10) + spinLength * math.cos((currentBeat + i*0.25) * math.pi)
                end
            else
                for i=4,7 do
                    local receptor = _G['receptor_'..i]
                    receptor.x = (receptor.defaultX-308.5) + spinLength * math.sin((currentBeat + i*0.25) * math.pi)
                    receptor.y = (receptor.defaultY+10) + spinLength * math.cos((currentBeat + i*0.25) * math.pi)
                end
            end
        end
    end
end

function beatHit(beat) -- do nothing

end

function stepHit(step) -- do nothing
    if step < math.floor(413*rate) then
        if step % math.floor(8*rate) == math.floor(4*rate) and (step < math.floor(254*rate) or step > math.floor(323*rate)) then
            spin()
            camZoom()
            if difficulty == 2 then
                speedBounce()
            end
        else 
            if step % math.floor(16*rate) == math.floor(8*rate) and (step >= math.floor(254*rate) and step < math.floor(323*rate)) then
                spin()
                camZoom()
                if difficulty == 2 then
                    speedBounce()
                end
            end
        end
    end
end

function playerTwoTurn()
    bfsinging = false
    camGame.tweenZoom(camGame,1.3,((crochet * 4) / 1000)/rate, 'smootherStepInOut')
end

function playerOneTurn()
    bfsinging = true
    camGame.tweenZoom(camGame,1,((crochet * 4)/ 1000)/rate, 'smootherStepInOut')
end