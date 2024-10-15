class WeatherDataDto
  attr_reader :weather_main, :weather_description, :weather_icon, :temperature,
              :temp_min, :temp_max, :humidity, :wind_speed

  def initialize(attrs = {})
    @weather_main = attrs['weather'][0]['main']
    @weather_description = attrs['weather'][0]['description']
    @weather_icon = attrs['weather'][0]['icon']
    @temperature = attrs['main']['temp']
    @temp_min = attrs['main']['temp_min']
    @temp_max = attrs['main']['temp_max']
    @humidity = attrs['main']['humidity']
    @wind_speed = attrs['wind']['speed']
  end
end
