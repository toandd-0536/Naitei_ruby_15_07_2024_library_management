class Ability
  include CanCan::Ability

  def initialize user
    user ||= User.new

    if user.admin?
      can :manage, :all
      cannot :destroy, User, id: user.id
      cannot :destroy, User, role: "admin"
    else
      user_permissions user
    end
  end

  def user_permissions user
    can_manage_books_and_episodes user
    can_manage_cart user
    can_manage_borrowing user
    can_manage_favorites user
    can_read_authors
    can_manage_own_account user
    can_search
  end

  def can_manage_books_and_episodes user
    can :read, Book
    can :read, Episode
    can :add_to_cart, Episode
    can :manage, Rating, user_id: user.id
  end

  def can_manage_cart user
    can :manage, Cart, user_id: user.id
  end

  def can_manage_borrowing user
    can :manage, BorrowCard, user_id: user.id
    can :manage, BorrowBook, borrow_card: {user_id: user.id}
  end

  def can_manage_favorites user
    can :manage, Favorite, user_id: user.id
  end

  def can_read_authors
    can :read, Author
  end

  def can_manage_own_account user
    can :manage, User, id: user.id
  end

  def can_search
    can :search_ajax, :all
  end
end
