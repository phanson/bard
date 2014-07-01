class ResourceTypesController < ApplicationController
  def index
    @types = ResourceType.all
  end

  def show
    @type = ResourceType.find(params[:id])
    @resources = @type.resources
  end

  def new
    @type = ResourceType.new
  end

  def create
    @type = ResourceType.new(resource_type_params)
    if @type.save
      redirect_to @type
    else
      render 'new'
    end
  end

  def edit
    @type = ResourceType.find(params[:id])
  end

  def update
    @type = ResourceType.update(params[:id], resource_type_params)
    if @type.errors.count > 0
      render 'edit'
    else
      redirect_to @type
    end
  end

  def destroy
    ResourceType.delete(params[:id])
    redirect_to resource_types_path
  end

  private
  def resource_type_params
    params.require(:resource_type).permit(:name)
  end
end
