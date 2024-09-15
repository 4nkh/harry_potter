require 'net/http'
require 'uri'
require 'json'
require 'harry_potter/os_detector'

class HpData
    def send_post_request(body)
        # uri = URI('http://heuristic.site/hp/fight_request')
        uri = URI('http://localhost:8000/hp/fight_request')
        http = Net::HTTP.new(uri.host, uri.port)
        req = Net::HTTP::Post.new(uri)
        req.body = body
        req.content_type = 'application/json'
        res =  http.request(req)

        response = JSON.parse(res.body)
        open_webpage(response["link"]) if response["response"] == "success"
        
        # Only 20 requests by minutes are available on this API
        puts response["message"] if response["response"] == "error"
    end

protected

    def open_webpage(url)
        case OsDetector.execute
            when /macosx/
                system("open", url)
            when /linux/
                system("xdg-open", url)
            when /windows/
                system("start", url)
            else
                puts "sorry we can't open your browser"
            end
    end

    def get_data_from_uri()
        uri = URI('https://coderbyte.com/api/challenges/json/wizard-list')
        response = Net::HTTP.get(uri)

        data = JSON.parse(response)
        return data
    end

    def get_data()
        return [
            {"name"=>"HarryPotter",
                "age"=>18,
                "house"=>"",
                "wand"=>{"wood"=>"Holly", "core"=>"Phoenixfeather", "length"=>11},
                "friends"=>
                [{"name"=>"HermioneGranger",
                "age"=>18,
                "house"=>"Gryffindor",
                "wand"=>{"wood"=>"Vine", "core"=>"Dragonheartstring", "length"=>10.75},
                "occupation"=>nil},
                {"name"=>"RonWeasley",
                "age"=>18,
                "house"=>"Gryffindor",
                "wand"=>{"wood"=>"Willow", "core"=>"Unicornhair", "length"=>14},
                "occupation"=>"student"},
                {"name"=>"HermioneGranger",
                "age"=>18,
                "house"=>"Gryffindor",
                "wand"=>{"wood"=>"Vine", "core"=>"Dragonheartstring", "length"=>10.75},
                "occupation"=>nil}],
                "enemies"=>["LordVoldemort", "DracoMalfoy"],
                "patronus"=>"Stag"},

            {"name"=>"HermioneGranger",
                "age"=>18,
                "house"=>"Gryffindor",
                "wand"=>{"wood"=>"", "core"=>"", "length"=>nil},
                "friends"=>
                [{"name"=>"HarryPotter",
                "age"=>18,
                "house"=>"Gryffindor",
                "wand"=>{"wood"=>"Holly", "core"=>"Phoenixfeather", "length"=>11},
                "occupation"=>"student"},
                {"name"=>"RonWeasley",
                "age"=>18,
                "house"=>"Gryffindor",
                "wand"=>{"wood"=>"Willow", "core"=>"Unicornhair", "length"=>14},
                "occupation"=>"student"},
                {"name"=>"LunaLovegood",
                "age"=>18,
                "house"=>"Ravenclaw",
                "wand"=>{"wood"=>"Unknown", "core"=>"Unknown", "length"=>"Unknown"},
                "occupation"=>"student"}],
                "enemies"=>["", ""],
                "patronus"=>"Otter"},

            {"name"=>"RonWeasley",
                "age"=>18,
                "house"=>"Gryffindor",
                "wand"=>{"wood"=>"Willow", "core"=>"Unicornhair", "length"=>14},
                "friends"=>
                [{"name"=>"HarryPotter", "age"=>18, "house"=>""},
                {"name"=>"HermioneGranger", "age"=>18, "house"=>"Gryffindor"},
                {"name"=>"HermioneGranger", "age"=>18, "house"=>"Gryffindor"}],
                "enemies"=>[{"name"=>"DracoMalfoy", "age"=>18, "house"=>"Slytherin"}, {"name"=>"VincentCrabbe", "age"=>18, "house"=>"Slytherin"}],
                "patronus"=>"JackRussellTerrier"},

            {"name"=>"GinnyWeasley",
                "age"=>nil,
                "house"=>"Gryffindor",
                "wand"=>{"wood"=>"Yew", "core"=>"Phoenixfeather", "length"=>9},
                "friends"=>
                [{"name"=>"HarryPotter", "age"=>18, "house"=>"Gryffindor", "occupation"=>"Auror"},
                {"name"=>"LunaLovegood", "age"=>17, "house"=>"Ravenclaw", "occupation"=>"Magizoologist"},
                {"name"=>"NevilleLongbottom", "age"=>18, "house"=>"Gryffindor", "occupation"=>"ProfessorofHerbology"}],
                "enemies"=>[{"name"=>"TomRiddle", "alias"=>"LordVoldemort"}, {"name"=>"BellatrixLestrange", "alias"=>"Bella"}],
                "patronus"=>"Horse"},

            {"name"=>"DracoMalfoy",
                "age"=>18,
                "house"=>"Slytherin",
                "wand"=>{"wood"=>"Hawthorn", "core"=>"Unicornhair", "length"=>10},
                "friends"=>
                [{"name"=>"VincentCrabbe", "age"=>18, "city"=>"England", "country"=>"UK", "occupation"=>nil},
                {"name"=>"GregoryGoyle", "age"=>18, "city"=>"England", "country"=>"UK", "occupation"=>nil}],
                "enemies"=>
                [{"name"=>"HarryPotter", "age"=>17, "house"=>"Gryffindor", "occupation"=>nil},
                {"name"=>"HermioneGranger", "age"=>17, "house"=>"Gryffindor", "occupation"=>nil},
                {"name"=>"RonWeasley", "age"=>17, "house"=>"Gryffindor", "occupation"=>nil}],
                "patronus"=>nil}
        ]
    end

end