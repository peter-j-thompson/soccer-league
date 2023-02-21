require 'rails_helper'

RSpec.describe Soccer, type: :model do
  let(:input) { "FC Barcelone 1, Arsenal 0\nReal Madrid 2, FC Barcelone 2\nArsenal 2, Real Madrid 1\n" }
  let(:league) { SoccerLeague.new(input) }

  describe '#get_team_names' do
    it 'should parse the team names from the input data' do
      expect(league.instance_variable_get(:@teams)).to contain_exactly('FC Barcelone', 'Arsenal', 'Real Madrid')
    end
  end

  describe '#get_match_days' do
    it 'should parse the match day results and calculate the scores' do
      expect(league.instance_variable_get(:@parsed_heads_up_results)).to eq([
        { day: 1, team_scores: [{ team_name: 'FC Barcelone', score: 3 }, { team_name: 'Arsenal', score: 0 }] },
        { day: 1, team_scores: [{ team_name: 'Real Madrid', score: 0 }, { team_name: 'FC Barcelone', score: 1 }] },
        { day: 1, team_scores: [{ team_name: 'Arsenal', score: 3 }, { team_name: 'Real Madrid', score: 0 }] },
      ])
    end
  end

  describe '#display_final_results' do
    it 'should output the final results to the console' do
      expect { league.display_final_results }.to output("Matchday 1\nFC Barcelone, 4 pts\nArsenal, 3 pts\nReal Madrid, 0 pts\n\n").to_stdout
    end
  end
end