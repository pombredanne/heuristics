$LOAD_PATH << File.expand_path(File.dirname(__FILE__)) + "/../../vendor/"
require 'rubygems'
require 'utils/timer'
require 'utils/measure'
require 'connection/client'
require 'dating_game/extensions'
require 'dating_game/dispatch'
require 'dating_game/person'
require 'dating_game/matchmaker'
require 'dating_game/candidate'

module DatingGame
  DELIM = ":"
end