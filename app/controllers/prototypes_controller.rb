class PrototypesController < ApplicationController
  before_action :authenticate_user!, only: [:new, :edit, :destroy]
  before_action :set_prototype, only: [:show, :edit, :update, :destroy]

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
    @prototype = Prototype.includes(:user).find(params[:id])
    @comment = Comment.new
    @comments = @prototype.comments
  end
  
  def edit
    @prototype = Prototype.find(params[:id])
    unless current_user == @prototype.user
      redirect_to root_path
    end
  end

  def update
    @prototype = Prototype.find(params[:id])
    if @prototype.update(prototype_params)
      # 更新が成功した場合は、そのプロトタイプの詳細ページにリダイレクトする
      redirect_to prototype_path(@prototype)
    else
      # 更新が失敗した場合は、編集ページを再表示する
      render :edit
    end
  end

  def destroy
    @prototype = Prototype.find(params[:id])
    @prototype.destroy
    redirect_to root_path
  end

  private
  
  def prototype_params
    params.require(:prototype).permit(:title, :catch_copy, :concept, :image).merge(user_id: current_user.id)
  end
  
  def set_prototype
    @prototype = Prototype.find(params[:id])
    
    # プロトタイプの編集権限を確認し、ログインユーザーとプロトタイプの投稿者が一致しない場合はトップページにリダイレクトする
    if @prototype.user != current_user
      redirect_to root_path, alert: "他のユーザーのプロトタイプを編集することはできません。"
    end
  end

end
