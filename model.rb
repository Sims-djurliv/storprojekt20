# Selects all users names
#
def select_all_users
    db.execute("SELECT username FROM users")
end

# gets password hash from user
def get_pwd_hash_from_user(username)
    db.execute("SELECT password_digest FROM users WHERE username = ?;", username)
end

# Finds user id
def select_userId_from_user(username)
    db.execute("SELECT id FROM users WHERE username = ?;", username).first[0]
end

# Gets all accent content
def get_all_accent_content
    db.execute("SELECT * FROM accents")
end

# gets all user ontent
def get_all_user_content
    db.execute("SELECT * FROM users")
end

# gets all comment content
def get_all_comment_content
    db.execute("SELECT * FROM comments")
end

# updates picture name
def update_put_in_pic_name(name, post_id)
    db.execute("UPDATE accents SET image = ? WHERE post_id = ?;", name, post_id)
end

# makes new post
def make_new_post(user_id, route, about, grade, rating)
    db.execute("INSERT INTO accents(user_id, routes, about, grade, rating) VALUES(?, ?, ?, ?, ?);", user_id, route, about, grade, rating)
end

# deletes post
def delete_post(post_id)
    db.execute("DELETE FROM accents WHERE post_id = ?;", post_id)
end

# registers new user
def register_user(username, pwdhash)
    db.execute("INSERT INTO users(username, Password_digest, admin) VALUES(?, ?, ?);", username, pwdhash, 0)
end

# selects username based on user_id
def select_correct_username(item)
    db.execute("SELECT username FROM users WHERE id = ?;", item).first[0]
end

# gets all usernames
def find_users_for_delete
    db.execute("SELECT username FROM users")
end

# finds posts for delete
def find_posts_for_delete
    db.execute("SELECT user_id FROM accents")
end

# deletes from users
def delete_from_users
    db.execute("DELETE FROM users")
end

# delete from posts
def delete_from_post
    db.execute("DELETE FROM accents")
end

# checks admin status
def check_admin(username)
    db.execute("SELECT admin FROM users WHERE username = ?;", username)
end

# delete user
def delete_user(user_id)
    db.execute("DELETE FROM users WHERE id = ?;", user_id)
end

# insert comment
def insert_a_comment(content,post_id)
    db.execute("INSERT INTO comments(content,post_id,user_id) VALUES(?, ?, ?);", content, post_id, session[:user_id])
end