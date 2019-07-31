require 'sitemanager'

describe SiteManager do

  describe '.get_available_listings' do
    it 'returns a list of properties' do

      Database.query("INSERT INTO properties (property_name, description, price) VALUES('Hello', 'Haha', '1000');")

      site_manager = SiteManager.get_available_listings


      expect(site_manager.length).to eq 1
      expect(site_manager.first).to be_a Property
      # expect(site_manager.first.id).to eq site_manager.id
      expect(site_manager.first.name).to eq 'Hello'
      expect(site_manager.first.description).to eq 'Haha'
      expect(site_manager.first.price).to eq '1000'
    end
  end

  describe '.add_listings' do
    it 'add properties to a list' do
      site_manager = SiteManager.add_listings(name: "Hello", description: "Haha", price: "1000")

      properties = Database.query("SELECT * FROM properties;")

      expect(properties.first["property_name"]).to eq 'Hello'
      expect(properties.first["description"]).to eq 'Haha'
      expect(properties.first["price"]).to eq '1000'
    end
  end

  describe '.add_bookings' do
    it 'adds bookings to the database' do
      site_manager = SiteManager.add_booking_request( start_date: "2019-08-01", end_date: "2019-08-29")

      bookings = Database.query("SELECT * FROM bookings;")

      # expect(bookings.first["property_id"]).to eq property.id
      expect(bookings.first["start_date"]).to eq '2019-08-01'
      expect(bookings.first["end_date"]).to eq '2019-08-29'
    end
  end
end