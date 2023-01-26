class Public::CommentsController < ApplicationController

  def create
    @post = Post.find(params[:post_id])
    @comment = Comment.new(comment_params)
    @comment.user_id = current_user.id
    #上2行の省略バージョン →comment = current_user.post_comments.new(post_comment_params)
    @comment.post_id = @post.id
    @comment.save
    redirect_to post_path(@post.id)
  end

  #エラーでてる
  def destroy
    Comment.find(params[:id]).destroy
    redirect_to post_path(params[:post_id])
  end

  private

  def comment_params
    params.require(:comment).permit(:comment)
  end

end
