require 'sinatra'
require 'sequel'
require 'sinatra/json'
require 'json'

#enable sessions in the server (this is not on by default)
enable :sessions, :logging
@@client

#configure the app
configure do
	require_relative 'database.rb'
	require_relative './dropbox.rb'
	@@client = DropboxAPI.new
end

get '/' do
	logger.info "@@STARTING HELLO WORLD LOL@@"
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
	jsonHash = {}
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
	jsonHash.to_json
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

get '/getSongsForJam' do
	logger.info "$$$$$$$$$$$$  GET SONGZ  $$$$$$$$$$$$$" + params[:jamID].to_s
	jsonHash = {}
	songs = Song.where(:jam_id => params[:jamID].to_i)
	songs.each{ |song|
		songHash = {:id => song[:id],
					:filename => song[:dropbox_filepath]}
	# 	user = User[:id => song[:user_id]]
	# 	#logger.info "User: " + user[:name]
	# 	response = @@client.download(song[:dropbox_filepath])
	# 	file = open("#{settings.root}/tmp" + song[:dropbox_filepath], 'w') {|f| f.puts response }
	# 	f = File.binread("#{settings.root}/tmp" + song[:dropbox_filepath])
	# 	#logger.info response.to_s
	# 	songHash = {:id => song[:id],
	# 				:user => user[:name],
	# 				:file_name => song[:dropbox_filepath],
	# 				:mp3 => f.bytes.to_a} #and as of this moment, I hate ruby
	 	jsonHash[song[:id]] = songHash
	}
	logger.info "Whats all this then?"
	jsonHash.to_json
end

get '/getSong' do 
	logger.info "~~~~ Getting song ~~~~"
	song = Song[:id => params[:songID].to_i]
	logger.info "Song " + song[:id].to_s + " retrieved"
	response = @@client.download(song[:dropbox_filepath])
	file = open("#{settings.root}/tmp" + song[:dropbox_filepath], 'w') {|f| f.puts response }	
	filename = "#{settings.root}/tmp" + song[:dropbox_filepath]
	logger.info "Filename: " + filename
	send_file filename, :type => 'audio/mpeg', :disposition => 'attachment', :stream => false
end


get '/deleteSong' do

end

#################################################################################
#################################    Jams    ####################################
#################################################################################

get '/getJam' do

end

post '/createJam' do
	jsonHash = {}
	#params = userID, ttl, song, filename
	#Create Jam
	jam = Jam.create(:user_id => params[:userID].to_i,
	  				 :ttl => params[:ttl].to_i)
	#Create Collaboration
	collab = Collaboration.create(:user_id => params[:userID].to_i,
								  :jam_id => jam.id)
	#Upload song to Dropbox
	logger.info("Song: " + params[:song].to_s)
	logger.info("Tempfile: " + params[:song][:tempfile].to_s)
	file =  params[:song][:tempfile]
	filename = "/" + params[:filename]
	
	response = @@client.upload(filename, file)
	#Create song
    song = Song.create(:dropbox_filepath => filename,
    				  :user_id => params[:userID].to_i,
    				  :jam_id => jam.id)

    #Create collaboration for other user
    otherCollab = collab = Collaboration.create(:user_id => params[:collaboratorID].to_i,
												:jam_id => jam.id)
	jsonHash["success"] = true
	jsonHash["jamID"] = jam.id
	jsonHash.to_json
end

post '/updateJam' do
	logger.info "&&&&& UPDATE JAM &&&&&"
	jsonHash = {}
	#params = userID, ttl, song, filename
	#Create Jam
	jam = Jam.where(:id => params[:jamID].to_i)
	#Create Collaboration
	collab = Collaboration.create(:user_id => params[:userID].to_i,
								  :jam_id => jam[:id])
	#Upload song to Dropbox
	logger.info("Song: " + params[:song].to_s)
	logger.info("Tempfile: " + params[:song][:tempfile].to_s)
	file =  params[:song][:tempfile]
	filename = "/" + params[:filename]
	
	response = @@client.upload(filename, file)
	#Create song
    song = Song.create(:dropbox_filepath => filename,
    				  :user_id => params[:userID].to_i,
    				  :jam_id => jam[:id])

    #Create collaboration for other user
    otherCollab = collab = Collaboration.create(:user_id => params[:collaboratorID].to_i,
												:jam_id => jam[:id])
	jsonHash["success"] = true
	jsonHash["jamID"] = jam[:id]
	jsonHash.to_json
end


get '/addCollaborator' do

end

get '/addCollaboration' do

end

get '/getUpdates' do
	
	#SELECT jam.id
	#FROM Jams
	#WHERE jam.id IN
	#(
		#These are all of the jams you are collaborating on
		#SELECT jam_id
		#FROM collaborations
		#WHERE user_id = params[:userID]
	#)
	#AND jam.id NOT IN
	#(
		#Filter out the jams you have already added to
		#SELECT jam_id
		#FROM Songs
		#WHERE user_id = params[:userID]
	#)
	#logger.info "Get Updates!"
	jsonHash = {}
	#logger.info "Params: " + params[:userID]
	#logger.info "SQL:::" + Jam.where(:id => Collaboration.select(:jam_id).where(:user_id => params[:userID].to_i)).exclude(:id => Song.select(:jam_id).where(:user_id => params[:userID].to_i)).sql
	jams = Jam.where(:id => Collaboration.select(:jam_id).where(:user_id => params[:userID].to_i)).exclude(:id => Song.select(:jam_id).where(:user_id => params[:userID].to_i))
	jams.each{ |jam|

		# logger.info "Jam: " + jam.to_s
		# logger.info "Jam Keys: " + jam.keys.to_s
		user = User[:id => params[:userID].to_i]
		#logger.info "Username: " + user[:name].to_s
		jamHash = {:id => jam[:id],
					:user_id => jam[:user_id],
					:ttl => jam[:ttl],
					:user_name => user[:name].to_s}
		jsonHash[jam[:id]] = jamHash
	}
	jsonHash.to_json
end