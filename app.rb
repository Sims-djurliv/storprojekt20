require 'sinatra'
require 'slim'
require 'sqlite3'
require 'bcrypt'

enable :sessions

def db
    SQLite3::Database.new("db/slut-proj.db")
end

get('/') do
    slim(:index)
end

post('/login') do
    user_array = []
    user_exists = false
    # db = SQLite3::Database.new("db/slut-proj.db")
    db.results_as_hash = true

    username = params["username"]
    password = params["password"]

    user_array = db.execute("SELECT username FROM users")

    if user_array != nil
        user_array.each do |item|
            if item[0] == username
                user_exists = true
            end
        end
    end
    
    if user_exists == true
        pwdhash = db.execute("SELECT password_digest FROM users WHERE username = ?;", username)
        session[:username] = username

        session[:user_id] = db.execute("SELECT id FROM users WHERE username = ?;", username).first[0]

        if BCrypt::Password.new(pwdhash[0][0]) == password
            redirect('/valid')
        else
            slim(:error)
        end
    else
        slim(:error)
    end
end

get('/valid')do
    
    # db = SQLite3::Database.new("db/slut-proj.db")
    db.results_as_hash = true
    result = db.execute("SELECT routes FROM accents")
    #item_id = db.execute("SELECT post_id FROM accents")
    halli = db.execute("SELECT * FROM accents")

    slim(:log_in, locals:{accent:halli})
end

post('/logg/:id/new')do

    route = params["logg"]
    user_id = params["id"]
    about = params["about_text"]
    grade = params["grade"]
    rating = params["rating"]
    
    db.execute("INSERT INTO accents(user_id, routes, about, grade, rating) VALUES(?, ?, ?, ?, ?);", user_id, route, about, grade, rating)

    redirect('/valid')
end

post('/lists/:id/delete')do

    post_id = params["id"]
    # db = SQLite3::Database.new("db/slut-proj.db")

    db.execute("DELETE FROM accents WHERE post_id = ?;", post_id)

    redirect('/valid')
end

post('/register')do
    # db = SQLite3::Database.new("db/slut-proj.db")
   
    pwdhash = BCrypt::Password.create(params['password'])

    db.execute("INSERT INTO users(username, Password_digest) VALUES(?, ?);", params['username'], pwdhash)

    redirect("/")
end

post('/wipe_user')do
    # db = SQLite3::Database.new("db/slut-proj.db")

    user_array = db.execute("SELECT username FROM users")
    
    if user_array != nil
        db.execute("DELETE FROM users")
    end
    redirect('/')
end

post('/create')do
    slim(:register)
end
