require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'
require 'haml'
require 'sqlite3'

configure do
	db = get_db()
	db.execute 'CREATE TABLE IF NOT EXISTS 
		"Users"
		(
			"id" INTEGER PRIMARY KEY AUTOINCREMENT,
			"name" TEXT,
			"phone" TEXT,
			"datestamp" TEXT,
			"barber" TEXT,
			"color" TEXT
		)'

end

get '/' do
	erb "Hello! <a href=\"https://github.com/bootstrap-ruby/sinatra-bootstrap\">Original</a> pattern has been modified for <a href=\"http://rubyschool.us/\">Ruby School</a>"
end

get '/about' do
	erb :about
end

get '/contacts' do
	erb :contacts
end

get '/visit' do
	erb :visit
end

post '/visit' do

	@user_name = params[:user_name]
	@phone = params[:phone]
	@date = params[:date]
	@barber = params[:barber]
	@colorpicker = params[:colorpicker]

	hh = {
		:user_name => 'Enter the name',
		:phone => 'Enter the phone',
		:date => 'Enter the date',
		:barber => 'Enter the master',
		:colorpicker => 'Enter the color'
	}

	# hh.each do |key, value|
	# 	if params[key] == ''
	# 		@error = value
	# 		return erb :visit
	# 	end
	# end
	@error = hh.select {|key,_| params[key] == ''}.values.join(", ")

	if @error != ''
		return erb :visit
	end

	# f = File.open('./public/users.txt', 'a')
	# f.write("User: #{@user_name}, Phone: #{@phone} Date: #{@date} Master: #{@barber} Color: #{@colorpicker}\n")
	# f.close
	
	db = get_db()
	db.execute 'INSERT INTO 
	Users
	(
		name, 
		phone, 
		datestamp, 
		barber, 
		color
	) 
	values( ?, ?, ?, ?, ?)', [@user_name, @phone, @date, @barber, @colorpicker]
	
	erb "User: #{@user_name}, Phone: #{@phone} Date: #{@date} Master: #{@barber} Color: #{@colorpicker}"
end

def get_db
	return SQLite3::Database.new 'BarberShop.db'
end


post '/contacts' do

	@email = params[:email_c]
	@message = params[:message_c]

	hh = {
		:email_c => 'Enter the email',
		:message_c => 'Enter the message'
	}

	@error = hh.select {|key,_| params[key] == ''}.values.join(', ')

	if @error != ''
		return erb :contacts
	end

	# f = File.open('./public/contacts.txt', 'a')
	# f.write("Email: #{@email}, Message: #{@message}\n")
	# f.close

	erb "Your contact add!"
end


