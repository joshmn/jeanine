module Jeanine
  module ViewPaths
    def append_view_path(path)
      Jeanine.view_paths << path
    end
  end
end
