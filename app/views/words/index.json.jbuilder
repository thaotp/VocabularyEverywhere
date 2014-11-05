json.array!(@words) do |word|
  json.extract! word, :learn_date, :content
  json.url word_url(word, format: :json)
end
