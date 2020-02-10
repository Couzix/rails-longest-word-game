require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    @letters = Array.new(10) { ('A'..'Z').to_a.sample }
  end

  def score
    if params[:answer]
      if included?(params[:answer].upcase, params[:letters])
        if english_word?(params[:answer])
          @message = "Congratulations! #{params[:answer].capitalize} is a valid English word!"
        else
          @message = "Sorry but #{params[:answer].capitalize} does not seem to be a valid English word..."
        end
      else
        @message = "Sorry but #{params[:answer].capitalize} an't be built out of #{params[:letters]}"
      end
    end
  end

  private

  def included?(guess, grid)
    guess.chars.all? { |letter| guess.count(letter) <= grid.count(letter) }
  end

  def english_word?(word)
    response = open("https://wagon-dictionary.herokuapp.com/#{word}")
    json = JSON.parse(response.read)
    return json['found']
  end
end
