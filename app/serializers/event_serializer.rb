class EventSerializer
  include JSONAPI::Serializer
  attributes :title, :description, :start_time, :end_time, :category, :location,
             :weather_data

  attribute :organizer do |object|
    {
      name: "#{object.organizer.first_name} #{object.organizer.last_name}",
      id: object.organizer.id
    }
  end

  attribute :participants do |object|
    object.participants.map do |participant|
      {
        name: "#{participant.first_name} #{participant.last_name}",
        id: participant.id
      }
    end
  end
end
