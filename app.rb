require 'sinatra/base'
require 'sinatra/flash'
require 'sinatra/redirect_with_flash'
require 'rack-flash'
require_relative './lib/sitemanager.rb'
require_relative './lib/database_setup'
require_relative './lib/user.rb'
require 'sinatra/flash'


class Makersbnb < Sinatra::Base
  enable :sessions
  register Sinatra::Flash
  helpers Sinatra::RedirectWithFlash

  get '/' do
    erb :sign_up
  end

  post '/sign_up' do
    if params[:password] != params[:password_confirmation]
      redirect '/'
    end

    id = User.create(name: params[:name], email: params[:email], password: params[:password])
    if id == -1
      flash[:notice] = 'Email is already in use'
      redirect '/'
    end
    session['id'] = id
    redirect '/index'
  end

  get '/sign_in' do
    erb :'/sign_in'
  end

  post '/sign_in' do
    id = User.authenticate(email: params[:email], password: params[:password])
    if id == -1
      flash[:notice] = 'Please check your email and password.'
      redirect '/sign_in'
    end
    session['id'] = id
    redirect '/index'
  end

  get '/sign_out' do
    session.clear
    redirect '/'
  end

  get '/index' do
    @properties = SiteManager.get_available_listings
    erb :index
  end

  get '/list_property' do
    erb :list_property
  end

  post '/list_property' do
    SiteManager.add_listings(name: params[:name], description: params[:description], price: params[:price])
    redirect '/index'
  end

  post '/book_page_request' do
    session['property_id'] = params[:property_id]
    redirect "/book_property"
  end

  get '/book_property' do
    erb :book_property
  end

  post '/book_property' do
    SiteManager.add_booking_request(property_id: session['property_id'], start_date: params[:start_date], end_date: params[:end_date])
    redirect '/', notice: 'Booking request submitted!'
  end
end
