require 'rubygems'
require 'sinatra'
require 'sinatra/flash'
require 'sinatra/basic_auth'
require 'pony'
require 'hominid' # MailChimp

configure do

  # MailChimp configuration: ADD YOUR OWN ACCOUNT INFO HERE!
  set :mailchimp_api_key, "YOUR MAILCHIMP API KEY HERE"
  set :mailchimp_list_name, "YOUR MAILCHIMP LIST NAME HERE"

end


# Specify your authorization logic
authorize do |username, password|
  username == "john" && password == "doe"
end


enable :sessions
set :public, Proc.new { File.join(root, "public") }
before do 
 response.headers['Cache-Control'] = 'public, max-age=31557600'
end

protect do
  get '/' do
   File.read(File.join('public', 'index.html'))
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

=begin
post '/sendmail' do
  name = params[:name]
  mail = params[:email]
  body = params[:message]
  telephone = params[:telephone]
   
  puts "#{body} \n \n #{name} \n #{telephone}"
   if params.has_key?('name') && params.has_key?('email') && params.has_key?('telephone') && params.has_key?('message')

  Pony.mail(:to => 'iamjacke@gmail.com', 
                    :from => "#{mail}", 
                    :subject => "Сообщение с домашней страницы от #{name}", 
                    :body => "Мое имя\n #{name} Мой телефон \n #{telephone}  #{body} \n ",
                    :via => :smtp, 
                    :via_options => { 
                      :port   => '587', 
                      :user_name  => 'postmaster@jacke.mailgun.org', 
                      :password   => '4fln46y2wa00', 
                      :address   => 'smtp.mailgun.org', 
                      :authentication   => :plain, 
                      :domain => 'jacke.mailgun.org' 
                     })
            
    else
      '<script>$(".message").hide("slow").show("slow"); </script><b>Спасибо!</b><ul><li>Entering your email address?</li><li>Entering a message?</li>'
    end
  '<script>$(".message").hide("slow").show("slow"); </script><b>Спасибо!</b><ul><li>Мы с вами свяжемся</li>'
=end

end