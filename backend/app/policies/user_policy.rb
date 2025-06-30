class UserPolicy
  attr_reader :current_user, :record

  def initialize(current_user, record)
    @current_user = current_user
    @record = record
  end
  def create?
    current_user.admin?
  end

  def inactivate?
    current_user.admin?
  end

  def destroy?
    current_user.admin?
  end
end
