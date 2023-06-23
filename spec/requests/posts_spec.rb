require "rails_helper"

RSpec.describe "Posts", type: :request do
    
    #index - list
    describe "GET /posts" do
        before { get '/posts' }

        it "should return OK" do
            payload = JSON.parse(response.body)
            expect(payload).to be_empty
            expect(response).to have_http_status(200)
        end
    end

    describe "with data in the DB" do
        let!(:posts) { create_list(:post, 10, published: true)} #factory bot data
        before { get '/posts' }

        it "should return all the posts published posts" do
            payload = JSON.parse(response.body)
            expect(payload.size).to eq(posts.size)
            expect(response).to have_http_status(200)
        end
    end

    #show 
    describe "GET /posts/{id}" do
        let!(:post) { create(:post)} #factory bot data
        it "should return a post" do
            get "/posts/#{post.id}"
            payload = JSON.parse(response.body)
            #expect(payload).to_not be_empty
            expect(payload["id"]).to eq(post.id)
            expect(payload["title"]).to eq(post.title)
            expect(payload["content"]).to eq(post.content)
            expect(payload["published"]).to eq(post.published)
            expect(payload["author"]["name"]).to eq(post.user.name)
            expect(payload["author"]["email"]).to eq(post.user.email)
            expect(payload["author"]["id"]).to eq(post.user.id)
            expect(response).to have_http_status(200)
        end
    end
    
    #new / create
    describe "POST /posts" do
        let!(:user) { create(:user) }
        it "should create a post" do
            req_payload = {
                post: {
                    title: "title",
                    content: "content",
                    published: false,
                    user_id: user.id
                }
            }
            #POST http
            post "/posts", params: req_payload
            payload = JSON.parse(response.body)
            expect(payload).to_not be_empty
            expect(payload["id"]).to_not be_nil
            expect(response).to have_http_status(:created)
        end

        #if error
        it "should return error message on invalid post" do
            req_payload = {
                post: {
                    content: "content",
                    published: false,
                    user_id: user.id
                }
            }
            #POST http
            post "/posts", params: req_payload
            payload = JSON.parse(response.body)
            expect(payload).to_not be_empty
            expect(payload["error"]).to_not be_empty #error message
            expect(response).to have_http_status(:unprocessable_entity)
        end
    end

    # edit / update
    describe "PUT /posts/{id}" do
        #article = post
        let!(:article) { create(:post) }
        it "should update a post" do
            req_payload = {
                post: {
                    title: "updated title",
                    content: "updated content",
                    published: true,                    
                }
            }
            #PUT http
            put "/posts/#{article.id}", params: req_payload
            payload = JSON.parse(response.body)
            expect(payload).to_not be_empty
            expect(payload["id"]).to eq(article.id)
            expect(response).to have_http_status(:ok)
        end

        #if error
        it "should return error message on invalid put" do
            req_payload = {
                post: {
                    title: nil,
                    content: nil,
                    published: false
                }
            }
            #PUT http
            put "/posts/#{article.id}", params: req_payload
            payload = JSON.parse(response.body)
            expect(payload).to_not be_empty
            expect(payload["error"]).to_not be_empty #error message
            expect(response).to have_http_status(:unprocessable_entity)
        end
    end
end