require 'open-uri'
require 'json'

class WordController < ApplicationController

  def game

    # def generate_grid(grid_size)
      # TODO: generate random grid of letters
      @grid = (0..8).to_a
      @grid = @grid.map { ('A'..'Z').to_a[rand(26)] }
      @start_time = Time.now
    # end
  end

  def score

    @grid = params[:grid]
    @attempt = params[:attempt]
    @start_time = Time.parse(params[:start_time])
    @end_time = Time.now

    @word = dictionary(@attempt)
    @result = {}

    @result[:time] = @end_time - @start_time
    @word["found"] && verify(@attempt, @grid) ? @result[:score] = (@attempt.length) / (@result[:time]) : @result[:score] = 0

    @result[:message] = "Well done!"
    @result[:message] = "not an english word" if @word["found"] == false
    @result[:message] = "not in the grid" if verify(@attempt, @grid) == false

    return @result
  end
end


def dictionary(attempt)
  url = "https://wagon-dictionary.herokuapp.com/#{attempt}"
  serialized_word = open(url).read
  JSON.parse(serialized_word)
end

def verify(attempt, grid)
  attempt_array = attempt.upcase.split("")
  grid_array = grid.upcase.split("")
  # p grid
  # p attempt_array & grid
  return attempt_array == attempt_array & grid_array
end
