class Machine
  def start
    flip_switch(:on)
  end

  def stop
    flip_switch(:off)
  end

  def state
    switch.to_s
  end

  private

  attr_accessor :switch

  def flip_switch(desired_state)
    self.switch = desired_state
  end
end

light = Machine.new
light.stop
# light.flip_switch(:on)
# light.switch = :on
# puts light.switch
puts light.state
