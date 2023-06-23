require "rails_helper"

RSpec.describe "Posts", type: :request do
    
    describe "GET /post" do
        before { get '/post' }

        it "should return OK" do 
            payload = JSON.parse(response.body)
            expect(payload).to be_empty
            expect(response).to have_http_status(200)
        end
    end

    decribe "with data in the DB" do
        before { get '/post' }
        let(:posts) { create_list(:post, 10 published: true)} #factory bot data            
        it "should return all the posts published posts" do             
            payload = JSON.parse(response.body)
            expect(payload.size).to eq(posts.size)
            expect(response).to have_http_status(200)
        end
    end
    
    describe "GET /post/{id}" do
        let(:post) { create(:post)} #factory bot data
        it "should return a post" do
            get "/post/#{post.id}" 
            payload = JSON.parse(response.body)
            expect(payload.size).to_not be_empty
            expect(payload["id"]).to eq(post.id)

            expect(response).to have_http_status(200)
        end
    end


end