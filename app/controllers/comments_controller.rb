class CommentsController < ApplicationController
    def create
        @comment = Comment.new(comment_params)
        if @comment.save
            redirect_to prototype_path(@comment.prototype)
        else
            @prototype = @comment.prototype
            @comment = Comment.new(comment_params)
            @comments = @prototype.comments
            render "prototypes/show", status: :unprocessable_entity
        end
    end

    private
        def comment_params
            params.require(:comment).permit(:content).merge(user_id: current_user.id, prototype_id: params[:prototype_id])
        end
end
