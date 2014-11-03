json.array!(@words) do |word|
  json.extract! word, :id, :title, :pharse, :mean, :learn_date, :pronunciation, :example
  json.url word_url(word, format: :json)
end
