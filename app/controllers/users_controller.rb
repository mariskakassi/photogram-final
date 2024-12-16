class UsersController < ApplicationController
  skip_before_action(:authenticate_user!, { :only => [:index] })
  def index
    
    matching_users = User.all

    @list_of_users = matching_users.order({ :created_at => :desc })

    render({ :template => "users/index" })
  end

  def show
    @profile_label == "profile"

    the_username = params.fetch("path_id")

    matching_users = User.where({ :username => the_username })

    @the_user = matching_users.at(0)
    the_id = @the_user.id

    @list_of_photos = Photo.where({:poster => the_id})
    @photo_num = Photo.where({:poster => the_id}).count()
    @follower_num = FollowRequest.where({:recipient => the_id, :status => "accepted"}).count()
    @following_num = FollowRequest.where({:sender => the_id, :status => "accepted"}).count()

    render({ :template => "users/show" })
  end

  def liked_photos
    @profile_label == "liked_photos"
    
    the_username = params.fetch("path_id")
    matching_users = User.where({ :username => the_username })
    @the_user = matching_users.at(0)
    the_id = @the_user.id

    @list_of_photos = Photo.where({:id => Like.where({:fan_id => the_id}).pluck(:photo_id)})
    @photo_num = Photo.where({:poster => the_id}).count()
    @follower_num = FollowRequest.where({:recipient => the_id, :status => "accepted"}).count()
    @following_num = FollowRequest.where({:sender => the_id, :status => "accepted"}).count()

    render({ :template => "users/show" })
  end

  def feed
    @profile_label == "feed"
    
    the_username = params.fetch("path_id")
    matching_users = User.where({ :username => the_username })
    @the_user = matching_users.at(0)
    the_id = @the_user.id

    FollowRequest.where({:sender_id => the_id, :status => "accepted"})
    @list_of_photos = Photo.where({:owner_id => FollowRequest.where({:sender_id => the_id, :status => "accepted"}).pluck(:recipient_id)})

    # @list_of_photos = Photo.where({:poster => the_id})

    @photo_num = Photo.where({:poster => the_id}).count()
    @follower_num = FollowRequest.where({:recipient => the_id, :status => "accepted"}).count()
    @following_num = FollowRequest.where({:sender => the_id, :status => "accepted"}).count()

    # Feed Specific

    render({ :template => "users/show" })
  end

  def discover
    @profile_label == "discover"
    
    the_username = params.fetch("path_id")
    matching_users = User.where({ :username => the_username })
    @the_user = matching_users.at(0)
    the_id = @the_user.id

    @list_of_photos = Photo.where({:poster => the_id})
    @photo_num = Photo.where({:poster => the_id}).count()
    @follower_num = FollowRequest.where({:recipient => the_id, :status => "accepted"}).count()
    @following_num = FollowRequest.where({:sender => the_id, :status => "accepted"}).count()

    # Discover Specific

    render({ :template => "users/show" })
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
