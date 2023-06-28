Mix.install([:plug, :plug_cowboy])

defmodule MyPlug do
  use Plug.Router

  plug(Plug.Logger)
  plug(:match)
  plug(:dispatch)

  get "/" do
    send_resp(conn, 200, """
    <head>
      <script src="https://unpkg.com/htmx.org@1.9.2" integrity="sha384-L6OqL9pRWyyFU3+/bjdSri+iIphTN/bvYyM37tICVyOJkWZLpP2vGn6VUEXgzg6h" crossorigin="anonymous"></script>
    </head>
    <body hx-boost="true">
      <h1>Hello World</h1>
      <ol>
        <li><a href="/2">go to page 2</a></li>
        <li><a href="#a">go to a</a></li>
        <li><a href="#b">go to b</a></li>
      </ol>
      <div style="height: 1000px"></div>
      <h2 id="a">aaaaaaaaa</h2>
      <div style="height: 1000px">
      #{String.duplicate("a", 1_000_000)}
      <h2 id="b">bbbbbbbbb</h2>
      <div style="height: 1000px"></div>
    </body>
    """)
  end

  get "/2" do
    send_resp(conn, 200, """
    <head>
      <script src="https://unpkg.com/htmx.org@1.9.2" integrity="sha384-L6OqL9pRWyyFU3+/bjdSri+iIphTN/bvYyM37tICVyOJkWZLpP2vGn6VUEXgzg6h" crossorigin="anonymous"></script>
    </head>
    <body hx-boost="true">
      <h1>Hello World</h1>
      <ol>
        <li><a href="/">go to home page</a></li>
        <li><a href="#c">go to c</a></li>
        <li><a href="#d">go to d</a></li>
      </ol>
      <div style="height: 1000px"></div>
      <h2 id="c">ccccccccc</h2>
      <div style="height: 1000px"></div>
      <h2 id="d">ddddddddd</h2>
      <div style="height: 1000px"></div>
    </body>
    """)
  end
end

require Logger
webserver = {Plug.Cowboy, plug: MyPlug, scheme: :http, options: [port: 4000]}
{:ok, _} = Supervisor.start_link([webserver], strategy: :one_for_one)
Logger.info("Plug now running on localhost:4000")
Process.sleep(:infinity)
