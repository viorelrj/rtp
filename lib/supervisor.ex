# defmodule WorkerSupervisor do
#   use GenServer

#   def start_link(opts) do
#     GenServer.start_link(__MODULE__, :ok, opts)
#   end

#   def create(server, pid) do
#     GenServer.cast(server, {:create, pid})
#   end

#   @impl true
#   def init(:ok) do
#     {:ok, []}
#   end

#   @impl true
#   def handle_cast({:create, pid}, refs) do
#     if Map.has_key?(refs, pid) do
#       {:noreply, refs}
#     else
#       {:ok, pid} = DynamicSupervisor.start_child(KV.BucketSupervisor, KV.Bucket)
#       ref = Process.monitor(pid)
#       refs = [refs] ++ [ref]
#       {:noreply, refs}
#     end
#   end

#   @impl true
#   def handle_info({:DOWN, ref, :process, _pid, _reason}, refs) do
#     {name, refs} = Map.pop(refs, ref)
#     {:noreply, {names, refs}}
#   end

#   @impl true
#   def handle_info(_msg, state) do
#     {:noreply, state}
#   end
# end
