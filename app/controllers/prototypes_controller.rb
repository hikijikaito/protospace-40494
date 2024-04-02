class PrototypesController < ApplicationController
  before_action :set_prototype, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!, only: [:new, :create, :edit, :update, :destroy]

  def index
    @prototypes = Prototype.all
  end

  def new
    @prototype = Prototype.new
  end

  def create
    @prototype = current_user.prototypes.build(prototype_params)
    if @prototype.save
      redirect_to root_path, notice: "Prototype was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @prototype = Prototype.includes(:user, :comments).find(params[:id])
    @comment = Comment.new
    @comments = @prototype.comments || []
  end
  
  def edit
    unless current_user == @prototype.user
      redirect_to root_path, alert: "You don't have permission to edit this prototype."
    end
  end

  def update
    if @prototype.update(prototype_params)
      redirect_to @prototype, notice: "Prototype was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @prototype.destroy
    redirect_to root_path, notice: "Prototype was successfully destroyed."
  end

  private
  
  def prototype_params
    params.require(:prototype).permit(:title, :catch_copy, :concept, :image)
  end
  
  def set_prototype
    @prototype = Prototype.find(params[:id])
  end
end
