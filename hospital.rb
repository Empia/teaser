require 'rubygems'
require 'sinatra'
set :public, Proc.new { File.join(root, "site") }
before do 
 response.headers['Cache-Control'] = 'public, max-age=31557600'
end

get '/' do
 File.read('site/index.html')
end