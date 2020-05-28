#!/bin/bash
user=gitlab_user
password=gitlab_password

echo "u = User.where(id:1).first; u.password = 'admin@123'; u.password_confirmation = 'admin@123'; u.password_automatically_set = 'false'; u.save" | gitlab-rails console -e production

sleep 30

token=`echo "personal_access_token = User.find(1).personal_access_tokens.create(name: 'apitoken', impersonation: false, scopes: [:api]); puts personal_access_token.token" | gitlab-rails console -e production | tail -3 | head -1`

curl -X POST --header "PRIVATE-TOKEN: $token" -d "email=$user@email.com&password=$password&username=$user&name=$user&admin=true" http://localhost/api/v4/users
