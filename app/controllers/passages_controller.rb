class PassagesController < ApplicationController
  def index
    @passages = Passage.all
  end

  def show
    @passage = Passage.find(params[:id])
  end

  def new
    @passage = Passage.new
  end

  def create
    @passage = Passage.new(passage_params)
    if @passage.save
      redirect_to @passage
    else
      render 'new'
    end
  end

  def edit
    @passage = Passage.find(params[:id])
  end

  def update
    @passage = Passage.update(params[:id], passage_params)
    if @passage.errors.count > 0
      render 'edit'
    else
      redirect_to @passage
    end
  end

  def destroy
    Passage.delete(params[:id])
    redirect_to passages_path
  end

  private
  def passage_params
    params.require(:passage).permit(:title, :body, :resource_id, :author_id)
  end
end
