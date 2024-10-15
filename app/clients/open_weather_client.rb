require 'uri'
require 'net/http'
require 'json'

# URL of api service https://openweathermap.org/current
class OpenWeatherClient
  OPEN_WEATHER_API_KEY = ENV.fetch('OPEN_WEATHER_API_KEY', nil).freeze
  OPEN_WEATHER_URL = "https://api.openweathermap.org/".freeze

  def fetch_weather_data(location)
    response = get_request("data/2.5/weather?q=#{location}&appid=#{OPEN_WEATHER_API_KEY}")
    return JSON.parse(response.body) if response.is_a?(Net::HTTPSuccess)

    nil
  end

  private

  def build_url(path)
    URI("#{OPEN_WEATHER_URL}/#{path}")
  end

  def get_request(path)
    request_url = build_url(path)
    request = Net::HTTP::Get.new(request_url)
    request['Content-Type'] = 'application/json'
    Net::HTTP.start(request_url.host, request_url.port, use_ssl: request_url.scheme == 'https') do |http|
      http.request(request)
    end
  end
end
