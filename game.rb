class Game
    attr_accessor :word, :wrong, :turn

    def initialize(word, wrong, turn)
        word_list = File.read "5desk.txt"
        word = word_list.gsub(/\W/, " ").split(" ").select{|w| w.length > 5 && w.length < 12 }.sample.upcase if word == ""
        @word = word
        @wrong = wrong
        @turn = turn
        @body_parts = ["Head","Torso","L Leg","R Leg","L Arm","R Arm"]
        puts @word
    end

    def turn
        puts "Enter a letter for slot #{@turn+1}"
        puts "Type 'save' to save or 'load' to load"
        letter = gets.chomp.upcase
        if letter == "SAVE"
            self.save(@word, @wrong, @turn, @board.field)
        elsif letter == "LOAD"
            self.load
        elsif letter.length != 1 || letter.match(/[^A-Z]/)
            puts "Invalid Entry"
            self.turn
        elsif @word[@turn] == letter
            @board.field[@turn] = letter
            @turn = @turn + 1
        else
            @wrong = @wrong + 1
            puts ""
            @wrong.times do |i|
                puts @body_parts[i]
            end
        end
        @board.show(@turn) 
    end

    def play
        @board = Board.new(@word)
        @board.show(@turn)
        self.turn
        until @board.won? || @wrong >= 6
            self.turn
        end
        self.finish
    end

    def finish
        puts "You won! :D The word was #{@word}!" if @board.won?
        puts "You lost! :( The word was #{@word}" if @wrong >= 6
        puts ""
        puts "Do you want to play again?"
        puts "Y/N"
        answer = gets.chomp.downcase
        accepted_answers = ["y", "yes"]
        declined_answers = ["n", "no"]
        until accepted_answers.any? { |item| answer == item } || declined_answers.any? { |item| answer == item }
            puts "Enter yes or no."
        end
        Game.new("",0,0).play if accepted_answers.any? { |ans| ans == answer }
    end

    def save(word, wrong, turn, board)
        File.open('save.yml', 'w') {|file| file.write([word,wrong,turn,board].to_yaml)}
        puts ""
        puts "Game Saved!"
        puts ""
    end

    def load
        save_data = YAML.load_file('save.yml')
        @word = save_data[0]
        @wrong = save_data[1]
        @turn = save_data[2]
        @board.field = save_data[3]
        puts ""
        puts "Loaded Game."
        puts "------------"
        puts ""
    end
end