class Board
    attr_accessor :field
    
    def initialize(word)
        @field = []
        word.length.times do |i|
            @field << "_"
        end
    end

    def won?
        @field.all? { |cell| cell != "_" }
    end

    def show(turn)
        @field.length.times do |i|
            print "#{@field[i]} "
        end
        puts ""
        turn.times { print "  "} if turn != nil
        print "^"
        puts ""
    end
end