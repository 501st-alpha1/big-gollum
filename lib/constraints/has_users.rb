module Constraints
  class HasUsers
    def matches?(_)
      User.count > 0
    end
  end
end
