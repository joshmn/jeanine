module Jeanine
  def env
    @_env ||= (ENV["RACK_ENV"].presence || "development")
  end

  def groups(*groups)
    hash = groups.extract_options!
    env = Jeanine.env
    groups.unshift(:default, env)
    groups.concat ENV["BRODY_GROUPS"].to_s.split(",")
    groups.concat hash.map { |k, v| k if v.map(&:to_s).include?(env) }
    groups.compact!
    groups.uniq!
    groups
  end
end
