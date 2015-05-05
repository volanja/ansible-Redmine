require 'spec_helper'

describe server(:redmine) do
  # top
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
    it "responds as 'nginx'" do
      expect(response.headers['Server']).to eq("nginx")
    end
  end

  # login
  describe http("http://#{property['infra_url']}/login") do
    it 'returns 200' do
      expect(response.status).to eq(200)
    end
    it "responds content including 'Login:'" do
      expect(response.body).to include('Login:')
    end
    it "responds content including 'Password:'" do
      expect(response.body).to include('Password:')
    end
    it "responds as 'text/html; charset=utf-8'" do
      expect(response.headers['content-type']).to eq("text/html; charset=utf-8")
    end
    it "responds as 'nginx'" do
      expect(response.headers['Server']).to eq("nginx")
    end
  end

  # javascript
  describe http("http://#{property['infra_url']}/javascripts/application.js") do
    it 'returns 200' do
      expect(response.status).to eq(200)
    end
    it "responds as 'application/javascript'" do
      expect(response.headers['content-type']).to eq("application/javascript")
    end
  end

  # css
  describe http("http://#{property['infra_url']}/stylesheets/application.css") do
    it 'returns 200' do
      expect(response.status).to eq(200)
    end
    it "responds as 'text/css'" do
      expect(response.headers['content-type']).to eq("text/css")
    end
  end
end
