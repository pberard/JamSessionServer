require 'sinatra'
require 'sequel'
require 'sinatra/json'
require 'json'

#enable sessions in the server (this is not on by default)
enable :sessions

#configure the app
configure do
	require_relative 'database.rb'
end

get '/' do
	"Hello World!"
end

get '/hello' do
	"Hello " + params[:name] + " " + params[:last] + "!"
end
#################################################################################
#################################   Users   #####################################
#################################################################################
get '/login' do
	@error = ""
	user = User[:email => params[:email], :password => params[:password]]

	if (user.nil?)
		#user doesn't exist or params were incorrect
		@error = "Username or password was incorrect."
	else
		@error = "true"
	end
end

get '/createAccount' do
	#check uniqueness of username
	@error = ""
	user = User[:email => params[:email]]

	if (user.nil?)
		#doesnt exist, continue
		if(params[:password1] == params[:password2])
			if(params[:name] != "")
					User.create(:name => params[:name],
									:email => params[:email],
									:password => params[:password1])
			else 
				@error = "Please enter a name"
			end
		else
			@error = "Passwords don't match"
		end
	else
		@error = "Email already registered for account.  Please enter different email."
	end
	if(@error != "")
		#failure, return the error
		@error
	else
		#return true
		@error = "true"
		@error
	end
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