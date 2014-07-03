class ResourcesController < ApplicationController
  def index
    @resources = Resource.all
  end

  def show
    @resource = Resource.find(params[:id])
  end

  def new
    @resource = Resource.new
  end

  def create
    @resource = Resource.new(resource_params)
    if @resource.save
      redirect_to @resource
    else
      render 'new'
    end
  end

  def edit
    @resource = Resource.find(params[:id])
  end

  def update
    @resource = Resource.update(params[:id], resource_params)
    if @resource.errors.count > 0
      render 'edit'
    else
      redirect_to @resource
    end
  end

  def destroy
    Resource.delete(params[:id])
    redirect_to resources_path
  end

  private
  def resource_params
    params.require(:resource).permit(:name, :authors, :type_id, :date)
  end
end
