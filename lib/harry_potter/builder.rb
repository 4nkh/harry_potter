require "harry_potter/hp_data"

class Builder < HpData

protected
    # [{"name"=>"HermioneGranger", "age"=>18, "house"=>"Gryffindor", "wand"=>{"wood"=>"Vine", "core"=>"Dragonheartstring", "length"=>10.75}, "occupation"=>nil},
    # {"name"=>"RonWeasley", "age"=>18, "house"=>"Gryffindor", "wand"=>{"wood"=>"Willow", "core"=>"Unicornhair", "length"=>14}, "occupation"=>"student"},
    # {"name"=>"HermioneGranger", "age"=>18, "house"=>"Gryffindor", "wand"=>{"wood"=>"Vine", "core"=>"Dragonheartstring", "length"=>10.75}, "occupation"=>nil},
    # {"name"=>"HarryPotter", "age"=>18, "house"=>"Gryffindor", "wand"=>{"wood"=>"Holly", "core"=>"Phoenixfeather", "length"=>11}, "occupation"=>"student"},
    # {"name"=>"RonWeasley", "age"=>18, "house"=>"Gryffindor", "wand"=>{"wood"=>"Willow", "core"=>"Unicornhair", "length"=>14}, "occupation"=>"student"},
    # {"name"=>"LunaLovegood", "age"=>18, "house"=>"Ravenclaw", "wand"=>{"wood"=>"Unknown", "core"=>"Unknown", "length"=>"Unknown"}, "occupation"=>"student"},
    # {"name"=>"HarryPotter", "age"=>18, "house"=>""},
    # {"name"=>"HermioneGranger", "age"=>18, "house"=>"Gryffindor"},
    # {"name"=>"HermioneGranger", "age"=>18, "house"=>"Gryffindor"},
    # {"name"=>"HarryPotter", "age"=>18, "house"=>"Gryffindor", "occupation"=>"Auror"},
    # {"name"=>"LunaLovegood", "age"=>17, "house"=>"Ravenclaw", "occupation"=>"Magizoologist"},
    # {"name"=>"NevilleLongbottom", "age"=>18, "house"=>"Gryffindor", "occupation"=>"ProfessorofHerbology"},
    # {"name"=>"VincentCrabbe", "age"=>18, "city"=>"England", "country"=>"UK", "occupation"=>nil},
    # {"name"=>"GregoryGoyle", "age"=>18, "city"=>"England", "country"=>"UK", "occupation"=>nil},
    # {"name"=>"DracoMalfoy", "age"=>18, "house"=>"Slytherin"},
    # {"name"=>"VincentCrabbe", "age"=>18, "house"=>"Slytherin"},
    # {"name"=>"TomRiddle", "alias"=>"LordVoldemort"},
    # {"name"=>"BellatrixLestrange", "alias"=>"Bella"},
    # {"name"=>"HarryPotter", "age"=>17, "house"=>"Gryffindor", "occupation"=>nil},
    # {"name"=>"HermioneGranger", "age"=>17, "house"=>"Gryffindor", "occupation"=>nil},
    # {"name"=>"RonWeasley", "age"=>17, "house"=>"Gryffindor", "occupation"=>nil},
    # {"name"=>"HarryPotter", "age"=>18, "house"=>"", "wand"=>{"wood"=>"Holly", "core"=>"Phoenixfeather", "length"=>11}, "patronus"=>"Stag"},
    # {"name"=>"HermioneGranger", "age"=>18, "house"=>"Gryffindor", "wand"=>{"wood"=>"", "core"=>"", "length"=>nil}, "patronus"=>"Otter"},
    # {"name"=>"RonWeasley", "age"=>18, "house"=>"Gryffindor", "wand"=>{"wood"=>"Willow", "core"=>"Unicornhair", "length"=>14}, "patronus"=>"JackRussellTerrier"},
    # {"name"=>"GinnyWeasley", "age"=>nil, "house"=>"Gryffindor", "wand"=>{"wood"=>"Yew", "core"=>"Phoenixfeather", "length"=>9}, "patronus"=>"Horse"},
    # {"name"=>"DracoMalfoy", "age"=>18, "house"=>"Slytherin", "wand"=>{"wood"=>"Hawthorn", "core"=>"Unicornhair", "length"=>10}, "patronus"=>nil}]
    def build_all_characters()
        @all_characters = []

        # friends
        friends = @data.map { |n| n["friends"] }
        for f in friends
            for n in f
                @all_characters << n
            end
        end

        # enemies
        enemies = @data.map { |n| n["enemies"] }
        for e in enemies
            for n in e
                @all_characters << n if n.instance_of? Hash # remove duplicate names (String)
            end
        end

        for n in @data
            c = n.dup # shallow copy of @data
            c.delete("friends")
            c.delete("enemies")
            @all_characters << c
        end
        merge_all_characters()
        return @all_characters
    end

    # [{"name"=>"HermioneGranger",
    # "age"=>[18, 18, 18, 18, 17, 18],
    # "house"=>["Gryffindor", "Gryffindor", "Gryffindor", "Gryffindor", "Gryffindor", "Gryffindor"],
    # "wand"=>[{"wood"=>"Vine", "core"=>"Dragonheartstring", "length"=>10.75}, {"wood"=>"Vine", "core"=>"Dragonheartstring", "length"=>10.75}, {"wood"=>"", "core"=>"", "length"=>nil}],
    # "occupation"=>[nil, nil, nil],
    # "patronus"=>"Otter"},
    # {"name"=>"RonWeasley",
    # "age"=>[18, 18, 17, 18],
    # "house"=>["Gryffindor", "Gryffindor", "Gryffindor", "Gryffindor"],
    # "wand"=>[{"wood"=>"Willow", "core"=>"Unicornhair", "length"=>14}, {"wood"=>"Willow", "core"=>"Unicornhair", "length"=>14}, {"wood"=>"Willow", "core"=>"Unicornhair", "length"=>14}],
    # "occupation"=>["student", "student", nil],
    # "patronus"=>"JackRussellTerrier"},
    # {"name"=>"HarryPotter",
    # "age"=>[18, 18, 18, 17, 18],
    # "house"=>["Gryffindor", "", "Gryffindor", "Gryffindor", ""],
    # "wand"=>[{"wood"=>"Holly", "core"=>"Phoenixfeather", "length"=>11}, {"wood"=>"Holly", "core"=>"Phoenixfeather", "length"=>11}],
    # "occupation"=>["student", "Auror", nil],
    # "patronus"=>"Stag"},
    # {"name"=>"LunaLovegood", "age"=>[18, 17], "house"=>["Ravenclaw", "Ravenclaw"], "wand"=>{"wood"=>"Unknown", "core"=>"Unknown", "length"=>"Unknown"}, "occupation"=>["student", "Magizoologist"]},
    # {"name"=>"NevilleLongbottom", "age"=>18, "house"=>"Gryffindor", "occupation"=>"ProfessorofHerbology"},
    # {"name"=>"VincentCrabbe", "age"=>[18, 18], "city"=>"England", "country"=>"UK", "occupation"=>nil, "house"=>"Slytherin"},
    # {"name"=>"GregoryGoyle", "age"=>18, "city"=>"England", "country"=>"UK", "occupation"=>nil},
    # {"name"=>"DracoMalfoy", "age"=>[18, 18], "house"=>["Slytherin", "Slytherin"], "wand"=>{"wood"=>"Hawthorn", "core"=>"Unicornhair", "length"=>10}, "patronus"=>nil},
    # {"name"=>"TomRiddle", "alias"=>"LordVoldemort"},
    # {"name"=>"BellatrixLestrange", "alias"=>"Bella"},
    # {"name"=>"GinnyWeasley", "age"=>nil, "house"=>"Gryffindor", "wand"=>{"wood"=>"Yew", "core"=>"Phoenixfeather", "length"=>9}, "patronus"=>"Horse"}]
    def merge_all_characters()
        # Group and merge by "name" key
        merged_data = @all_characters.group_by { |h| h["name"] }.map do |name, group|
            # Start with the name, then merge the rest
            merged = group.reduce { |a, b|
              a.merge(b) do |key, a_value, b_value|
                key == "name" ? a_value : [a_value, b_value].flatten
              end
            }
        end
        @all_characters = merged_data
        remove_duplicate()
        return @all_characters
    end

    def remove_duplicate()
        for c in @all_characters
            c["age"] = [] if c["age"].nil?
            c["age"] = [c["age"]] if c["age"].nil? && c["age"].instance_of?(Integer)
            
            c["house"] = c["house"].uniq if !c["house"].nil? && c["house"].instance_of?(Array)
            c["house"] = [c["house"]] if c["house"].instance_of?(String)
            c["house"].delete("") unless c["house"].nil?

            c["wand"] = c["wand"].uniq if !c["wand"].nil? && c["wand"].instance_of?(Array)
            c["wand"] = [] if !c["wand"].nil?

            c["occupation"] = c["occupation"].uniq if !c["occupation"].nil? && c["occupation"].instance_of?(Array)
            c["occupation"] = [c["occupation"]] if !c["occupation"].nil? && c["occupation"].instance_of?(String)
            c["occupation"] = [] if c["occupation"].nil?
            c["occupation"].delete(nil)

            c["patronus"] = "" if c["patronus"].nil?
        end
        return @all_characters
    end

    def build_characters()

        for i in 0...@data.length do
            verify = true

            for n in @characters
                if n[0] == @data[i]["name"]
                    # ages
                    if n[2].blank?
                        n[2] = [@data[i]["age"]]
                    else
                        n[2] << @data[i]["age"]
                    end

                    verify = false
                    break
                end
            end
            @characters << [@data[i]["name"], @data[i]["house"], @data[i]["age"].nil? ? [] : [@data[i]["age"]], [], [], "", "", "", ""] if verify
            
            for j in 0...@data[i]["friends"].length
                verify = true
                for n in @characters

                    # friends name, house and age
                    if n[0] == @data[i]["friends"][j]["name"]
                        n[1] = @data[i]["friends"][j]["house"] if n[1].blank? && !@data[i]["friends"][j]["house"].blank?
                        if n[2].blank?
                            n[2] = [@data[i]["friends"][j]["age"]]
                        else
                            n[2] << @data[i]["friends"][j]["age"]
                        end
                    
                        verify = false
                    end
                end
                @characters << [@data[i]["friends"][j]["name"], @data[i]["friends"][j]["house"], [@data[i]["friends"][j]["age"]], [], [], "", "", "", ""] if verify
            end
            for j in 0...@data[i]["enemies"].length
                verify = true
                
                for n in @characters

                    # enemies name, house and age or (sometime only name)
                    if @data[i]["enemies"][j].instance_of?(String)
                        if n[0] == @data[i]["enemies"][j]
                            verify = false
                            break
                        end
                    elsif n[0] == @data[i]["enemies"][j]["name"]
                        n[1] = @data[i]["enemies"][j]["house"] if n[1].blank? && !@data[i]["enemies"][j]["house"].blank?
                        if n[2].blank?
                            n[2] = [@data[i]["enemies"][j]["age"]]
                        else
                            n[2] << @data[i]["enemies"][j]["age"]
                        end
    
                        verify = false
                    end
                end
                if @data[i]["enemies"][j].instance_of?(String)
                    @characters << [@data[i]["enemies"][j], @data[i]["enemies"][j]["house"], [], [], [], "", "", "", ""] if verify && !@data[i]["enemies"][j].blank?
                else
                    @characters << [@data[i]["enemies"][j]["name"], @data[i]["enemies"][j]["house"], @data[i]["enemies"][j]["age"].nil? ? [] : [@data[i]["enemies"][j]["age"]], [], [], "", "", "", ""] if verify
                end
            end
        end
        add_other_properties()
        return @characters
    end

    def add_other_properties()
        for i in 0...@data.length do
            verify = true
            verification_wand = true

            for n in @characters
                if n[0] == @data[i]["name"]
                    # wands
                    n[4] = [] if n[4].blank?
                    for w in n[4]
                        verification_wand = false if w == @data[i]["wand"]
                    end
                    # remove duplicate, nil, "" and "Unknown"
                    n[4] << @data[i]["wand"] if !@data[i]["wand"].nil? && 
                                                (@data[i]["wand"].key?("wood") && @data[i]["wand"].key?("core") && @data[i]["wand"].key?("length")) && 
                                                (!@data[i]["wand"]["wood"].blank? || !@data[i]["wand"]["core"].blank? || !@data[i]["wand"]["length"].blank?) && 
                                                (!@data[i]["wand"]["wood"] != "Unknown" && !@data[i]["wand"]["core"] != "Unknown" && !@data[i]["wand"]["length"] != "Unknown") && 
                                                verification_wand
                    verification_wand = true
                    # patronus
                    n[7] = @data[i]["patronus"] unless @data[i]["patronus"].nil?
                end
            end

            for j in 0...@data[i]["friends"].length
                for n in @characters
                    occupation = []
                    
                    if n[0] == @data[i]["friends"][j]["name"]
                        for o in n[3]
                            if @data[i]["friends"][j].key?("occupation")
                                verify = false if o == @data[i]["friends"][j]["occupation"]
                            end
                        end      
                        n[3] << @data[i]["friends"][j]["occupation"] if @data[i]["friends"][j].key?("occupation") && !@data[i]["friends"][j]["occupation"].blank? && verify
                        verify = true

                        # wands
                        n[4] = [] if n[4].blank?
                        for w in n[4]
                            verification_wand = false if w == @data[i]["friends"][j]["wand"]
                        end
                        # remove duplicate, nil, "" and "Unknown"
                        n[4] << @data[i]["friends"][j]["wand"] if !@data[i]["friends"][j]["wand"].nil? && 
                                                                    (@data[i]["friends"][j]["wand"].key?("wood") && @data[i]["friends"][j]["wand"].key?("core") && @data[i]["friends"][j]["wand"].key?("length")) && 
                                                                    (!@data[i]["friends"][j]["wand"]["wood"].blank? || !@data[i]["friends"][j]["wand"]["core"].blank? || !@data[i]["friends"][j]["wand"]["length"].blank?) && 
                                                                    (!@data[i]["friends"][j]["wand"]["wood"] != "Unknown" && !@data[i]["friends"][j]["wand"]["core"] && "Unknown" && !@data[i]["friends"][j]["wand"]["length"] != "Unknown") && 
                                                                    verification_wand
                        verification_wand = true

                        # cities
                        n[5] = @data[i]["friends"][j]["city"] if @data[i]["friends"][j].key?("city")
                        # countries
                        n[6] = @data[i]["friends"][j]["country"] if @data[i]["friends"][j].key?("country")
                    end
                end
            end
            for j in 0...@data[i]["enemies"].length
                for n in @characters
                    occupation = []

                    if n[0] == @data[i]["enemies"][j]["name"]  
                        for o in n[3]
                            if @data[i]["enemies"][j].key?("occupation")
                                verify = false if o == @data[i]["enemies"][j]["occupation"]
                            end
                        end
                        n[3] << @data[i]["enemies"][j]["occupation"] if @data[i]["enemies"][j].key?("occupation") && !@data[i]["enemies"][j]["occupation"].blank? && verify
                        verify = true

                        # wands
                        n[4] = [] if n[4].blank?
                        for w in n[4]
                            verification_wand = false if w == @data[i]["enemies"][j]["wand"]
                        end
                        # remove duplicate, nil, "" and "Unknown"
                        n[4] << @data[i]["enemies"][j]["wand"] if !@data[i]["enemies"][j]["wand"].nil? && 
                                                                    (@data[i]["enemies"][j]["wand"].key?("wood") && @data[i]["enemies"][j]["wand"].key?("core") && @data[i]["enemies"][j]["wand"].key?("length")) && 
                                                                    (!@data[i]["enemies"][j]["wand"]["wood"].blank? || !@data[i]["enemies"][j]["wand"]["core"].blank? || !@data[i]["enemies"][j]["wand"]["length"].blank?) && 
                                                                    (!@data[i]["enemies"][j]["wand"]["wood"] != "Unknown" && !@data[i]["enemies"][j]["wand"]["core"] != "Unknown" && !@data[i]["enemies"][j]["wand"]["length"] != "Unknown") && 
                                                                    verification_wand
                        verification_wand = true
                        # alias
                        n[8] = @data[i]["enemies"][j]["alias"] if @data[i]["enemies"][j].key?("alias")
                    end
                end
            end
        end
    end

    def build_houses()
        verif = true

        for n in 0...@characters.length do
            verif = true
            next if @characters[n][1].blank?
            for h in @houses
                if h == @characters[n][1]
                    verif = false
                    break
                end
            end
            @houses << @characters[n][1] if verif
        end
        return @houses
    end

    def build_max_ages_by_houses()
        for h in @houses
            @houses_with_max_ages[h] = []
            for n in @characters
                if h == n.fetch(1)
                    @houses_with_max_ages[h] << n.fetch(2).max() unless n.fetch(2).blank?
                end
            end
        end
        return @houses_with_max_ages
    end

    def build_min_ages_by_houses()
        for h in @houses
            @houses_with_min_ages[h] = []
            for n in @characters
                if h == n.fetch(1)
                    @houses_with_min_ages[h] << n.fetch(2).min() unless n.fetch(2).blank?
                end
            end
        end
        return @houses_with_min_ages
    end

    # def build_average_ages_by_houses(houses_with_ages)
    def build_average_ages_by_houses(data, average, max=true)
        # average = {}
        data.each do |key, value|
            average[key] = 0 unless average[key]
            for v in value
                average[key] = average[key] + v
            end
            average[key] = average[key].to_f / value.length
        end
        return average
    end
end