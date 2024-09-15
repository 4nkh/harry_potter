require "harry_potter/hp_data"

class Builder < HpData

protected

    def build_all_names()

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
        add_occupations_wands_cities_countries_patronus_alias()
        return @characters
    end

    def add_occupations_wands_cities_countries_patronus_alias()
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