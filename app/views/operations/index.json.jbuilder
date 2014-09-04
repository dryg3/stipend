json.array!(@operations) do |operation|
  json.extract! operation, :type_op, :sum, :date_op, :text
  json.url operation_url(operation, format: :json)
end
