# Validates origin and permissions over request
module Validate
  ADMIN_LIST = ''.freeze
  CHANNEL_LIST = ''.freeze
  BAN_LIST = ''.freeze

  # Validates if user is banned
  def worthy?(user)
    'NOT' if BAN_LIST.include?(user) # || !ADMIN_LIST.include?(user)
  end

  # Validates if the specified channel is whitelisted
  def channel?(chan)
    'LOCKED ORIGIN' unless CHANNEL_LIST.include?(chan)
  end

  # Differentiates the permissions for the calling user based on the channel
  def redirect(value, user, channel)
    case value
    when 'NOT'
      if BAN_LIST.include?(user)
        LERN.response(channel, 'You are still banned until i forget it')
      elsif ADMIN_LIST.include?(user)
        LERN.response('#logs', "User #{user} tried to do something nasty")
      end
    when 'LOCKED ORIGIN'
      LERN.response('#logs', "User #{user} making me work on #{channel}")
    end
  end
end

# Differentiates the request type and triggers the happy response
class Reply
  extend Validate

  def initialize(data, reply)
    if data.respond_to? :channel
      user = data.user
      channel = data.channel

      access = Reply.worthy?(user)
      scope = Reply.channel?(channel)

      LERN.response('#bots', reply) unless Reply.redirect(scope, user, channel).nil?
      LERN.response(channel, reply) if Reply.redirect(access, user, channel).nil?
    else
      LERN.response(data, reply) if Reply.redirect(access, user, channel).nil?
    end
  end
end
