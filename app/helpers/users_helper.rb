module UsersHelper

  def gravatar_for(user, size: 150)
    gravatar_id = Digest::MD5::hexdigest user.email  # advisable to use with downcase, but downcasing before save already present in user.rb model
    gravatar_url = "https://secure.gravatar.com/avatar/#{gravatar_id}?s=#{size}"
    image_tag gravatar_url, alt: user.name, class: "gravatar"
  end

end

#alternative

#   # Returns the Gravatar for the given user.
#   def gravatar_for(user, options = { size: 80 })
#     gravatar_id = Digest::MD5::hexdigest(user.email.downcase)
#     size = options[:size]
#     gravatar_url = "https://secure.gravatar.com/avatar/#{gravatar_id}?s=#{size}"
#     image_tag(gravatar_url, alt: user.name, class: "gravatar")
#   end
# end
