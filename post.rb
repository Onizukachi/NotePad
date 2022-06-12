class Post
  def initialize
    @created_at = Time.now
    @text = nil
  end

  class << self
    def post_types
      [Memo, Link, Task]
    end

    def create(type_index)
      return post_types[type_index].new
    end
  end


  def read_from_console

  end

  def to_strings
    
  end

  def save
    file = File.new(file_path, "w:UTF-8")

    to_strings.each do |item|
      file.puts item
    end

    file.close
  end

  def file_path
    curr_path = File.dirname(__FILE__)

    file_name = @created_at.strftime("#{self.class.name}_%Y-%m-%d_%H-%M-%S.txt")

    return curr_path + "/recordings/" + file_name
  end
end