xml.instruct!
xml.rss(:version => "2.0", "xmlns:georss" => GEORSS_NS) do

  xml.channel do
    xml.title 'Legislative Districts'
    xml.link(lookup_url)

    xml.description "Legislative Districts for #{params[:lat]}, #{params[:lng]}"
    xml << @envelope.as_georss
    @districts.each do | d |
      xml.item do
        xml.title d.display_name
        xml.description d.level
        d.the_geom.each do |polygon|
          xml << polygon.as_georss
        end
      end
    end
  end
end