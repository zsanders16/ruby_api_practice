require 'tty-prompt'
require 'pry'
require 'curb'
require 'json'




def welcome
  puts "Welcome to the my Ruby API app"

  display_menu
end

def display_menu
  prompt = TTY::Prompt.new
  puts "The CRUD MENU"

  menu_selection = prompt.select("What would you like to do?", ['List all Users', 'List a single user', 'Create a new user', 'Edit an user', 'Destroy a user', 'Exit'])

  case menu_selection
    when 'List all Users'
      get_all_users
    when "List a single user"
      get_a_single_user
    when "Create a new user"
      create_a_new_user
    when "Edit an user"
      edit_a_user
    when "Destroy a user"
      destroy_a_user
    when "Exit"
      puts "Thank you, come again"
      exit
  end

end

def get_all_users
  c = Curl::Easy.perform("http://devpoint-ajax-example-server.herokuapp.com/api/v1/users")
  my_hash = JSON.parse(c.body_str)
  puts my_hash

  puts ''
  puts ''
  display_menu
end

def get_a_single_user
  puts "What is the user ID?"
  answer = gets.chomp

  c = Curl::Easy.perform("http://devpoint-ajax-example-server.herokuapp.com/api/v1/users/#{answer}")
  puts JSON.parse(c.body_str)

  puts ''
  puts ''
  display_menu
end

def create_a_new_user
  puts "What is the users first name?"
  first_name = gets.chomp
  puts 'What is the users last name?'
  last_name = gets.chomp
  puts 'What is the users phone number?(optional)'
  phone_number = gets.chomp

  c = Curl::Easy.http_post("http://devpoint-ajax-example-server.herokuapp.com/api/v1/users",
                         Curl::PostField.content('user[first_name]', "#{first_name}"),
                         Curl::PostField.content('user[last_name]', "#{last_name}"),
                         Curl::PostField.content('user[phone_number]', "#{phone_number}"))


  puts 'User was successfully created.'
  puts JSON.parse(c.body_str)

  puts ''
  puts ''
  display_menu
end

def edit_a_user
  puts 'What is the user ID of the user you want to edit?'
  answer = gets.chomp

  c = Curl::Easy.perform("http://devpoint-ajax-example-server.herokuapp.com/api/v1/users/#{answer}")
  puts 'The current user information is:'
  puts JSON.parse(c.body_str)

  puts ''
  puts "What is the users first name?"
  first_name = gets.chomp
  puts 'What is the users last name?'
  last_name = gets.chomp
  puts 'What is the users phone number?(optional)'
  phone_number = gets.chomp

  c = Curl::Easy.http_post("http://devpoint-ajax-example-server.herokuapp.com/api/v1/users/#{answer}",
                         Curl::PostField.content('user[first_name]', "#{first_name}"),
                         Curl::PostField.content('user[last_name]', "#{last_name}"),
                         Curl::PostField.content('user[phone_number]', "#{phone_number}"))

   puts 'User was successfully updated.'
   puts JSON.parse(c.body_str)

   puts ''
   puts ''
   display_menu

end


def destroy_a_user
  puts 'What is the user ID of the user you want to delete?'
  answer = gets.chomp

  c = Curl::Easy.http_delete("http://devpoint-ajax-example-server.herokuapp.com/api/v1/users/#{answer}")
  puts JSON.parse(c.body_str)
  puts 'User was successfully deleted'


  puts ''
  puts ''
  display_menu

end

welcome
