require 'pry'
class Helpers

  def self.current_user(args)
    @current_user = User.find(args[:id])
    @current_user
  end

  def self.is_logged_in?(args)
    #binding.pry
    args.key?(:id) ? true : false
  end
end
