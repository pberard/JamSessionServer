require 'dropbox_sdk'

# Get your app key and secret from the Dropbox developer website
access_token = '0ZS_nD1tgxkAAAAAAAAA4N4ahs7B9sTMn986OUcbPRfZl4ANlQ30AIzdKQ4u6WG2'

client = DropboxClient.new(access_token)
puts "linked account:", client.account_info().inspect