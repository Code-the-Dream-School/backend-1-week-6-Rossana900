require "sinatra"

class WebGuesserApp  < Sinatra::Base
  enable :sessions

  get '/' do
    if session[:secret_number].nil?
       session[:secret_number] = rand(100)
    end

    erb :play_state
  end

  get '/won' do
    erb :won_state
  end

  get '/lost' do
    erb :lost_state
  end

  post '/reset' do
    session[:bgcolor] = ""
    session[:secret_number] = nil
    session[:mistake] = nil
    session[:tries] = []

    redirect '/', 303
  end

  post '/guess' do
    if session[:secret_number].nil?
      redirect '/', 303
    end

    session[:tries] ||= []

    session[:tries] << params[:user_input].to_i

    difference = session[:tries].last - session[:secret_number]
    if difference > 10
      session[:mistake] = "way too high"
      session[:bgcolor] = "red"
    elsif difference > 0
      session[:mistake] = "high"
      session[:bgcolor] = "yellow"
    elsif difference < -10
      session[:mistake] = "way too low"
      session[:bgcolor] = "red"
    elsif difference < 0
      session[:mistake] = "low"
      session[:bgcolor] = "yellow"
    else
      redirect '/won', 303
    end

    if session[:tries].length >= 7
      redirect '/lost', 303
    end

    redirect '/', 303
  end
end
