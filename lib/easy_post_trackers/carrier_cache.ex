defmodule EasyPostTrackers.CarrierCache do
  use GenServer

  require Logger

  @cache_reset_interval :timer.hours(24)

  # ------ Public API

  def get_carriers do
    GenServer.call(__MODULE__, :get_carriers)
  end

  # ------ GenServer Impl

  def start_link([]) do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  # define the GenServer callback functions
  @impl GenServer
  def init(_) do
    # clear the cache periodically
    :timer.send_interval(@cache_reset_interval, :clear_cache)

    # start the GenServer with an empty list of carriers
    {:ok, []}
  end

  @impl GenServer
  def handle_info(:clear_cache, _carriers) do
    Logger.info("Clearing carrier cache")
    {:noreply, []}
  end

  @impl GenServer

  def handle_call(:get_carriers, _from, []) do
    Logger.info("Carrier cache miss - getting carriers from EasyPost website and storing them")

    # retrieve the HTML content from the EasyPost API documentation page
    %Req.Response{body: html} = Req.get!("https://www.easypost.com/docs/api")

    # parse the HTML to extract the carriers table
    carrier_rows =
      html
      |> Floki.parse_document!()
      |> Floki.find(".row.carrier-strings table tbody tr")

    # extract the carrier codes and names from the table rows
    carriers =
      carrier_rows
      |> Enum.map(fn row ->
        [name, code] =
          row
          |> Floki.find("td")
          |> Enum.map(&Floki.text/1)

        %{code: code, name: name}
      end)

    # cache the carriers data in the GenServer state
    {:reply, carriers, carriers}
  end

  def handle_call(:get_carriers, _from, carriers) do
    Logger.info("Carrier cache hit - returning carriers from in memory cache")
    {:reply, carriers, carriers}
  end
end
