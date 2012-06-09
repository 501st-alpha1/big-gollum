module ApplicationHelper
  def gravatar_url_for(email, options = {})
    "http://gravatar.com/avatar/#{Digest::MD5.hexdigest(email)}?rating=PG&size=40&default=identicon"
  end
end
