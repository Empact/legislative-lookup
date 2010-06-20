class DistrictsController < ApplicationController

  def lookup
    @lat = params[:lat]
    @lng = params[:lng]

    if @lat.present? && @lng.present?
      @districts = District.lookup(@lat, @lng)
    end
    respond_to do | type |
      type.js do
        load_google_map
        render :layout => false
      end
      type.html do
        load_google_map
      end
      type.xml { render :layout => false}
      type.kml { render :layout => false}
      type.georss do
        load_envelope
        render :layout => false
      end
    end
  end

  private
  def load_envelope
    @envelope = @districts.federal.first.polygon.envelope if @districts
  end
  
  def load_google_map
    load_envelope

    @map = GMap.new("map_div")
    @map.control_init(:large_map => true, :map_type => true)
    if @districts
      @map.center_zoom_init([params[:lat], params[:lng]],6)

      @map = Variable.new("map")

      @center = GLatLng.from_georuby(@envelope.center)
      @zoom = @map.get_bounds_zoom_level(GLatLngBounds.from_georuby(@envelope))

    else
      @map.center_zoom_init([33, -87],6)
      @message = "That lat/lng is not inside a congressional district"
    end
  end

end
