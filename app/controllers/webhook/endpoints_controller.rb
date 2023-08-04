module Webhook
  class EndpointsController < ApplicationController
    before_action :set_webhook_endpoint, only: %i[ show edit update destroy ]

    # GET /webhook/endpoints
    def index
      @webhook_endpoints = Webhook::Endpoint.all
    end

    # GET /webhook/endpoints/1
    def show
      @event_requests = @webhook_endpoint.event_requests.order(id: :DESC)
      @headers = @webhook_endpoint.headers
    end

    # GET /webhook/endpoints/new
    def new
      @webhook_endpoint = Webhook::Endpoint.new
      1.times do
        @webhook_endpoint.headers.build
      end
    end

    # GET /webhook/endpoints/1/edit
    def edit
      3.times do
        @webhook_endpoint.headers.build
      end
    end

    # POST /webhook/endpoints or /webhook/endpoints.json
    def create
      @webhook_endpoint = Webhook::Endpoint.new(webhook_endpoint_params)
      respond_to do |format|
        if @webhook_endpoint.save
          format.html { redirect_to webhook_endpoint_url(@webhook_endpoint), notice: "Endpoint was successfully created." }
        else
          format.html { render :new, status: :unprocessable_entity }
        end
      end
    end

    # PATCH/PUT /webhook/endpoints/1
    def update
      respond_to do |format|
        if @webhook_endpoint.update(webhook_endpoint_params)
          format.html { redirect_to webhook_endpoint_url(@webhook_endpoint), notice: "Endpoint was successfully updated." }
        else
          format.html { render :edit, status: :unprocessable_entity }
        end
      end
    end

    # DELETE /webhook/endpoints/1
    def destroy
      @webhook_endpoint.destroy

      respond_to do |format|
        format.html { redirect_to webhook_endpoints_url, notice: "Endpoint was successfully destroyed." }
        format.json { head :no_content }
      end
    end

    private
      # Use callbacks to share common setup or constraints between actions.
    def set_webhook_endpoint
      @webhook_endpoint = Webhook::Endpoint.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def webhook_endpoint_params
      params.require(:webhook_endpoint).permit(:url, events: [], headers_attributes: [:id, :key, :value,:_destroy])
    end
  end

end