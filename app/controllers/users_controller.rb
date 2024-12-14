class UsersController < ApplicationController
  def index
    matching_users = User.all

    @list_of_users = matching_users.order({ :created_at => :desc })

    render({ :template => "users/index" })
  end

  def show
    the_id = params.fetch("path_id")

    matching_users = User.where({ :id => the_id })

    @the_user = matching_users.at(0)

    @list_of_photos = Photo.where({:poster => the_id})
    @photo_num = Photo.where({:poster => the_id}).count()
    @follower_num = FollowRequest.where({:recipient => the_id, :status => "accepted"}).count()
    @following_num = FollowRequest.where({:sender => the_id, :status => "accepted"}).count()

    render({ :template => "users/show" })
  end

  def signup
    render({ :template => "devise/registrations/new" })
  end

  def signin
    render({ :template => "devise/sessions/new" })
  end

  def create
    the_user = User.new
    the_user.username = params.fetch("query_username")
    the_user.comments_count = params.fetch("query_comments_count")
    the_user.likes_count = params.fetch("query_likes_count")
    the_user.private = params.fetch("query_private", false)
    the_user.own_photos_count = params.fetch("query_own_photos_count")

    if the_user.valid?
      the_user.save
      redirect_to("/users", { :notice => "User created successfully." })
    else
      redirect_to("/users", { :alert => the_user.errors.full_messages.to_sentence })
    end
  end

  def update
    the_id = params.fetch("path_id")
    the_user = User.where({ :id => the_id }).at(0)

    the_user.username = params.fetch("query_username")
    the_user.comments_count = params.fetch("query_comments_count")
    the_user.likes_count = params.fetch("query_likes_count")
    the_user.private = params.fetch("query_private", false)
    the_user.own_photos_count = params.fetch("query_own_photos_count")

    if the_user.valid?
      the_user.save
      redirect_to("/users/#{the_user.id}", { :notice => "User updated successfully."} )
    else
      redirect_to("/users/#{the_user.id}", { :alert => the_user.errors.full_messages.to_sentence })
    end
  end

  def destroy
    the_id = params.fetch("path_id")
    the_user = User.where({ :id => the_id }).at(0)

    the_user.destroy

    redirect_to("/users", { :notice => "User deleted successfully."} )
  end
end
