% Created by Bonny C
% November 11th, 2020
% Dodge the shooting stars

%============================== Main Variables ==============================%

var numStars : int := 1 % Number of shooting stars
var dodgedStars : int := 0 % Total number of missiles evaded
var positionx : int := maxx div 2 % x position of the ship
var positiony : int := maxy div 2 % y position of the ship
var turns, distance : int
var x, y, b : int

var groundColour := 1
var starColour1 := yellow
var starColour2 := 42
var explosionColour := 1
var shipColour := 86
var playerSpeed := 5
var turnDelay := 100
var outOfPlay := -1
var maxStars := 100


%============================== Fonts ==============================%

var font1, font2, font3 : int

font1 := Font.New ("Calibri:50:Bold")
font2 := Font.New ("Calibri:25")
font3 := Font.New ("Calibri:15")

%============================== How to Play ==============================%

procedure Instructions
    setscreen ("noecho, nocursor")
    cls
    drawfill (maxx, maxy, 1, 127)
    drawfillstar (1, 400, 650, 350, 86)
    Font.Draw ("You are flying a starship flying through Solaria. Unfortunately, it was", 10, 320, font3, white)
    delay (500)
    Font.Draw ("during the time of a star storm where a bunch of shooting stars shoot", 10, 300, font3, white)
    delay (500)
    Font.Draw ("throughout the galaxy. A bunch of stars will be heading straight for you.", 10, 280, font3, white)
    delay (500)
    Font.Draw ("But if you manuever carefully, you'll be able to dodge the stars", 10, 260, font3, white)
    delay (500)
    Font.Draw ("until they completely fall.", 10, 240, font3, white)
    delay (500)
    Font.Draw ("To control your spaceship, use the mouse buttons.", 10, 220, font3, white)
    delay (500)
    Font.Draw ("Your ship will move to whereever you click your mouse at.", 10, 200, font3, white)
    delay (500)
    Font.Draw ("Stars all start out as", 10, 180, font3, white)
    Font.Draw ("yellow", 185, 180, font3, yellow)
    Font.Draw ("and turns", 246, 180, font3, white)
    delay (500)
    Font.Draw ("orange", 10, 160, font3, 40)
    Font.Draw ("when they start to fall", 78, 160, font3, white)
    delay (500)
    Font.Draw ("You must try to survive for as long as you can", 10, 140, font3, white)
    delay (500)
    Font.Draw ("After surviving each wave, the next wave will be launched", 10, 120, font3, white)
    delay (500)
    Font.Draw ("Your ship will leave a white strail to show your path of travel.", 10, 100, font3, white)
    delay (500)
    Font.Draw ("Hope you survive!", 10, 80, font3, white)
    delay (500)
    Font.Draw ("Press any key to continue...", 10, 30, font2, 86)
    Input.Pause
    cls
end Instructions

%=========================================================================%
%============================== Menu Screen ==============================%
%=========================================================================%


procedure Start
    loop
	drawfill (maxx, maxy, 1, 127)
	drawfillbox (100, 120, 650, 130, 88)
	drawfillbox (100, 110, 650, 120, 90)
	drawfillbox (100, 100, 650, 110, 100)
	drawfillbox (100, 90, 650, 100, 80)
	drawfillbox (100, 80, 650, 90, 82)
	drawfillstar (30, 180, 190, 10, yellow)
	drawfillbox (1, 380, 650, 380, yellow)
	Font.Draw ("Dodge the Stars", 100, 300, font1, 86)
	drawfillbox (235, 170, 400, 250, 38)
	Font.Draw ("Play", 257, 190, font1, 127)
	Mouse.Where (x, y, b)
	exit when (x > 235 and x < 400 and y > 170 and y < 250 and b = 1)
	delay (500)
    end loop
end Start


%============================== Space Ship ==============================%

procedure Starship (move : int)
    drawfillstar (round (positionx - 10), round (positiony - 10), round (positionx + 10), round (positiony + 10), move)
end Starship

Start
Instructions

%============================== Player Controls ==============================%

procedure ControlPlayer
    Mouse.Where (x, y, b)
    if b = 1 and (x not= positionx or y not= positiony) then
	Starship (0)

	var d : real := sqrt ((x - positionx) ** 2 + (y - positiony) ** 2)
	var dx : int := round ((x - positionx) * playerSpeed / d)
	var dy : int := round ((y - positiony) * playerSpeed / d)
	if abs (dx) > abs (x - positionx) then
	    positionx := x
	else
	    positionx := positionx + dx
	end if
	if abs (dy) > abs (y - positiony) then
	    positiony := y
	else
	    positiony := positiony + dy
	end if

	% Make sures the player doesn't go off the screen.
	if positionx < 10 then
	    positionx := 10
	elsif positionx > maxx - 10 then
	    positionx := maxx - 10
	end if
	if positiony < 10 then
	    positiony := 10
	elsif positiony > maxy - 10 then
	    positiony := maxy - 10
	end if

	% Draw the player in its new position
	Starship (shipColour)
    end if
end ControlPlayer

%============================== Shooting Stars ==============================%
loop

    var px, py : array 1 .. maxStars of int
    % The position array for the stars
    var vx, vy : array 1 .. maxStars of int
    % The velocity array for the stars

    randomize
    View.Set ("graphics,noecho")

    loop
	% Random shooting stars
	for i : 1 .. numStars
	    px (i) := Rand.Int (0, maxx)
	    py (i) := 0
	    vx (i) := 0
	    vy (i) := Rand.Int (1, 5)
	end for

	% Background
	cls
	drawfill (maxx, maxy, 1, 127) % Space sky
	Starship (shipColour)
	drawline (0, 0, maxx, 0, 1)
	Font.Draw ("Wave " + intstr (numStars), 10, 370, font2, 38)
	turns := 0

	%============================== Gravity ==============================%

	% The main loop
	loop
	    turns += 1
	    for i : 1 .. numStars
		var ox : int := px (i)
		var oy : int := py (i)

		if ox not= outOfPlay then
		    % Determine the x velocity
		    distance := abs (vx (i)) * (abs (vx (i)) + 1) div 2 % abs = absolute value
		    if vx (i) < 0 and ox - distance < 0 then
			vx (i) += 2
		    elsif vx (i) > 0 and ox + distance > maxx then
			vx (i) -= 2
		    elsif turns > 100 then
			if turns mod 20 = 0 then
			    vx (i) -= sign (vx (i))
			end if
		    elsif ox < positionx then
			vx (i) += 1
		    elsif ox > positionx then
			vx (i) -= 1
		    end if

		    % Determine the y velocity
		    distance := abs (vy (i)) * (abs (vy (i)) + 1) div 2
		    if vy (i) > 0 and oy + distance > maxy then
			vy (i) -= 2
		    elsif turns > 100 then
			if turns mod 8 = 0 then
			    vy (i) -= 1
			end if
		    elsif vy (i) < 0 and oy - distance < -turns div 15 then
			vy (i) += 2
		    elsif oy < positiony then
			vy (i) += 1
		    elsif oy > positiony then
			vy (i) -= 1
		    end if

		    % Next shooting star position
		    px (i) += vx (i)
		    py (i) += vy (i)

		    % Draw the shooting star path line
		    if turns > 100 then
			Draw.ThickLine (ox, oy, px (i), py (i), 1, starColour2)
		    else
			Draw.ThickLine (ox, oy, px (i), py (i), 2, starColour1)
		    end if

		    % Check to see if it hit the ground
		    if py (i) <= 0 then
			drawline (px (i), 0, px (i) - 5, 5, explosionColour)
			drawline (px (i), 0, px (i), 6, explosionColour)
			drawline (px (i), 0, px (i) + 5, 5, explosionColour)
			px (i) := outOfPlay
			dodgedStars += 1
		    end if

		    % Check to see if it hit the spaceship
		    if Math.DistancePointLine (positionx, positiony, ox, oy, px (i), py (i)) < 3 then % Hit detection
			drawfillstar (positionx - 10, positiony - 10, positionx + 10, positiony + 10, 38)
			locate (10, 5)

			% Score/End Screen
			delay (1500)
			drawfill (maxx, maxy, 1, 100)
			delay (500)
			Font.Draw ("Game Over", 160, 280, font1, 86)
			delay (500)
			Font.Draw ("You dodged " + intstr (dodgedStars) + " shooting stars! ", 130, 200, font2, white)
			drawfillbox (100, 120, 650, 130, 88)
			drawfillbox (100, 110, 650, 120, 90)
			drawfillbox (100, 100, 650, 110, 100)
			drawfillbox (100, 90, 650, 100, 80)
			drawfillbox (100, 80, 650, 90, 82)
			drawfillstar (30, 180, 190, 10, yellow)
			loop

			    Mouse.Where (x, y, b)
			    if b = 1 and x > 230 and x < 370 and y > 5 and y < 40 then
				drawfillbox (150, 5, 290, 40, 0)
			    else
				drawfillbox (150, 5, 290, 40, 0)
				Font.Draw ("Play Again", 150, 16, font2, 38)
			    end if
			    delay (100)
			    Mouse.Where (x, y, b)
			    if b = 1 and x > 320 and x < 460 and y > 5 and y < 40 then
				drawfillbox (320, 5, 460, 40, 0)
			    else
				drawfillbox (320, 5, 460, 40, 0)
				Font.Draw ("Quit", 360, 16, font2, 38)
			    end if
			    delay (100)
			    exit when (b = 1 and x > 150 and x < 290 and y > 5 and y < 40) or (b = 1 and x > 320 and x < 460 and y > 5 and y < 40)
			end loop
			locate (1, 1)
			delay (1000)
			return
		    end if
		end if
	    end for

	    ControlPlayer
	    Time.DelaySinceLast (30)

	    % Loop exits when all the stars have fallen.
	    var endNow : boolean := true
	    for i : 1 .. numStars
		if px (i) not= outOfPlay then
		    endNow := false
		end if
	    end for
	    exit when endNow
	end loop

	% Add one shooting star after every level

	numStars += 1
	if numStars > maxStars then
	    numStars := maxStars
	end if
    end loop
    exit when b = 1 and x > 320 and x < 460 and y > 5 and y < 40
end loop
