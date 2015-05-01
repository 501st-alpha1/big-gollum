module Constraints
  class NoUser
    def matches?(request)
      User.count == 0
    end
  end
end