class Dog
  attr_reader :name, :owner

  def self.all
    @dogs ||= []
  end

  def initialize(params = {})
    params ||= {}
    @name, @owner = params["name"], params["owner"]
  end

  def errors
    @errors ||= []
  end

  def valid?
    unless @owner.present?
      errors << "Owner can't be blank"
    end

    unless @name.present?
      errors << "Name can't be blank"
    end
    
    errors ? false : true
  end

  def save
    return false unless valid?

    Dog.all << self
    true
  end
end
