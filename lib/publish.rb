module Publish
  extend self

  def pubnub
    @pubnub ||= Pubnub.new(
     :publish_key   => 'pub-c-d60f0690-9e57-44e5-b5d0-a5d18901353b',
     :subscribe_key => 'sub-c-4ca8cdb4-06c2-11e6-8c3e-0619f8945a4f'
    )
  end

  def publish(channel, message)
    pubnub.publish(
     :channel  => channel,
     :message => message,
    ) { |data| puts data.response }
  end
end