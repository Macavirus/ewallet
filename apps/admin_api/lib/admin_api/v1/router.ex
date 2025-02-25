# Copyright 2018-2019 OmiseGO Pte Ltd
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

defmodule AdminAPI.V1.Router do
  @moduledoc """
  Routes for the Admin API endpoints.
  """
  use AdminAPI, :router
  alias AdminAPI.V1.AdminAPIAuthPlug

  # Pipeline for plugs to apply for all endpoints
  pipeline :api do
    plug(:accepts, ["json"])
  end

  # Pipeline for endpoints that require user authentication or provider
  # authentication
  pipeline :admin_api do
    plug(AdminAPIAuthPlug)
  end

  # Authenticated endpoints
  scope "/", AdminAPI.V1 do
    pipe_through([:api, :admin_api])

    post("/auth_token.switch_account", AdminAuthController, :switch_account)

    # Exports
    post("/export.all", ExportController, :all)
    post("/export.get", ExportController, :get)
    post("/export.download", ExportController, :download)

    # Exchange pair endpoints
    post("/exchange_pair.all", ExchangePairController, :all)
    post("/exchange_pair.get", ExchangePairController, :get)
    post("/exchange_pair.create", ExchangePairController, :create)
    post("/exchange_pair.update", ExchangePairController, :update)
    post("/exchange_pair.delete", ExchangePairController, :delete)

    # Token endpoints
    post("/token.all", TokenController, :all)
    post("/token.get", TokenController, :get)
    post("/token.create", TokenController, :create)
    post("/token.update", TokenController, :update)
    post("/token.enable_or_disable", TokenController, :enable_or_disable)
    post("/token.stats", TokenController, :stats)
    post("/token.get_mints", MintController, :all_for_token)
    post("/token.mint", MintController, :mint)
    post("/token.upload_avatar", TokenController, :upload_avatar)

    # Transaction endpoints
    post("/transaction.all", TransactionController, :all)
    post("/transaction.export", TransactionController, :export)
    post("/transaction.get", TransactionController, :get)
    post("/transaction.create", TransactionController, :create)
    post("/transaction.calculate", TransactionCalculationController, :calculate)

    post("/transaction_request.all", TransactionRequestController, :all)
    post("/transaction_request.create", TransactionRequestController, :create)
    post("/transaction_request.get", TransactionRequestController, :get)
    post("/transaction_request.consume", TransactionConsumptionController, :consume)

    post(
      "/transaction_request.get_transaction_consumptions",
      TransactionConsumptionController,
      :all_for_transaction_request
    )

    post("/transaction_consumption.all", TransactionConsumptionController, :all)
    post("/transaction_consumption.get", TransactionConsumptionController, :get)
    post("/transaction_consumption.approve", TransactionConsumptionController, :approve)
    post("/transaction_consumption.reject", TransactionConsumptionController, :reject)
    post("/transaction_consumption.cancel", TransactionConsumptionController, :cancel)

    # Category endpoints
    post("/category.all", CategoryController, :all)
    post("/category.get", CategoryController, :get)
    post("/category.create", CategoryController, :create)
    post("/category.update", CategoryController, :update)
    post("/category.delete", CategoryController, :delete)

    # Account endpoints
    post("/account.all", AccountController, :all)
    post("/account.get", AccountController, :get)
    post("/account.create", AccountController, :create)
    post("/account.update", AccountController, :update)
    post("/account.upload_avatar", AccountController, :upload_avatar)

    post(
      "/account.get_wallets_and_user_wallets",
      AccountWalletController,
      :all_for_account_and_users
    )

    post("/account.get_wallets", AccountWalletController, :all_for_account)
    post("/account.get_users", UserController, :all_for_account)
    post("/account.get_descendants", AccountController, :descendants_for_account)
    post("/account.get_transactions", TransactionController, :all_for_account)
    post("/account.get_transaction_requests", TransactionRequestController, :all_for_account)

    post(
      "/account.get_transaction_consumptions",
      TransactionConsumptionController,
      :all_for_account
    )

    # Account membership endpoints
    post("/account.assign_user", AccountMembershipController, :assign_user)
    post("/account.unassign_user", AccountMembershipController, :unassign_user)
    post("/account.assign_key", AccountMembershipController, :assign_key)
    post("/account.unassign_key", AccountMembershipController, :unassign_key)

    post(
      "/account.get_admin_user_memberships",
      AccountMembershipController,
      :all_admin_memberships_for_account
    )

    post(
      "/account.get_key_memberships",
      AccountMembershipController,
      :all_key_memberships_for_account
    )

    # deprecated
    post(
      "/account.get_members",
      AccountMembershipDeprecatedController,
      :all_admin_for_account
    )

    # User endpoints
    post("/user.all", UserController, :all)
    post("/user.get", UserController, :get)
    post("/user.login", UserAuthController, :login)
    post("/user.logout", UserAuthController, :logout)
    post("/user.create", UserController, :create)
    post("/user.update", UserController, :update)
    post("/user.get_wallets", WalletController, :all_for_user)
    post("/user.get_transactions", TransactionController, :all_for_user)
    post("/user.get_transaction_consumptions", TransactionConsumptionController, :all_for_user)
    post("/user.enable_or_disable", UserController, :enable_or_disable)

    # Wallet endpoints
    post("/wallet.all", WalletController, :all)
    post("/wallet.get_balances", BalanceController, :all_for_wallet)
    post("/wallet.get", WalletController, :get)
    post("/wallet.create", WalletController, :create)
    post("/wallet.enable_or_disable", WalletController, :enable_or_disable)

    post(
      "/wallet.get_transaction_consumptions",
      TransactionConsumptionController,
      :all_for_wallet
    )

    # Blockchain wallet endpoints
    post("/blockchain_wallet.get_balances", BlockchainBalanceController, :all_for_wallet)

    # Admin endpoints
    post("/admin.all", AdminUserController, :all)
    post("/admin.get", AdminUserController, :get)
    post("/admin.create", AdminUserController, :create)
    post("/admin.update", AdminUserController, :update)
    post("/admin.enable_or_disable", AdminUserController, :enable_or_disable)

    post(
      "/admin.get_account_memberships",
      AccountMembershipController,
      :all_account_memberships_for_admin
    )

    # Role endpoints
    # deprecated
    post("/role.all", RoleController, :all)
    # deprecated
    post("/role.get", RoleController, :get)
    # deprecated
    post("/role.create", RoleController, :create)
    # deprecated
    post("/role.update", RoleController, :update)
    # deprecated
    post("/role.delete", RoleController, :delete)

    # Permission endpoints
    post("/permission.all", PermissionController, :all)

    # API Access endpoints
    post("/access_key.all", KeyController, :all)
    post("/access_key.get", KeyController, :get)
    post("/access_key.create", KeyController, :create)
    post("/access_key.enable_or_disable", KeyController, :enable_or_disable)
    post("/access_key.delete", KeyController, :delete)
    post("/access_key.update", KeyController, :update)

    post(
      "/access_key.get_account_memberships",
      AccountMembershipController,
      :all_account_memberships_for_key
    )

    # API Key endpoints
    post("/api_key.all", APIKeyController, :all)
    post("/api_key.create", APIKeyController, :create)
    post("/api_key.get", APIKeyController, :get)
    post("/api_key.enable_or_disable", APIKeyController, :enable_or_disable)
    post("/api_key.delete", APIKeyController, :delete)

    # Deprecated in PR #535
    post("/api_key.update", APIKeyController, :update)

    # Settings endpoint
    post("/settings.all", SettingsController, :get_settings)

    # Configuration endpoint
    post("/configuration.all", ConfigurationController, :all)
    post("/configuration.update", ConfigurationController, :update)

    # Activity logs endpoint
    post("/activity_log.all", ActivityLogController, :all)

    # 2FA endpoints
    post("/me.create_backup_codes", TwoFactorAuthController, :create_backup_codes)
    post("/me.create_secret_code", TwoFactorAuthController, :create_secret_code)
    post("/me.enable_2fa", TwoFactorAuthController, :enable)
    post("/me.disable_2fa", TwoFactorAuthController, :disable)

    # Self endpoints (operations on the currently authenticated user)
    post("/me.get", SelfController, :get)
    post("/me.get_accounts", SelfController, :get_accounts)
    post("/me.get_account", SelfController, :get_account)
    post("/me.update", SelfController, :update)
    post("/me.update_password", SelfController, :update_password)
    post("/me.update_email", SelfController, :update_email)
    post("/me.upload_avatar", SelfController, :upload_avatar)

    post("/me.logout", AdminAuthController, :logout)

    # Simulate a server error. Useful for testing the internal server error response
    # and error reporting. Locked behind authentication to prevent spamming.
    post("/status.server_error", StatusController, :server_error)
  end

  # Public endpoints and Fallback endpoints.
  # Handles all remaining routes
  # that are not handled by the scopes above.
  scope "/", AdminAPI.V1 do
    pipe_through([:api])

    post("/admin.login", AdminAuthController, :login)
    post("/admin.login_2fa", TwoFactorAuthController, :login)
    post("/invite.accept", InviteController, :accept)

    # Forget Password endpoints
    post("/admin.reset_password", ResetPasswordController, :reset)
    post("/admin.update_password", ResetPasswordController, :update)

    # Verifying email update request is unauthenticated, because the user
    # may be opening and verifying the email from a different device.
    post("/admin.verify_email_update", SelfController, :verify_email)

    post("/status", StatusController, :index)

    match(:*, "/*path", FallbackController, :not_found)
  end
end
