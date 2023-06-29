class PostsSearchService
    def self.search(curr_posts, query)
        #curr_posts.where("title like '%#{query}%'")
        posts_ids = Rails.cache.fetch("posts_search/#{query}", expires_in: 1.hours) do 
            curr_posts.where("title LIKE  ?", curr_posts.sanitize_sql_like(query) + "%").map(&:id)
        end

        curr_posts.where(id: posts_ids)
    end
end