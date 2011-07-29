class UserSession < Authlogic::Session::Base
  def self.create_federated(email)
    self.create(:email => email, :password => FEDERATED_PASSWORD)
  end
end
