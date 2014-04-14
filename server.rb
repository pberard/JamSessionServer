require 'sinatra'
require 'sequel'
require 'sinatra/json'

#enable sessions in the server (this is not on by default)
enable :sessions

#configure the app
configure do
	require_relative 'database.rb'
end

get '/' do
	"Hello World!"
end
#################################################################################
#################################   Users   #####################################
#################################################################################
get '/login' do

end

get '/createAccount' do
	json = JSON.parse params
	
	puts json["name"].to_s

	#User.create(:name => json["name"],
	#			:email => json["email"],
	#			:password => json["password"])
end

get '/createFriendRequest' do

end

get '/respondToFriendRequest' do

end

get '/getFriends' do

end

get '/getFriendRequests' do

end

#################################################################################
#################################   Songs   #####################################
#################################################################################

get '/getSong' do
	#Songs.where(id=blah, etc etc etc)
	#a_jsoniffied_hash = {'id' => 1, 'mp3' => mp3serialized, etc}.to_json
end

get '/createSong' do
	JSON.parse params
	#get song data
	#insert song
end

get '/deleteSong' do

end

#################################################################################
#################################    Jams    ####################################
#################################################################################

get '/getJam' do

end

get '/createJam' do

end

get '/addCollaborator' do

end

get '/addCollaboration' do

end

get '/getUpdates' do

end