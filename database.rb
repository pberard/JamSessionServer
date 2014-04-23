require 'sequel'

DB = Sequel.connect(ENV['HEROKU_POSTGRESQL_CHARCOAL_URL'] || 'sqlite://jamsessiondb.db')

DB.create_table? :users do
	primary_key :id 
	String :name 
	String :email, :unique => true
	String :password
end

DB.create_table? :songs do
	primary_key :id
	String :dropbox_filepath
	int :length
	String :description
	foreign_key :user_id, :users
	foreign_key :jam_id, :jams
end

DB.create_table? :jams do
	primary_key :id
	int :ttl
	foreign_key :user_id, :users
end

DB.create_table? :friends do
	primary_key :id
	foreign_key :user_id, :users
	foreign_key :friend_id, :users
	boolean :pending
	boolean :confirmed
end

DB.create_table? :collaborations do
	primary_key :id
	foreign_key :jam_id, :jams
	foreign_key :user_id, :users
end

require_relative './orms/User.rb'
require_relative './orms/Song.rb'
require_relative './orms/Jam.rb'
require_relative './orms/Friend.rb'
require_relative './orms/Collaboration.rb'