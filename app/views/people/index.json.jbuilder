json.array!(@people) do |person|
  json.extract! person, :id, :height, :weight, :gender
  json.url person_url(person, format: :json)
end
