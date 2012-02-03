class MytweetsController < ApplicationController
        require 'rubygems'
        require 'twitter'
        require 'oauth'
        require 'open-uri'
        require 'json'
        require 'net/http'
        before_filter :auth_tweet
        def index
                @mytweet=Mytweet.new
                if !session[:access_token].nil? && !session[:access_secret].nil?
                        @consumer = OAuth::Consumer.new("KL1iuGBUu6o7KgK2rIhVeg", "6ITyJ0ZuvuX86VMJ3bb0p3XdyYdFZEHNZcnw6mbw", :site => "https://api.twitter.com")
                        @accesstoken = OAuth::AccessToken.new(@consumer, session[:access_token],session[:access_secret])
                        @data = @accesstoken.get "https://api.twitter.com/1/statuses/home_timeline.json?include_entities=true"
                        result = @data.body
                        @results = JSON.parse(result)
                end
                #render :text=> session["session_id"].inspect and return false
        end
        def create
                 response = $access_token.post("http://api.twitter.com/1/statuses/update.json", {:status =>"#{params["tweet"]}"})
                 logger.info response.inspect
                 redirect_to "/mytweets"
        end
        def session_out
                session[:access_token]=nil
                #render :text=> cookie.class.inspect and return false
                redirect_to "/mytweets"
        end
        def destroy
                $access_token.post("http://api.twitter.com/1/statuses/destroy/#{params[:id]}.json")
                redirect_to "/mytweets"
        end
        def auth_tweet
                if session[:request_token].nil?
                        @consumer = OAuth::Consumer.new("KL1iuGBUu6o7KgK2rIhVeg", "6ITyJ0ZuvuX86VMJ3bb0p3XdyYdFZEHNZcnw6mbw", :site => "https://api.twitter.com")
                        session[:request_token]=@consumer.get_request_token(:oauth_callback => 'http://localhost:3000/mytweets')
                        redirect_to session[:request_token].authorize_url
                else
                        $access_token ||= session[:request_token].get_access_token if session[:access_token].nil?
                        session[:access_token] = $access_token.token
                        session[:access_secret] = $access_token.secret
                end
        end
end

