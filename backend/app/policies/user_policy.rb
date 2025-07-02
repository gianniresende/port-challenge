class UserPolicy
  attr_reader :current_user, :record

  def initialize(current_user, record)
    @current_user = current_user
    @record = record
  end
  def create?
    admin_or_hr?
  end

  def inactivate?
    admin_or_hr?
  end

  def destroy?
    current_user.admin?
  end

  private

  def admin_or_hr?
    current_user.admin? || current_user.hr?
  end
end
