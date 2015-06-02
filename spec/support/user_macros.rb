module UserMacros
  def create_user_and_sign_in
    user = create :user
    login_as user, scope: :user
    user
  end
end