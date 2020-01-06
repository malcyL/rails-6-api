# spec/requests/todos_spec.rb
require 'rails_helper'

RSpec.describe 'Todos API', type: :request do
  # initialize test data
  let!(:todos) { create_list(:todo, 10) }
  let(:todo_id) { todos.first.id }

  before { signup 'test@example.com' }

  # Test suite for GET /todos
  describe 'GET /todos' do
    context 'with access token' do
      # make HTTP get request before each example
      before do
        login 'test@example.com'
        auth_params = get_auth_params_from_login_response_headers
        get '/todos', headers: auth_params
      end

      it 'returns todos' do
        # Note `json` is a custom helper to parse JSON responses
        expect(json).not_to be_empty
        expect(json.size).to eq(10)
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
    end

    context 'without access token' do
      before { get '/todos' }

      it 'returns status code 401' do
        expect(response).to have_http_status(401)
      end
    end
  end

  # Test suite for GET /todos/:id
  describe 'GET /todos/:id' do
    before do
      login 'test@example.com'
      auth_params = get_auth_params_from_login_response_headers
      get "/todos/#{todo_id}", headers: auth_params
    end

    context 'when the record exists' do
      it 'returns the todo' do
        expect(json).not_to be_empty
        expect(json['id']).to eq(todo_id)
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
    end

    context 'when the record does not exist' do
      let(:todo_id) { 100 }

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns a not found message' do
        expect(response.body).to match(/Couldn't find Todo/)
      end
    end
  end

  # Test suite for POST /todos
  describe 'POST /todos' do
    # valid payload
    let(:valid_attributes) { { title: 'Learn Elm', created_by: '1' } }

    context 'when the request is valid' do
      before do
        login 'test@example.com'
        auth_params = get_auth_params_from_login_response_headers
        post '/todos', params: valid_attributes, headers: auth_params
      end

      it 'creates a todo' do
        expect(json['title']).to eq('Learn Elm')
      end

      it 'returns status code 201' do
        expect(response).to have_http_status(201)
      end
    end

    context 'when the request is invalid' do
      before do
        login 'test@example.com'
        auth_params = get_auth_params_from_login_response_headers
        post '/todos', params: { title: 'Foobar' }, headers: auth_params
      end

      it 'returns status code 422' do
        expect(response).to have_http_status(422)
      end

      it 'returns a validation failure message' do
        expect(response.body)
          .to match(/Validation failed: Created by can't be blank/)
      end
    end
  end

  # Test suite for PUT /todos/:id
  describe 'PUT /todos/:id' do
    let(:valid_attributes) { { title: 'Shopping' } }

    context 'when the record exists' do
      before do
        login 'test@example.com'
        auth_params = get_auth_params_from_login_response_headers
        put "/todos/#{todo_id}", params: valid_attributes, headers: auth_params
      end

      it 'updates the record' do
        expect(response.body).to be_empty
      end

      it 'returns status code 204' do
        expect(response).to have_http_status(204)
      end
    end
  end

  # Test suite for DELETE /todos/:id
  describe 'DELETE /todos/:id' do
    before do
      login 'test@example.com'
      auth_params = get_auth_params_from_login_response_headers
      delete "/todos/#{todo_id}", headers: auth_params
    end

    it 'returns status code 204' do
      expect(response).to have_http_status(204)
    end
  end
end
