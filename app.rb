require 'sinatra'
require 'slim'
require 'sqlite3'
require 'bcrypt'

get('/') do
    slim(:index)
end

post('/login') do

    db = SQLite3::Database.new("db/slut-proj.db")
    db.results_as_hash = true

    username = params["username"]
    password = params["password"]

    pwdhash = db.execute("SELECT password_digest FROM users WHERE username = ?;", username)
    session[:username] = username
    session[:user_id] = db.execute("SELECT id FROM users WHERE username = ?;", username).first["id"]


    if BCrypt::Password.new(pwdhash[0]["Password_digest"]) == password
        slim(:log_in)
    else
        redirect("/Invalid")
    end
    
end

post('/register')do
    db = SQLite3::Database.new("db/slut-proj.db")
   
    pwdhash = BCrypt::Password.create(params['password'])

    db.execute("INSERT INTO users(username, Password_digest) VALUES(?, ?);", params['username'], pwdhash)

    redirect("/")
end

post('/create')do
    slim(:register)
end
