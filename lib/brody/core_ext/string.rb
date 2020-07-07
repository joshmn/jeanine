class String
  def presence
    return nil if self.empty?
    self
  end
end
