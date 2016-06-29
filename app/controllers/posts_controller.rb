class PostsController < ApplicationController
    before_action :authenticate_user!
    before_action :set_post, only: [:show, :edit, :update, :destroy]
    before_action :owned_post, only: [:edit, :update, :destroy]
    
    def index
        @posts = Post.all
    end
    
    def new
        @post = current_user.posts.build
    end
    
    def create
        
        @post = current_user.posts.build(post_params)
        
        
        if (post_params[:caption].length >= 3 && post_params[:caption].length <= 300 )
            @post.save
            flash[:success] = "Your post has been successfully created!"
            redirect_to posts_path
        else
            flash[:alert] = "Your post could not be created! Please check fields!"
            render :new
        end
    end
    
    def show
    end
    
    def edit
    end
    
    def update
        if @post.update(post_params)
            flash[:success] = "Update successful!"
            redirect_to post_path(@post)
        else
            flash[:alert] = "Update failed! Please check fields!"
            render :edit
        end
    end
    
    def destroy
        if @post.destroy
            flash[:alert] = "Post Deleted"
            redirect_to posts_path
        else
            render :edit
        end
    end
    
    private
    def post_params
        params.require(:post).permit(:image, :caption)
    end
    
    def set_post
        @post = Post.find(params[:id])
    end
    
    def owned_post
        unless current_user.id == @post.user_id
            flash[:alert] = "This post does not belong to you!"
            redirect_to posts_path
        end
    end
end
