# frozen_string_literal: true

require_relative './game'

score_string = ARGV[0]
game = Game.new(score_string)
puts game.score
