require 'gosu'

class Spaceflight < Gosu::Window
    
    def initialize
        super 800, 600  #super calls the same method from a parent, window: 800 pixels wide & 600 pixels high
        self.caption = "Spaceflight"

        @background_image = Gosu::Image.new("assets/media/solar-system.jpg", :tileable => true)

    end

    def update #main game logic in here
    end

    def draw #renders the visuals
        @background_image.draw(0, 0, 0)
    end

end


Spaceflight.new.show