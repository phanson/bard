class TagsController < ApplicationController
  def index
    @tags = Tag.all
  end

  def show
    @tag = Tag.find(params[:id])
    @passages = @tag.passages
  end

  def new
    @tag = Tag.new
  end

  def create
    @tag = Tag.new(tag_params)
    if @tag.save
      redirect_to @tag
    else
      render 'new'
    end
  end

  def edit
    @tag = Tag.find(params[:id])
  end

  def update
    @tag = Tag.update(params[:id], tag_params)
    if @tag.errors.count > 0
      render 'edit'
    else
      redirect_to @tag
    end
  end

  def destroy
    Tag.delete(params[:id])
    redirect_to tags_path
  end

  private
  def tag_params
    params.require(:tag).permit(:name)
  end
end
