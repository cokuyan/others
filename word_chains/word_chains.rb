class WordChainer

  def initialize(dictionary_file_name)
    @dictionary = File.readlines(dictionary_file_name).map(&:chomp)
  end

  def inspect
  end

  def chain(source, target)
    @source = source
    @target = target

    @working_dictionary = @dictionary.select { |word| word.length == @source.length }

    @adjacent_words = { source => nil }

    @task_words = [source]
    until @task_words.empty?

      @task_words = find_task_adjacent_words
    end

    path = backtrack
    puts path
  end

  def backtrack
    path = []
    current = @target
    until current.nil?
      path << current
      current = @adjacent_words[current]
    end

    path.reverse
  end

  def find_task_adjacent_words
    task_adjacent_words = []
    @task_words.each do |task|

      words = find_adjacent_words(task).reject { |el| @adjacent_words.has_key?(el) }

      words.each { |word| @adjacent_words[word] = task }

      # if target word appears, break out of both loops
      return [] if @adjacent_words.has_key?(@target)

      task_adjacent_words.concat(words)

    end

    task_adjacent_words
  end

  def find_adjacent_words(word)
    adjacent_words = []

    @working_dictionary.each do |dict|
      next if dict == word
      diff = 0
      dict.each_char.with_index do |char, index|
        diff += 1 unless char == word[index]
        break if diff > 1
      end

      adjacent_words << dict if diff == 1
    end

    adjacent_words
  end


end
