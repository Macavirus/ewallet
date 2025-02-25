# Copyright 2019 OmiseGO Pte Ltd
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

defmodule EthBlockchain.AdapterTest do
  use EthBlockchain.EthBlockchainCase
  alias EthBlockchain.Adapter

  describe "call/3" do
    test "delegates call to the adapter", state do
      dumb_resp1 =
        Adapter.call(
          :dumb,
          {:get_balances, "0x123", ["0x01", "0x02", "0x03"], "latest"},
          state[:pid]
        )

      dumb_resp2 =
        Adapter.call(
          {:dumb, "balance"},
          {:get_balances, "0x123", ["0x01", "0x02", "0x03"], "latest"},
          state[:pid]
        )

      assert {:ok, %{"0x01" => 123, "0x02" => 123, "0x03" => 123}} == dumb_resp1
      assert {:ok, %{"0x01" => 123, "0x02" => 123, "0x03" => 123}} == dumb_resp2
    end

    test "shutdowns the worker once finished handling tasks", state do
      {:ok, _} =
        Adapter.call(
          :dumb,
          {:get_balances, "0x123", ["0x01", "0x02", "0x03"], "latest"},
          state[:pid]
        )

      {:ok, _} =
        Adapter.call(
          {:dumb, "balance"},
          {:get_balances, "0x123", ["0x01", "0x02", "0x03"], "latest"},
          state[:pid]
        )

      {:ok, _} =
        Adapter.call(
          :dumb,
          {:get_balances, "0x123", ["0x01", "0x02", "0x03"], "latest"},
          state[:pid]
        )

      childrens = DynamicSupervisor.which_children(state[:supervisor])
      assert childrens == []
    end

    test "returns an error if no such adapter is registered", state do
      assert {:error, :no_handler} ==
               Adapter.call(
                 :foobar,
                 {:get_balances, "0x123", ["0x01", "0x02", "0x03"], "latest"},
                 state[:pid]
               )
    end
  end
end
