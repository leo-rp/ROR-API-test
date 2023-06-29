class PostReport < Struct.new(:word_count, :word_histogram)
    def self.generate(post)
        PostReport.new(               
            count(post.content),
            calc_histogram(post.content)
        )
    end

    private
    def self.count(content)
        content.split.map { |word| word.gsub(/\W/, '')}.count
    end

    def self.calc_histogram(content)
        (content
            .split
            .map { |word| word.gsub(/\W/, '')}
            .map(&:downcase)
            .group_by { |word| word }
            .transform_values(&:size))
    end

end