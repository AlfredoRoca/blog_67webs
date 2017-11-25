Description: Find_by inside a scope issue in Rails 4.2
Date: 25/11/2017
Categories: rails
Summary: This is another reason why tests are so important
Keywords: rails, scope

#Find_by inside a scope issue in Rails 4.2

Last Rails version: 4.2.6

    scope :madrid, -> { find_by(name: "Madrid") } 

    (or find_by_name("Madrid")) 

    scope :alf, -> { where(id: 1).first }

should return `nil` if there is no match. But returns all records!

It works if declared in a class method

    def self.madrid
      find_by_name("Madrid")
    end

