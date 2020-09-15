require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    @letters = generate_grid(9)
  end

  def score
    end_time = Time.now
    start_time = params[:start_time].to_time
    # como eu pego o grid da pagina inicial e como eu pego os start_time e end_time
    # rodando ruby na pagina principal talvez
    @word = params[:word]
    @answer = run_game(@word, params[:grid].split(""), start_time, end_time)
  end

  def generate_grid(grid_size)
    # TODO: generate random grid of letters
    answer = []
    alphabet = ('A'..'Z').to_a
    grid_size.times do
      answer << alphabet.sample
    end
    answer
  end

  def run_game(attempt, grid, start_time, end_time)
    # TODO: runs the game and return detailed hash of result (with `:score`, `:message` and `:time` keys)
    answer = { score: 0, message: "not in the grid", time: end_time - start_time }
    grid_ok = in_the_grid?(attempt, grid)
    return answer unless grid_ok

    if english_word?(attempt)
      answer[:message] = "well done"
      answer[:score] = (attempt.length / answer[:time]).round(4)
    else
      answer[:message] = "not an english word"
    end
    answer
  end

  def in_the_grid?(attempt, grid)
    grid_ok = true
    attempt.upcase.each_char do |c|
      if grid.include?(c)
        grid.delete_at(grid.index(c))
      else
        grid_ok = false
      end
    end
    grid_ok
  end

  def english_word?(attempt)
    url = "https://wagon-dictionary.herokuapp.com/#{attempt}"
    api_serialized = open(url).read
    api = JSON.parse(api_serialized)
    api["found"]
  end
end
