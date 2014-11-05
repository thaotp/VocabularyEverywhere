class Word < ActiveRecord::Base
	serialize :content, Hash
end
