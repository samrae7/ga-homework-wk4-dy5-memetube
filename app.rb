require 'sinatra'
require 'sinatra/reloader' if development?
require 'pry'
require 'pg'

before do
  @db = PG.connect(dbname:'memetube', host:'localhost')
end

after do 
  @db.close
end


get '/' do

  redirect to '/videos'

end

# INDEX
get'/videos' do

  sql = 'select * from videos'

  @videos = @db.exec(sql)

  # binding.pry

  erb :index
end

 # NEW
get '/videos/new' do
  erb :new 
end

 # CREATE
post '/videos' do

  sql="insert into videos (title, description, genre, url) values ( '#{params[:title]}', '#{params[:description]}','#{params[:genre]}','#{params[:url]}') returning *"

 @videos = @db.exec(sql)

 id = @videos.map{ |video| video['id']}[0]

redirect to "/videos/#{id}"

end

 # SHOW
get '/videos/:id' do

  @id = params[:id]

  sql = "select url from videos where id = #{@id}"

  url_object = @db.exec(sql)

  url_array = url_object.map { |url| url}

  url_hash = url_array[0]

  @url = url_hash['url']

  erb :video


end

 # EDIT
 # UPDATE
 # DELETE

post '/videos/:id/delete' do


  # question - i thought this would work with a get and without the need for a form. why doesn't it? ie by going to the url you could delete the item.

  sql = "delete from videos where id =#{params[:id]}"

  @db.exec(sql)

  redirect to '/videos'

end