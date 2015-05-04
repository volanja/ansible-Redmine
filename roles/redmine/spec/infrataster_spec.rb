require 'spec_helper'

describe server(:redmine) do
  describe http("http://#{property['infra_url']}") do
    it 'returns 200' do
      expect(response.status).to eq(200)
    end
    it "responds content including 'Redmine'" do
      expect(response.body).to include('Redmine')
    end
    it "responds as 'text/html; charset=utf-8'" do
      expect(response.headers['content-type']).to eq("text/html; charset=utf-8")
    end
  end
end
