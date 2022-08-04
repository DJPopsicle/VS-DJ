local spin1 = false
local spin2 = false
local spincenter = false
local normal1 = false
local normal2 = false

function start (song)

end

function setDefault(id)
	_G['defaultStrum'..id..'X'] = getActorX(id)
end

function startSong()
    for i = 4, 7 do -- go to the center
        tweenPosXAngle(i, _G['defaultStrum'..i..'X'] - 275,getActorAngle(i) + 360, 4, 'setDefault')
    end
end

function update (elapsed)

end

function beatHit (beat)
	if curStep >= 444 and curStep < 512 then
		setCamZoom(2)
		setHudZoom(2)
	end
end

function stepHit (step)
	
end