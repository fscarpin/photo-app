class ImagesController < ApplicationController
  before_action :set_image, only: [:show, :edit, :update, :destroy]

  # GET /images
  # GET /images.json
  def index
    @images = Image.where(user: current_user)
    @image = Image.new
  end

  # GET /images/1
  # GET /images/1.json
  def show
  end

  # GET /images/1/edit
  def edit
  end

  # POST /images
  # POST /images.json
  def create
    binding.pry
    @image = Image.new(image_params)
    @image.user = current_user

    respond_to do |format|
      if @image.save
        format.html { redirect_to @image, notice: 'Image was uploaded successfully.' }
        format.json { render :show, status: :created, location: @image }
      else
        @images = Image.where(user: current_user)
        format.html { render :index }
        format.json { render json: @image.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /images/1
  # DELETE /images/1.json
  def destroy
    @image.destroy
    respond_to do |format|
      format.html { redirect_to images_url, notice: 'Image was deleted successfully.' }
      format.json { head :no_content }
    end
  end

  def destroy_multiples
    image_ids = params[:image_ids]
    image_ids.each do |id|
      Image.find(id).destroy
    end

    flash[:notice] = "Images have been deleted"
    redirect_to images_path
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_image
      @image = Image.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def image_params
      params.require(:image).permit(:picture, :user_id)
    end
end
