require 'rubygems'
require 'sinatra'
require 'sinatra/flash'
require 'pony'

enable :sessions
set :public, Proc.new { File.join(root, "site") }
before do 
 response.headers['Cache-Control'] = 'public, max-age=31557600'
end

get '/' do
 File.read('site/index.html')
end

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
end