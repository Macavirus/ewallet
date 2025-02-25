use Mix.Config

config :ewallet_config,
  ecto_repos: [EWalletConfig.Repo],
  settings_mappings: %{
    "email_adapter" => %{
      "smtp" => Bamboo.SMTPAdapter,
      "local" => Bamboo.LocalAdapter,
      "test" => Bamboo.TestAdapter,
      "_" => Bamboo.LocalAdapter
    }
  },
  default_settings: %{
    # Global Settings
    "master_account" => %{
      key: "master_account",
      value: "",
      type: "string",
      position: 000,
      description:
        "The master account of this eWallet, which will be used as the default account when needed."
    },
    "base_url" => %{
      key: "base_url",
      value: "",
      type: "string",
      position: 100,
      description: "The URL where the base of the eWallet is accessible from."
    },
    "redirect_url_prefixes" => %{
      key: "redirect_url_prefixes",
      value: [],
      type: "array",
      position: 101,
      description:
        "The URL prefixes where the eWallet are allowed to redirect to (for password resets, etc.)"
    },
    "enable_standalone" => %{
      key: "enable_standalone",
      value: false,
      type: "boolean",
      position: 102,
      description:
        "Enables the /user.signup endpoint in the client API, allowing users to sign up directly."
    },
    "max_per_page" => %{
      key: "max_per_page",
      value: 100,
      type: "unsigned_integer",
      position: 103,
      description: "The maximum number of records that can be returned for a list."
    },
    "min_password_length" => %{
      key: "min_password_length",
      value: 8,
      type: "unsigned_integer",
      position: 104,
      description: "The minimum length for passwords."
    },
    "forget_password_request_lifetime" => %{
      key: "forget_password_request_lifetime",
      value: 10,
      type: "unsigned_integer",
      position: 105,
      description: "The duration (in minutes) that a forget password request will be valid for."
    },
    "number_of_backup_codes" => %{
      key: "number_of_backup_codes",
      value: 10,
      type: "unsigned_integer",
      position: 106,
      description: "The number of backup codes for the two-factor authentication."
    },
    "two_fa_issuer" => %{
      key: "two_fa_issuer",
      value: "OmiseGO",
      type: "string",
      position: 107,
      description:
        "The issuer for the two-factor authentication, which will be displayed the OTP app."
    },

    # Email Settings
    "sender_email" => %{
      key: "sender_email",
      value: "admin@localhost",
      type: "string",
      position: 200,
      description: "The address from which system emails will be sent."
    },
    "email_adapter" => %{
      key: "email_adapter",
      value: "local",
      type: "string",
      position: 201,
      options: ["smtp", "local", "test"],
      description:
        "When set to local, a local email adapter will be used. Perfect for testing and development."
    },
    "smtp_host" => %{
      key: "smtp_host",
      value: nil,
      type: "string",
      position: 202,
      description: "The SMTP host to use to send emails.",
      parent: "email_adapter",
      parent_value: "smtp"
    },
    "smtp_port" => %{
      key: "smtp_port",
      value: nil,
      type: "string",
      position: 203,
      description: "The SMTP port to use to send emails.",
      parent: "email_adapter",
      parent_value: "smtp"
    },
    "smtp_username" => %{
      key: "smtp_username",
      value: nil,
      type: "string",
      position: 204,
      description: "The SMTP username to use to send emails.",
      parent: "email_adapter",
      parent_value: "smtp"
    },
    "smtp_password" => %{
      key: "smtp_password",
      value: nil,
      type: "string",
      position: 205,
      description: "The SMTP password to use to send emails.",
      parent: "email_adapter",
      parent_value: "smtp"
    },

    # Balance Caching Settings
    "balance_caching_strategy" => %{
      key: "balance_caching_strategy",
      value: "since_beginning",
      type: "string",
      position: 300,
      options: ["since_beginning", "since_last_cached"],
      description:
        "The strategy to use for balance caching. It will either re-calculate from the beginning or from the last caching point."
    },
    "balance_caching_frequency" => %{
      key: "balance_caching_frequency",
      # Daily at 2am: 0 2 * * *
      # Every Friday at 5am: 0 5 * * 5
      value: "0 2 * * *",
      type: "string",
      position: 301,
      description:
        "The frequency to compute the balance cache. Expecting a 5-field crontab format. For example, 0 2 * * * for a daily run at 2AM."
    },

    # Balance Caching Reset Frequency
    "balance_caching_reset_frequency" => %{
      key: "balance_caching_reset_frequency",
      value: 10,
      type: "unsigned_integer",
      position: 301,
      parent: "balance_caching_strategy",
      parent_value: "since_last_cached",
      description:
        "A counter is incremented everytime balances are cached, once reaching the given reset frequency,
      the balances are re-calculated from the beginning and the counter is reset.
      Set to 0 to always cache balances based on the previous cached value"
    },

    # File Storage settings
    "file_storage_adapter" => %{
      key: "file_storage_adapter",
      value: "local",
      type: "string",
      position: 400,
      options: ["local", "gcs", "aws"],
      description: "The type of storage to use for images and files."
    },

    # File Storage: GCS Settings
    "gcs_bucket" => %{
      key: "gcs_bucket",
      value: nil,
      type: "string",
      position: 500,
      parent: "file_storage_adapter",
      parent_value: "gcs",
      description: "The name of the GCS bucket."
    },
    "gcs_credentials" => %{
      key: "gcs_credentials",
      value: nil,
      secret: true,
      type: "string",
      position: 501,
      parent: "file_storage_adapter",
      parent_value: "gcs",
      description: "The credentials of the Google Cloud account."
    },

    # File Storage: AWS Settings
    "aws_bucket" => %{
      key: "aws_bucket",
      value: nil,
      type: "string",
      position: 600,
      parent: "file_storage_adapter",
      parent_value: "aws",
      description: "The name of the AWS bucket."
    },
    "aws_region" => %{
      key: "aws_region",
      value: nil,
      type: "string",
      position: 601,
      parent: "file_storage_adapter",
      parent_value: "aws",
      description: "The AWS region where your bucket lives."
    },
    "aws_access_key_id" => %{
      key: "aws_access_key_id",
      value: nil,
      type: "string",
      position: 602,
      parent: "file_storage_adapter",
      parent_value: "aws",
      description: "An AWS access key having access to the specified bucket."
    },
    "aws_secret_access_key" => %{
      key: "aws_secret_access_key",
      value: nil,
      secret: true,
      type: "string",
      position: 603,
      parent: "file_storage_adapter",
      parent_value: "aws",
      description: "An AWS secret having access to the specified bucket."
    }
  }

config :ewallet_config, EWalletConfig.Repo,
  adapter: Ecto.Adapters.Postgres,
  pool: DB.SharedConnectionPool,
  pool_size: {:system, "EWALLET_POOL_SIZE", 15, {String, :to_integer}},
  shared_pool_id: :ewallet,
  migration_timestamps: [type: :naive_datetime_usec]

import_config "#{Mix.env()}.exs"
