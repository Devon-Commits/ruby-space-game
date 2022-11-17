require 'gosu'


module ZOrder     #sets what elements are in front of what, ie background - 0 (behind other elements) to UI - 3 (front of screen)
    BACKGROUND, STARS, PLAYER, UI = *0..3
end


class Spaceflight < Gosu::Window
    
    def initialize
        super 800, 600  #super calls the same method from a parent, window: 800 pixels wide & 600 pixels high
        self.caption = "Spaceflight"

        @background_image = Gosu::Image.new("assets/media/space.jpg", :tileable => true)

        @player = Player.new # creates/initializes an instance of the player
        @player.warp(400, 300) # sets the player in the center of viewport ( 1/2 of 800x600 )

        @star_anim = Gosu::Image.load_tiles("assets/media/star.png", 25, 25)
        @stars = Array.new

        @font = Gosu::Font.new(20)
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
        @player.collect_stars(@stars)

        if rand(100) < 4 and @stars.size < 25
            @stars.push(Star.new(@star_anim))
        end
    end

    def draw #renders the visuals
        @background_image.draw(0, 0, ZOrder::BACKGROUND) # drawn at x 0 , y 0 and z-order set by module
        @player.draw
        @stars.each { |star| star.draw}
        @font.draw("Stars Collected: #{@player.score}", 10, 10, ZOrder::UI, 1.0, 1.0, Gosu::Color::WHITE)
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
    attr_reader :score

    def initialize
        @image = Gosu::Image.new("assets/media/player-ship.bmp")
        @beep = Gosu::Sample.new("assets/media/star.wav")
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
        @image.draw_rot(@x, @y, ZOrder::PLAYER, @angle) # center of player sprite at x,y
    end

    def score
        @score
    end

    def collect_stars(stars) #removes stars from the screen after the player reaches them
        stars.reject! do |star|
            if Gosu.distance(@x, @y, star.x, star.y) < 35
                @score += 1 #adds one to stars collected
                @beep.play #plays sound after star collected
                true
            else
                false
            end
        end
    end
end



# Add star animations

class Star
    attr_reader :x, :y

    def initialize(animation)
        @animation = animation
        @color = Gosu::Color::BLACK.dup
        @color.red = rand(256 - 40) + 40 
        @color.green = rand(256 - 40) + 40 
        @color.blue = rand(256 - 40) + 40
        @x = rand * 800 # stars will spawn at a random position within the play area
        @y = rand * 600
    end

    def draw
        img = @animation[Gosu.milliseconds / 100 % @animation.size] # shows a different frame every 100 milliseconds
        img.draw(@x - img.width / 2.0, @y - img.height / 2.0,
        ZOrder::STARS, 1, 1, @color, :add)
    end
end






Spaceflight.new.show