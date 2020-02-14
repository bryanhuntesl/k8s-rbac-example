defmodule PodViewer.Handlers.Pods do
  @moduledoc """
  Fetches the Kubernetes pod listing endpoint and returns it as is to
  the requestor.
  """

  use Plug.Router

  plug(Plug.Logger)
  plug(:match)
  plug(:dispatch)

  # Fetch pod listing endpoint
  get "/reader/v1/pods", do: list_pods(conn)

  # Fetch pod listing endpoint for a given namespace
  get "/reader/v1/:namespace/pods", do: list_pods(conn, namespace)

  # Redirect root requests to /reader/v1/pods
  match "/" do
    conn
    |> put_resp_header("location", "/reader/v1/pods")
    |> send_resp(301, "")
  end

  # Catch-all for not found
  match _ do
    send_resp(conn, 404, "")
  end

  defp list_pods(conn), do: list_pods(conn, System.get_env("MY_POD_NAMESPACE"))
  defp list_pods(conn, namespace) do
    k8s_conn = K8s.Conn.from_service_account(:default)
    operation = K8s.Client.list("v1", "pods", namespace: namespace)
    conn = fetch_query_params(conn)
    # TODO: handle errors (non 200 responses)
    {:ok, resp} = K8s.Client.run(operation, k8s_conn, [params: conn.query_params])
    body = Jason.encode!(resp, pretty: true)
    send_resp(conn, 200, body)
  end
end
