class Brainstorm::Timer
  include Kredis::Attributes

  kredis_integer :duration_proxy, key: ->(t) { "brainstorm_id_duration_#{t.to_kredis_id}" }

  def initialize(brainstorm)
    @brainstorm = brainstorm
  end

  def duration() = duration_proxy.value
  def duration=(duration); duration_proxy.value = duration; end

  def to_kredis_id() = brainstorm.token

  private

  attr_reader :brainstorm
end
