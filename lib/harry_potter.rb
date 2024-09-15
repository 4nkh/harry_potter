require 'harry_potter/builder'
require 'active_support'
require 'active_support/core_ext' # to support blank? without rails
require 'harry_potter/fight'
require 'harry_potter/text_fight'

class HarryPotter < Builder

    include Fight
    extend TextFight

    def initialize()
        get_data() 

        @characters, @houses = [], []
        build_all_names()
        build_houses()

        @houses_with_max_ages, @houses_with_min_ages = {}, {}
        build_max_ages_by_houses()
        build_min_ages_by_houses()

        @average_max, @average_min = {}, {}
        build_average_ages_by_houses(@houses_with_max_ages, @average_max)
        build_average_ages_by_houses(@houses_with_min_ages, @average_min, false)
    end

    def self.cmd_list()
        puts "Instantiate HarryPotter: hp = HarryPoter.new"
        puts
        puts "See random fights between characters: hp.random_fight"
        puts
        puts
        puts "USEFUL METHODS TO SEE THE DATA: "
        puts
        puts "see characters arrays: hp.show_characters"
        puts
        puts "see houses: hp.show_houses"
        puts
        puts "see the oldest ages recorded by houses: hp.show_houses_with_max_ages"
        puts
        puts "see the yougest ages recorded by houses: hp.show_houses_with_min_ages"
        puts
        puts "see the average for the oldest ages recorded by houses: hp.how_average_max"
        puts
        puts "see the average for the youngest ages recorded by houses: hp.how_average_min"
        puts
        puts "see wands: hp.show_wands" #have to complete
        puts
        puts "see json data: hp.show_json"
        puts
    end

    def random_fight()
        first = @characters[Random.rand(@characters.length)][0]
        second = @characters[Random.rand(@characters.length)][0]
        if first == second
            for i in 0...5
                second = @characters[Random.rand(@characters.length)][0]
                break if first != second
            end
        end
        for n in @characters
            first_alias = n[8] if n[0] == first
            second_alias = n[8] if n[0] == second
            first_country = n[7] if n[0] == first
            second_country = n[7] if n[0] == second
            first_city = n[6] if n[0] == first
            second_city = n[6] if n[0] == second
            first_city = n[6] if n[0] == first
            second_city = n[6] if n[0] == second
            first_occupation = n[5] if n[0] == first
            second_occupation = n[5] if n[0] == second
            # if n[4][0].nil?
            # puts n[4][0].key?("wood") #.index {|h| h["wood"] }
            # n[4].key?("wood") if n[0] == first
            first_wand = ""
            second_wand = ""
            first_wand = n[4][0].key?("wood") ? "wand: in " + n[4][0]["wood"] + " using a core of " + n[4][0]["core"] + " with a length of " + n[4][0]["length"].to_s : "" if n[0] == first && !n[4][0].nil?
            second_wand = n[4][0].key?("wood") ? "wand: in " + n[4][0]["wood"] + " using a core of " + n[4][0]["core"] + " with a length of " + n[4][0]["length"].to_s : "" if n[0] == second && !n[4][0].nil?
        end

        str1 = first_attack(first, second, false)
        str2 = TextFight.class_method_between_attack(second, first)
        str3 = second_attack(second, first)
        str4 = HarryPotter.between_attack(first, second)
        str5 = first_attack(first, second)
        str6 = HarryPotter.end_fight(first)
        body = '{"first": "'+ first + '", "second": "'+ second + 
                '", "str1": "' + str1 + '", "str2": "' + str2 + 
                '", "str3": "' + str3 + '", "str4": "' + str4 + 
                '", "str5": "' + str5 + '", "str6": "' + str6 + 
                '", "first_alias": "' + first_alias + '", "second_alias": "' + second_alias + 
                '", "first_city": "' + first_city + '", "second_city": "' + second_city + 
                '", "first_country": "' + first_country + '", "second_country": "' + second_country + 
                '", "first_wand": "' + first_wand + '", "second_wand": "' + second_wand +
                '", "first_occupation": "' + first_occupation + '", "second_occupation": "' + second_occupation + '"}'
        send_post_request(body)
    end

    def get_all_names()
        a = []
   
        puts "The list of all character names : "
        for n in @characters
            puts "\t" + n[0]
            a << n[0]
        end
        return a
    end

    # [["HarryPotter", "Gryffindor", [18, 18, 18, 18, 17], ["student", "Auror"], [{"wood"=>"Holly", "core"=>"Phoenixfeather", "length"=>11}], "", "", "Stag", ""],
    # ["HermioneGranger", "Gryffindor", [18, 18, 18, 18, 18, 17], [], [], "", "", "Otter", ""],
    # ["RonWeasley", "Gryffindor", [18, 18, 18, 17], ["student"], [{"wood"=>"Willow", "core"=>"Unicornhair", "length"=>14}], "", "", "JackRussellTerrier", ""],
    # ["LordVoldemort", nil, [], [], [], "", "", "", ""],
    # ["DracoMalfoy", "Slytherin", [18, 18], [], [{"wood"=>"Hawthorn", "core"=>"Unicornhair", "length"=>10}], "", "", "", ""],
    # ["LunaLovegood", "Ravenclaw", [18, 17], ["student", "Magizoologist"], [], "", "", "", ""],
    # ["VincentCrabbe", "Slytherin", [18, 18], [], [], "England", "UK", "", ""],
    # ["GinnyWeasley", "Gryffindor", [], [], [{"wood"=>"Yew", "core"=>"Phoenixfeather", "length"=>9}], "", "", "Horse", ""],
    # ["NevilleLongbottom", "Gryffindor", [18], ["ProfessorofHerbology"], [], "", "", "", ""],
    # ["TomRiddle", nil, [], [], [], "", "", "", "LordVoldemort"],
    # ["BellatrixLestrange", nil, [], [], [], "", "", "", "Bella"],
    # ["GregoryGoyle", nil, [18], [], [], "England", "UK", "", ""]]
    def show_characters()
        return @characters
    end

    # ["Gryffindor", "Ravenclaw", "Slytherin"]
    def show_houses()
        return @houses
    end

    # {"Gryffindor"=>[18, 18, 18, 18], "Slytherin"=>[18, 18], "Ravenclaw"=>[18]}
    def show_houses_with_max_ages()
        return @houses_with_max_ages
    end

    # {"Gryffindor"=>[17, 17, 17, 18], "Slytherin"=>[18, 18], "Ravenclaw"=>[17]}
    def show_houses_with_min_ages()
        return @houses_with_min_ages
    end

    # {"Gryffindor"=>18.0, "Slytherin"=>18.0, "Ravenclaw"=>18.0}
    def show_average_max()
        return @average_max
    end
    # {"Gryffindor"=>17.25, "Slytherin"=>18.0, "Ravenclaw"=>17.0}
    def show_average_min()
        return @average_min
    end

    def show_wands()
        for w in @characters
            puts "#{}" unless w[4].blank?
        end
        # return
    end

    # watch in hp_data for more detail
    def show_json()
        return @data
    end

    def average_max()
        puts "This average use the older age recorded for each people in the json data to get the average"
        puts
        @average_max.each do |key, value|
            puts key.to_s + " average age members are: \t" + value.to_s
        end
    end

    def average_min()
        puts "This average use the younger age recorded for each people in the json data to get the average"
        puts
        @average_min.each do |key, value|
            puts key.to_s + " average age members are: \t" + value.to_s
        end
    end

    def occupations()
        add_occupations()
        for n in @characters
            str = ""
            for o in n[3]
                str += o
                str += " & " if o != n[3].last
            end
            puts n[0] + " occupation's : \t\t" + str unless n[3].blank?
        end
        return @characters
    end

private
    def get_data()
        @data = super
    end

    def get_data_from_uri()
        @data = super
    end

    def build_all_names()
        @characters = super
    end

    def build_houses()
        @houses = super
    end

    def build_average_ages_by_houses(data, average, max=true)
        if max
            @average_max = super
        else
            @average_min = super
        end
    end
end