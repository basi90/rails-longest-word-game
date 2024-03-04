require "json"
require "open-uri"

class GamesController < ApplicationController
  def new
    @letters = ("A".."Z").to_a.sample(10)
  end

  def score
    @word = params[:word]
    @letters = params[:letters].split(",")

    if valid_word?(@word) && from_grid?(@word, @letters)
      @result = "Congratulations! #{@word} is a valid English word"
    elsif !valid_word?(@word)
      @result = "Sorry but #{@word} does not seem to be a valid English word..."
    elsif !from_grid?(@word, @letters)
      @result = "Sorry but #{@word} can't beb uilt out of #{@letters}"
    end
  end

  def valid_word?(word)
    url = "https://wagon-dictionary.herokuapp.com/#{word}"
    response = open(url).read
    json = JSON.parse(response)
    json["found"]
  end

  def from_grid?(word, letters)
    word.upcase.chars.all? { |char| word.count(char) <= letters.count(char) }
  end
end
