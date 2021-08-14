class Session
  def initialize(id)
    @id, @name_proxy = id, Kredis.string(id)
  end

  def name
    name_proxy.value
  end

  def name=(new_name)
    name_proxy.value = new_name
  end

  private

  attr_reader :id, :name_proxy
end
