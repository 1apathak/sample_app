class PhotoController < ApplicationController
require 'flickraw'

def index
@displayVid=1
#flickr = Flickr.new(File.join(RAILS_ROOT, 'config', 'flickr.yml'))

FlickRaw.api_key="803f036ec6d01e3ac0c1ca99bbc55260"
FlickRaw.shared_secret="93e43a71a0731237"


index = params[:index].to_i
username = params[:username]

if (username.nil?)
	username = "anupampathak"
end

@id = flickr.people.findByUsername(:username => username).id

list = flickr.photos.search(:user_id => @id)

if (index>(list.count-1))
	index=0
end

id     = list[index].id
secret = list[index].secret
info = flickr.photos.getInfo :photo_id => id, :secret => secret
@photoUrl = FlickRaw.url_b(info)

end

end