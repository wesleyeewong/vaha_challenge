# frozen_string_literal: true

module RequestHelpers
  def json_response
    JSON.parse(response.body)
  end

  def json_request(verb, path, params = {}, headers = {})
    path = "/#{path}" unless path.start_with?("/")
    send(
      verb,
      path,
      params: params,
      headers: {
        "CONTENT_TYPE" => "application/json"
      }.merge(headers)
    )
  end

  def json_request_with_token(user, verb, path, params = {}, headers = {})
    payload = path.contain?("internal") ? { "trainer_id" => user.id } : { "trainee_id" => user.id }
    token = JWT.encode(payload, nil, "none")
    json_request(verb, path, params, headers.merge("Authorization" => "Bearer #{token}"))
  end
end
