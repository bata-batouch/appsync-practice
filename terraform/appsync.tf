data "local_file" "weather_schema" {
  filename = "../weather.graphql"
}

resource "aws_appsync_graphql_api" "this" {
  authentication_type = "API_KEY"
  name                = "weather"
  schema              = data.local_file.weather_schema.content
}

resource "aws_appsync_api_key" "this" {
  api_id = aws_appsync_graphql_api.this.id
}

resource "aws_appsync_datasource" "weather_tsukumijima_api" {
  api_id = aws_appsync_graphql_api.this.id
  name   = "weather_tsukumijima_api"
  type   = "HTTP"

  http_config {
    endpoint = "https://weather.tsukumijima.net"
  }
}



resource "aws_appsync_function" "get_weather" {
  api_id      = aws_appsync_graphql_api.this.id
  data_source = aws_appsync_datasource.weather_tsukumijima_api.name
  name        = "getWeather"
  code        = file("../functions/getWeather.js")

  runtime {
    name            = "APPSYNC_JS"
    runtime_version = "1.0.0"
  }
}


data "local_file" "query_weather" {
  filename = "../resolver/Query.weather.js"
}

resource "aws_appsync_resolver" "query_weather" {
  api_id = aws_appsync_graphql_api.this.id
  type   = "Query"
  field  = "getWeather"
  kind   = "PIPELINE"
  code   = data.local_file.query_weather.content
  runtime {
    name            = "APPSYNC_JS"
    runtime_version = "1.0.0"
  }

  pipeline_config {
    functions = [
      aws_appsync_function.get_weather.function_id,
    ]
  }
}