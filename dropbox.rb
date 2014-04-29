require 'dropbox_sdk'

class Dropbox
	# Get your app key and secret from the Dropbox developer website
	@access_token = '0ZS_nD1tgxkAAAAAAAAA4N4ahs7B9sTMn986OUcbPRfZl4ANlQ30AIzdKQ4u6WG2'
	def initialize
		@client = DropboxClient.new(@access_token)
	end
	def upload(name, file)
		@client.put_file(name, file, true)
	end

	def download(name)
		@client.get_file(name)
	end

	def get_url(name)
		@client.media(name)
	end

	# def clear
	# 	begin
	# 		@client.file_delete(name)
	# 	rescue
	# 	end
	# end
end