# Members Only Project

- Rails application with basic authentication.

## Objective

    We have to "Roll our own" Rails authentication system, similar to Hartl's 
    Rail Tutorial. We'll be building an exclusive clubhouse where your members 
    can write embarrassing posts about non-members. Inside the clubhouse, 
    members can see who the author of a post is but, outside, they can only see 
    the story and wonder who wrote it.

## Walkthrough

## Database Structure

### User

- name:string 	 		 [present] 		
- email:string 		 	 [present]
- password_digest:string [present]

- has_many :posts 	 	 [dependent]

### Post

- title:string 		 	 [5 chars min, present]
- body:text 		 	 [10 chars min, present]
- user_id:integer 	 	 [present]

- belongs_to :user

## Step 1 (Setting Up)

- rails new members-only
- rails generate model User name:string email:string password_digest:string
- bundle exec rake db:migrate
- Include the bcrypt gem in your Gemfile and run bundle install
- In app/models/user.rb add has secure password

###  Add the additional validations

    has_secure_password
    validates :password, presence: true, length: { minimum: 6 }

From the console create a sample user to verify the #has_secure_password method 
validates the password and password_confirmation fields.

- user = User.create(name: "ruth", email: "ruth@example.com", password: "password", password_confirmation: "password")

### Test the authenticate command which is now available

    The has_secure_password method provides an authenticate command, which can 
    be used to authenticate a user by passing the password as an argument

- user.authenticate("wrongpassword")
- user.authenticate("password")

## Step 2 (Sessions and Sign In)

### Create a sessions controller and the routes

- rails generate controller Sessions
- get     'signin'   =>  'sessions#new'
- post    'signin'   =>  'sessions#create'
- delete  'signout'  =>  'sessions#destroy'

### Actions and Views

- In app/controllers/sessions_controller.rb make a new action
- In app/views/sessions make the view called new.html.erb
- In app/views/sessions/new.html.erb make a form to sign in the user

### Remember the user

    We want to remember that our user is signed in, so we'll need to create a 
    new string column for our User table called :remember_token which will store 
    that user's special token which will be stored as a cookie 
    and used later to authenticate users.

- rails generate migration add_remember_token_to_users remember_token:string
- bundle exec rake db:migrate

### before_create

When we create a new user, a new token should be created. Use a before_create 
callback on the User model to create a new token. We have several helper functions 
to create a random token See Hartl's Rails tutorial Ch. 8 for an explanation.

- Create a remember token
- Encrypt that token
- Save it for your user.

### Create two or more users

- User.create(name: "kim", email: "kim@example.com", password: "password", password_confirmation: "password")

- User.create(name: "jo", email: "jo@example.com", password: "password", password_confirmation: "password")

### Create the user's session

    The create action should search for user using submitted e-mail, check if 
    user exists, then authenticate using submitted password. If this all checks 
    out it will sign the user in

- In app/controllers/sessions_controller.rb 
- fill in create action to create the user's session

### Sign In Helper

    The create action above uses a sign_in helper method which we need to create 
    in app/helpers/sessions_helper.rb and we also need to include the session 
    helper in app/controllers/application_controller.rb. Then, create two other 
    methods in sessions_helper.rb one to retrieve your current user defined as 
    current_user and another to set it defined as current_user=(user)

- create the sign_in method
- include SessionsHelper
- create the current_user method
- create the current_user=(user) method

### Step 3 (Sign out)

- In app/controllers/sessions_controller.rb, update destroy action
- In app/helpers/sessions helpers.rb create sign_out method

## Step 4 (Authentication and Posts)

- rails generate model Post title:string body:text
- rails generate controller Posts
- bundle exec rake db:migrate

### Setup the routes

- resources :posts, only: [:new, :create, :index]
- root 'posts#index'

### Posts Controller

- In app/controllers/posts_controller.rb
- Define a signed_in_user method to redirect_to the signin_url
- Add a before_action for the signed in user for the new and create actions
- Create a new action in PostsController
- Create a form and save it in app/views/posts/new.html.erb

### has many and belongs to

- rails generate migration AddForeignKeyToPost user:references
- bundle exec rake db:migrate

### Add the associations to the models

- belongs_to :user
- has_many :posts

### Create the posts

- In app/controllers/posts_controller.rb
- Fill in the create action to create a new post using post_params
- Define post_params under private
- Create the index action to view all posts
- Create the index view to view all the posts
- Add a navbar with ...
- signin 
- signout
- New Post