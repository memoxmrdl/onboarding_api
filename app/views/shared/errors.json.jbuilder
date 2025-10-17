json.errors errors do |error|
  json.attribute error[:attribute]
  json.message error[:message]
end
