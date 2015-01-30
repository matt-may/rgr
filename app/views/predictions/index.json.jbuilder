json.array!(@predictions) do |prediction|
  json.extract! prediction, :id, :height, :weight, :result
  json.url prediction_url(prediction, format: :json)
end
