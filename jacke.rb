require 'rubygems'
require 'sinatra'
require 'sinatra/flash'
require 'sinatra/basic_auth'
require 'pony'
require 'hominid' # MailChimp

configure do

  # MailChimp configuration: ADD YOUR OWN ACCOUNT INFO HERE!
  set :mailchimp_api_key, "e78fe34c7835335c66b52e6c2b7c05aa-us5"
  set :mailchimp_list_name, "Empire Industries Newsletter"

end

=begin
# Specify your authorization logic
authorize do |username, password|
  username == "john" && password == "doe"
end
=end


#protect do
  get '/' do
   File.read(File.join('public', 'index.html'))
  end
   get '/ready' do
   File.read(File.join('public', 'ready.html'))
  end

post '/signup' do
  email = params[:email]
  unless email.nil? || email.strip.empty?
    mailchimp = Hominid::API.new(settings.mailchimp_api_key)
    list_id = mailchimp.find_list_id_by_name(settings.mailchimp_list_name)
    raise "Unable to retrieve list id from MailChimp API." unless list_id
    mailchimp.list_subscribe(list_id, email, {}, 'html', false, true, true, false)
  end
  "Success."
end
