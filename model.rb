def select_all_users
    db.execute("SELECT username FROM users")
end

def get_pwd_hash_from_user(username)
    db.execute("SELECT password_digest FROM users WHERE username = ?;", username)
end

def select_userId_from_user(username)
    db.execute("SELECT id FROM users WHERE username = ?;", username).first[0]
end

def get_all_accent_content
    db.execute("SELECT * FROM accents")
end

def get_all_user_content
    db.execute("SELECT * FROM users")
end

def update_put_in_pic_name(name, post_id)
    db.execute("UPDATE accents SET image = ? WHERE post_id = ?;", name, post_id)
end

def make_new_post(user_id, route, about, grade, rating)
    db.execute("INSERT INTO accents(user_id, routes, about, grade, rating) VALUES(?, ?, ?, ?, ?);", user_id, route, about, grade, rating)
end

def delete_post(post_id)
    db.execute("DELETE FROM accents WHERE post_id = ?;", post_id)
end

def register_user(username, pwdhash)
    db.execute("INSERT INTO users(username, Password_digest, admin) VALUES(?, ?, ?);", username, pwdhash, 0)
end

def select_correct_username(item)
    db.execute("SELECT username FROM users WHERE id = ?;", item).first[0]
end

def find_users_for_delete
    db.execute("SELECT username FROM users")
end

def find_posts_for_delete
    db.execute("SELECT user_id FROM accents")
end

def delete_from_users
    db.execute("DELETE FROM users")
end

def delete_from_post
    db.execute("DELETE FROM accents")
end

def check_admin(username)
    db.execute("SELECT admin FROM users WHERE username = ?;", username)
end

def delete_user(user_id)
    db.execute("DELETE FROM users WHERE id = ?;", user_id)
end