require 'gosu'

class Spaceflight < Gosu::Window
    
    def initialize
        super 800, 600  #super calls the same method from a parent, window: 800 pixels wide & 600 pixels high
        self.caption = "Spaceflight"

        @background_image = Gosu::Image.new("assets/media/space.jpg", :tileable => true)

        @player = Player.new # creates/initializes an instance of the player
        @player.warp(400, 300) # sets the player in the center of viewport ( 1/2 of 800x600 )
    end

    def update #movement logic in here

        if Gosu.button_down? Gosu::KB_LEFT or Gosu::button_down? Gosu::GP_LEFT or Gosu::button_down? Gosu::KB_A
            @player.turn_left   #when player presses left arrow key or A on keyboard or left button on controller
        end                     #it calls turn_left method in the Player class

        if Gosu.button_down? Gosu::KB_RIGHT or Gosu::button_down? Gosu::GP_RIGHT or Gosu::button_down? Gosu::KB_D
            @player.turn_right  
        end

        if Gosu.button_down? Gosu::KB_UP or Gosu::button_down? Gosu::GP_BUTTON_0 or Gosu::button_down? Gosu::KB_W
            @player.accelerate
        end

        @player.move

    end

    def draw #renders the visuals
        @background_image.draw(0, 0, 0) # drawn at x 0 , y 0 and z-index of 0
        @player.draw
    end

    def button_down(id)
        if id == Gosu::KB_ESCAPE
            close
        else
            super
        end  
    end

end

class Player #Settings for player character

    def initialize
        @image = Gosu::Image.new("assets/media/player-ship.bmp")
        @x = @y = @vel_x = @vel_y = @angle = 0.0 # set player position to 0.0 to start
        @score = 0
    end

    def warp(x, y)
        @x, @y = x, y #setting x/y to instance variables
    end

    def turn_left
        @angle -= 4.5 #subtracting from angle to turn left
    end

    def turn_right
        @angle += 4.5 #adding to angle to turn right
    end

    def accelerate
        @vel_x += Gosu.offset_x(@angle, 0.5)
        @vel_y += Gosu.offset_y(@angle, 0.5)
    end

    def move
        @x += @vel_x
        @y += @vel_y
        @x %= 850 #sets width of moveable area (in this case 50 pixels beyond window edge)
        @y %= 650 #sets height of moveable area (in this case 50 pixels beyond window edge)

        @vel_x *= 0.95
        @vel_y *= 0.95
    end

    def draw
        @image.draw_rot(@x, @y, 1, @angle) # center of player sprite at x,y with z-index of 1 (in front of background image)
    end

end




Spaceflight.new.show