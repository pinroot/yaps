class PingersController < ApplicationController
  before_action :set_pinger, only: %i[ show edit update destroy ]

  # GET /pingers or /pingers.json
  def index
    @pingers = Pinger.all
  end

  # GET /pingers/1 or /pingers/1.json
  def show
  end

  # GET /pingers/new
  def new
    @pinger = Pinger.new
  end

  # GET /pingers/1/edit
  def edit
  end

  # POST /pingers or /pingers.json
  def create
    @pinger = Pinger.new(pinger_params)

    respond_to do |format|
      if @pinger.save
        format.html { redirect_to pinger_url(@pinger), notice: "Pinger was successfully created." }
        format.json { render :show, status: :created, location: @pinger }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @pinger.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /pingers/1 or /pingers/1.json
  def update
    respond_to do |format|
      if @pinger.update(pinger_params)
        format.html { redirect_to pinger_url(@pinger), notice: "Pinger was successfully updated." }
        format.json { render :show, status: :ok, location: @pinger }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @pinger.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /pingers/1 or /pingers/1.json
  def destroy
    @pinger.destroy

    respond_to do |format|
      format.html { redirect_to pingers_url, notice: "Pinger was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_pinger
      @pinger = Pinger.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def pinger_params
      params.require(:pinger).permit(:name, :address, :interval, :timeout, :port, :pinger_type, :enabled)
    end
end
