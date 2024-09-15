module TextFight

    @@first_text = [" recovered from the attack of ", " has been injured by the last attack of "]
    @@super_move = ["Wow it was a great magical trick", "Beautiful move, it hurt the opponent"]

    def self.class_method_between_attack(name, defender)
        index = Random.rand(@@first_text.length)
        puts defender + @@first_text[index] + name
        return defender + @@first_text[index] + name
    end

    def between_attack(name, defender)
        index = Random.rand(@@first_text.length)
        puts defender + @@first_text[index] + name
        return defender + @@first_text[index] + name
    end

    def end_fight(winner)
        index = Random.rand(@@first_text.length)
        puts @@super_move[index]
        puts "#{winner} won the fight"
        puts
        return @@super_move[index] + " ... " + "#{winner} won the fight"
    end
end