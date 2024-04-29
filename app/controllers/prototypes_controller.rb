class PrototypesController < ApplicationController
    before_action :move_to_index,except: [:index,:show]
    before_action :move_to_top,only: [:edit,:update]
    before_action :authenticate_user!,except: [:index,:show]

    def index
        @prototypes = Prototype.all
    end

    def new
        @prototype = Prototype.new
    end

    def create
        @prototype = Prototype.new(prototype_params)
        if @prototype.save
            redirect_to root_path
        else
            render :new, status: :unprocessable_entity
        end
    end

    def show
        @prototype = Prototype.find(params[:id])
        @comment = Comment.new
        @comments = @prototype.comments.includes(:user)
    end

    def edit
        @prototype = Prototype.find(params[:id])
    end

    def update
        @prototype = Prototype.find(params[:id])
        if @prototype.update(prototype_params)
            redirect_to prototype_path
        else
            render :edit, status: :unprocessable_entity
        end
    end

    def destroy
        @prototype = Prototype.find(params[:id])
        @prototype.destroy
        redirect_to prototypes_path

    end

    private 
    def move_to_index
        unless user_signed_in?
            redirect_to action: :index
        end
    end

    def prototype_params
        params.require(:prototype).permit(:title,:catch_copy,:concept,:image).merge(user_id: current_user.id)
    end

    def move_to_top
        @prototype = Prototype.find(params[:id])
        @user = @prototype.user
        unless current_user == @user
            redirect_to action: :index
        end
    end 

end
