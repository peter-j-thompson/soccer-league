class SoccerLeague
  def initialize(file_path)
    @heads_up_results = File.readlines(file_path).map(&:strip)
    @teams = []
    @parsed_heads_up_results = []
    @final_results = []

    get_team_names

    @games_per_match_day = @teams.length / 2

    get_match_days
    display_final_results
  end

  def get_team_names
    @heads_up_results.each do |teams|
      team_one, team_two = teams.split(", ")
  
      team_one_array = team_one.split(" ")
      team_two_array = team_two.split(" ")
  
      team_one_name = team_one_array[0..-2].join(" ")
      team_two_name = team_two_array[0..-2].join(" ")
  
      @teams << team_one_name unless @teams.include?(team_one_name)
      @teams << team_two_name unless @teams.include?(team_two_name)
    end
  end

  def get_match_days
    match_day = 1

    @heads_up_results.each_slice(@games_per_match_day) do |match_day_results|
      next if match_day_results.length != @games_per_match_day
      
      match_day_results.each do |teams|
        team_one, team_two = teams.split(", ")
  
        team_one_array = team_one.split(" ")
        team_two_array = team_two.split(" ")
    
        team_one_name = team_one_array[0..-2].join(" ")
        team_two_name = team_two_array[0..-2].join(" ")
    
        if team_one_array[-1].to_i > team_two_array[-1].to_i
          team_one_score = 3
          team_two_score = 0
        elsif team_one_array[-1].to_i < team_two_array[-1].to_i
          team_two_score = 3
          team_one_score = 0
        elsif team_one_array[-1].to_i == team_two_array[-1].to_i
          team_one_score = 1
          team_two_score = 1
        end
        @parsed_heads_up_results << { day: match_day, team_scores: [{ team_name: team_one_name, score: team_one_score }, { team_name: team_two_name, score: team_two_score }]}
      end
      
      match_day += 1
    end
  end

  def display_final_results
    team_points = {}
    @parsed_heads_up_results.each_slice(@games_per_match_day) do |match_day|
      team_scores = match_day.flat_map { |game| game[:team_scores] }
      sorted_teams = team_scores.sort_by{ |team| [-team[:score], -team[:team_name]] }
      top_three = sorted_teams.first(3)

      team_scores.each do |team_score|
        team_name = team_score[:team_name]
        score = team_score[:score]
        if team_points[team_name]
          team_points[team_name] += score
        else
          team_points[team_name] = score
        end
      end

      top_three = team_points.sort_by { |team, score| [-score, team] }.first(3).map { |team, score| "#{team}, #{score} pts" }
      puts "Matchday #{match_day.first[:day]}"
      puts top_three
      puts "\n"
    end
  end

  SoccerLeague.new(ARGV[0])
end
