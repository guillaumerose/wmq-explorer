require 'sinatra'
require './mq'

$host = 'wmq.company.com(port)'
$channel = 'channel'

class MqBrowser < Sinatra::Base
  get '/queues' do
    begin
      mq = get_queue params[:queue]
      messages = mq.list
    rescue => details
      errors = details.message
    end
    
    content_type :json
    answer = {:queues => messages, :errors => errors || ""}.to_json
    
    if params[:callback]
      params[:callback] + "(" + answer + ")"
    else
      answer
    end
  end  
  
  get '/:queue' do
    begin
      mq = get_queue params[:queue]
      messages = mq.read
    rescue => details
      errors = details.message
    end
    
    content_type :json
    answer = {:messages => messages, :errors => errors || ""}.to_json
    
    if params[:callback]
      params[:callback] + "(" + answer + ")"
    else
      answer
    end
  end
  
  post '/:queue' do
    begin
      mq = get_queue params[:queue]
      mq.write params[:message]
    rescue
    end
    
    "OK"
  end
  
  delete '/:queue' do
    begin
      mq = get_queue params[:queue]
      mq.flush
    rescue
    end
    
    "OK"
  end
  
  private
  def get_queue queue
    mq = Queue.new $host, $channel, queue
  end
end
