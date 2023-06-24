class PostsSearchService
    def self.search(curr_posts, query)
        #curr_posts.where("title like '%#{query}%'")
        curr_posts.where("title LIKE  ?", curr_posts.sanitize_sql_like(query) + "%")
    end
end