require 'sinatra'
require 'sequel'
require 'sinatra/json'
require 'json'

#enable sessions in the server (this is not on by default)
enable :sessions, :logging

#configure the app
configure do
	require_relative 'database.rb'
end

get '/' do
	logger.info "@@@@@@@@@@@@@@@@STARTING HELLO WORLD@@@@@@@@@"
	"Hello World!"

end

get '/hello' do
	"Hello " + params[:name] + " " + params[:last] + "!"
end

get '/jsonTest' do 
	json :foo => 'bar'
end
#################################################################################
#################################   Users   #####################################
#################################################################################
get '/login' do
	jsonHash = {}
	@error = ""
	user = User[:email => params[:email]]

	if (params[:email] == "") or user.nil? or (user[:password] != params[:password])
		@error = "Incorrect Username and/or Password"
		jsonHash["success"] = false
		jsonHash["error"] = "Incorrect Username and/or Password"
		jsonHash["userID"] = 0

	else
		jsonHash["success"] = true
		jsonHash["userID"] = user.id
		jsonHash["error"] = ""

	end
	
	#@error
	jsonHash.to_json
end

get '/createAccount' do
	#check uniqueness of username
	@error = ""
	user = User[:email => params[:email]]

	if (user.nil?)
		#doesnt exist, continue
		if(params[:password1] == params[:password2])
			if(params[:name] != "")
					user = User.create(:name => params[:name],
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
		jsonHash["success"] = false
		jsonHash["error"] = @error
		jsonHash["userID"] = 0
	else
		#return true
		jsonHash["success"] = true
		jsonHash["userID"] = user.id
		jsonHash["error"] = @error
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

get '/allUsers' do 
	jsonHash = {}
	allUsers = User.all
	allUsers.each{ |user|
		userHash = {:id => user.id,
					:email => user.email,
					:name => user.name}
		#convert user hash to json??!?!?!?!
		jsonHash[user.name] = userHash
	}
	#json :allUsers => allUsers.to_json
	#allUsers.to_json
	jsonHash.to_json
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
	jsonHash = {}
	#params = userID, ttl, song, filename
	#Create Jam
	jam = Jam.create(:user_id => params[:userID],
	  				 :ttl => params[:ttl])
	#Create Collaboration
	collab = Collaboration.create(:user_id => params[:userID],
								  :jam_id => jam.id)
	#Upload song to Dropbox
	file =  params[:song][:tempfile]
	filename = "/" + params[:filename]
	response = @@dropbox_client.upload(filename, file)
	#Create song
    song = Song.create(:dropbox_filepath => filename,
    				  :user_id => params[:userID],
    				  :jam_id => jam.id)
	jsonHash["success"] = true
	jsonHash["jamID"] = jam.id
	jsonHash.to_json
end

get '/updateJam' do

end


get '/addCollaborator' do

end

get '/addCollaboration' do

end

get '/getUpdates' do

end