require 'sinatra'
require 'slim'
require 'sqlite3'
require 'bcrypt'
require 'fileutils'
require_relative './model.rb'

enable :sessions

# makes db variable
def db
    SQLite3::Database.new("db/slut-proj.db")
end

# Landing page
#
get('/') do
    slim(:index)
end

# Checks entered username and password to database
#
# @param[String] username, the username entered
# @param[String] password, the password entered
#
post('/login') do
    user_array = []
    user_exists = false
    
    db.results_as_hash = true

    username = params["username"]
    password = params["password"]

    session[:username] = username

    user_array = select_all_users()

    if user_array != nil
        user_array.each do |item|
            if item[0] == username
                user_exists = true
            end
        end
    end
    
    if user_exists == true

        pwdhash = get_pwd_hash_from_user(username)
        
        session[:user_id] = select_userId_from_user(username)

        if BCrypt::Password.new(pwdhash[0][0]) == password
            redirect('/valid')
        else
            slim(:error)
        end
    else
        slim(:error)
    end
end

# Logs you out from your account
#
get('/logout')do
    slim(:index)
end

# Accesses admin page, with all posts info
#
get('/admin')do

    posts = get_all_accent_content
    users = get_all_user_content
    slim(:admin, locals:{users:users, posts:posts})
end

# validated admin and login user 
#
get('/valid')do
    if(!session[:user_id])
        redirect("/")
    end

    if "#{check_admin(session[:username])[0][0]}" == "1"
        session[:admin_pic] = "unlock.png"
    else
        session[:admin_pic] = "lock.png"
    end

    comment_content = get_all_comment_content()
    accent_content = get_all_accent_content()
    slim(:log_in, locals:{accent:accent_content, comment:comment_content})
end

# enters my_page, brings post info
#
get('/my_page')do

    amount_of_posts = 0

    a_content = get_all_accent_content

    a_content.each do |element|
        if element[0] == session[:user_id]
            amount_of_posts += 1
        end
    end
    session[:amount_of_posts] = amount_of_posts

    comment_content = get_all_comment_content()
    accent_content = get_all_accent_content()
    slim(:my_page, locals:{accent:accent_content, comment:comment_content})
end

# uploads pictures to tempfile
#
# @param[File] file, the image uploaded
# @param[String] filename, the image name
# @param[Integer] post_id, post where uploaded
#
post('/acsents/:postid/upload-image')do 
    image = params["file"]
    name = image["filename"]
    post_id = params["postid"]
    session[:name] = name
    
    tempfile = params[:file][:tempfile]
    filename = params[:file][:filename] 

    update_put_in_pic_name(name, post_id)
    
    path = "./public/uploads/#{filename}"

    File.open(path, 'wb')do |f|
        f.write(tempfile.read)
    end

    redirect('/valid')
end

# Makes new post
#
# @param[String] logg, name of route
# @param[String] about_text, post description
# @param[String] grade, route grade
# @param[Integer] rating, route rating
#
post('/acsents/new')do

    route = params["logg"]
    about = params["about_text"]
    grade = params["grade"]
    rating = params["rating"]

    user_id = session[:user_id]
    
    make_new_post(user_id, route, about, grade, rating)

    redirect('/valid')
end

# delete post
#
# @param[Integer] id, post_id to delete
#
post('/acsents/:id/delete')do

    if session[:user_id] != session[:post_belongs_to]
        redirect('/valid')
    end

    post_id = params["id"]

    delete_post(post_id)

    redirect('/valid')
end

# delete user
#
# @param[Integer] id, user_id to delete
#
post('/users/:id/delete')do

    user_id = params["id"]

    delete_user(user_id)

    redirect('/admin')
end

# Register new user
#
# @param[String] password, to check if empty
# @param[String] username, to check if empty
#
post('/users')do
    if params['password'].length || params['username'].length == 0
        slim(:error)
    end
   
    pwdhash = BCrypt::Password.create(params['password'])

    register_user(params['username'], pwdhash)
    
    redirect("/")
end

# delete users
#
post('/users/delete-all')do

    user_array = find_users_for_delete
    
    if user_array != nil
        delete_from_users
    end
    redirect('/admin')
end

# delete posts
#
post('/acsents/delete-all')do

    post_array = find_posts_for_delete
        
    if post_array != nil
        delete_from_post
    end
    redirect('/admin')
end

# shows register page
#
get('/users/new')do
    slim(:register)
end

# Adds comment to post
#
# @param[String] comment, comment to add
# @param[Integer] post_id, which post to add to
#
post('/ascents/:postid/comments')do

    content = params["comment"]
    post_id = params["postid"]
    route_name = session[:route_name]

    insert_a_comment(content,post_id)

    if route_name == "valid"
        redirect('/valid')
    elsif route_name == "my_page"
        redirect('/my_page')
    end
end
