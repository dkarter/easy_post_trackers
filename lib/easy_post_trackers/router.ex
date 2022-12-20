defmodule EasyPostTrackers.Router do
  use Plug.Router

  # define the routes for the API
  plug(:match)
  plug(:dispatch)

  # define the route for retrieving the carrier tracking data
  get "/carriers" do
    # retrieve the carrier data from the cache
    carriers = EasyPostTrackers.CarrierCache.get_carriers()

    # return the carrier data as a JSON response
    send_resp(conn, :ok, Jason.encode!(carriers))
  end
end
