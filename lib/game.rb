require_relative "databaseinfo"
class Game < ActiveRecord::Base
  attr_accessible :metascore, :name, :price, :released
end
