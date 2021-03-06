def read_shows
  counter = 1

  until counter >= 21
    HTTParty.get("http://api.seatgeek.com/2/events?per_page=5000&page=#{counter}&client_id=#{Rails.application.secrets.seatgeek_id}&client_secret=#{Rails.application.secrets.seatgeek_secret}")["events"].each do |event|
      if (event["venue"]["city"].downcase == "boston" || event["venue"]["city"].downcase == "cambridge") && event["type"].downcase == "concert"
        venue = Venue.find_or_create_by(name: event["venue"]["name"], latitude: event["venue"]["location"]["lat"], longitude: event["venue"]["location"]["lon"])
        band = Band.find_or_create_by(name: event["performers"].first["name"])

        Show.find_or_create_by(date: event["datetime_local"].split("T")[0], time: event["datetime_local"].split("T")[1],
        image_url: event["performers"].first["image"], ticket_url: event["performers"].first["url"], band_id: band.id, venue_id: venue.id)
      end
    end
    counter += 1
  end
end

def delete_old
  Show.where("date < ?", Date.today.to_s).delete_all
end

read_shows
