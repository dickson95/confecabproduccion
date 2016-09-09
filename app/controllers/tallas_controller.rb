class TallasController < ApplicationController
  before_action :set_talla, only: [:show, :edit, :update, :destroy]

  # GET /tallas
  # GET /tallas.json
  def index
    @tallas = Talla.all
  end

  # GET /tallas/1
  # GET /tallas/1.json
  def show
  end

  # GET /tallas/new
  def new
    @talla = Talla.new
  end

  # GET /tallas/1/edit
  def edit
  end

  # POST /tallas
  # POST /tallas.json
  def create
    @talla = Talla.new(talla_params)

    respond_to do |format|
      if @talla.save
        format.html { redirect_to @talla, notice: 'Talla was successfully created.' }
        format.json { render :show, status: :created, location: @talla }
      else
        format.html { render :new }
        format.json { render json: @talla.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /tallas/1
  # PATCH/PUT /tallas/1.json
  def update
    respond_to do |format|
      if @talla.update(talla_params)
        format.html { redirect_to @talla, notice: 'Talla was successfully updated.' }
        format.json { render :show, status: :ok, location: @talla }
      else
        format.html { render :edit }
        format.json { render json: @talla.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tallas/1
  # DELETE /tallas/1.json
  def destroy
    @talla.destroy
    respond_to do |format|
      format.html { redirect_to tallas_url, notice: 'Talla was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_talla
      @talla = Talla.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def talla_params
      params.require(:talla).permit(:talla, :categoria_id)
    end
end
