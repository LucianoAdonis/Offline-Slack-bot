#require 'slack-ruby-client'
require './core'
require './system'

# Represent data receive from slack
module SlackIn
  def self.channel
    '#seguridad'
  end

  def self.text
    'enerborg hola'
  end

  def self.user
    'lucio'
  end
end

# Instead of Real Time, it's just one request based on the SlackIn module
class LERN
  extend Features
  extend Intelligence

  def initialize
    text = SlackIn.text
    p "User said: #{text}"

    case text
    when /^enerborg/
      reply = LERN.process(text)
      Reply.new(SlackIn, reply)
    when /^enerai/
      chan, message = LERN.say(text)
      Reply.new(chan, message)
    end
  end

  # Custom configuration for test purposes
  def self.config(name, icon, token)
    @bot_name = name
    @bot_icon = icon
    @bot_token = token
  end

  # Differentiates response when it comes from a thread and figures how to get the channel's name
  def self.response(src, reply, file = '')
    stamp = src.ts if src.to_s.include?('thread_ts')
    channel = if src.respond_to? :channel
                src.channel
              else
                src
              end

    p <<-HEREDOC
Bot_icon: #{@bot_icon} | Bot_name: #{@bot_name}
Channel: #{channel} | Text: #{reply} | Stamp: #{stamp} | File: #{file}
HEREDOC
  end
end
