class Queue
  def initialize(host, channel, queue)
    @host, @channel, @queue = host, channel, queue
  end

  def write msg
    connect { |qmgr| qmgr.put(:q_name => @queue, :data => msg) }
  end
  
  def flush
    browse(:input) { |message|  }
  end
  
  def read
    messages = []
    browse { |message| messages << pretty_print(message.data) }
    messages
  end
  
  def list
    connect do |qmgr|
      return qmgr.inquire_q(:q_name=>'*').inject([]) {|acc, item| acc + [item[:q_name]] }.sort
    end
  end
  
  private
  def pretty_print xml
    begin 
      doc = REXML::Document.new xml
      formatter = REXML::Formatters::Pretty.new
      formatter.compact = true
      formatter.write(doc.root, "")
    rescue Exception
      "XML parsing error :\n" + xml.strip.gsub(/>([ ]*?)</, ">\n<")
    end
  end
  
  def connect
    WMQ::QueueManager.connect(:connection_name => @host, :channel_name => @channel) { |qmgr| yield qmgr }
  end
  
  def browse mode = :browse
    connect do |qmgr|
      qmgr.open_queue(:q_name => @queue, :mode => mode) do |queue|
        queue.each { |message| yield message }
      end
    end
  end
end

