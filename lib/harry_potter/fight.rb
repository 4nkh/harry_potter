module Fight
    def first_attack(name, defender, first_move=false)
        puts "The fight begin ..." if first_move
        str = "#{name}: "
        for n in @characters
            if n[0] == name
                str += n[7] + "! and " unless n[7].blank?
                str += "send terrible lightning hit #{defender}"
            end
        end
        puts str
        return str
    end

    def second_attack(name, defender)
        str = "#{name}: "
        for n in @characters
            if n[0] == name
                str += n[7] + "! and " unless n[7].blank?
                str += "throw a fireball hit #{defender}"
            end
        end
        puts str
        return str
    end
end